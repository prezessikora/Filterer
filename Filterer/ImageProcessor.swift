//
//  ImageProcessor.swift
//  Filterer
//
//  Created by Krzysztof Sikora on 10/05/17.
//  Copyright © 2017 Design Love. All rights reserved.
//

import Foundation

import UIKit

protocol Filter {
    
    // process pixel by pixel to produce filter result
    func processPixel (pixel: Pixel) -> Pixel
    
    // do any precalculations that are to be used in main processing
    func setup(image: UIImage)
    
    func setAmplificationRatio(value: Float)
    
}

extension Filter {
    
    func setup(image: UIImage) {
        // do nothing by default, override when needed
    }
    
    func apply (image: UIImage) -> UIImage {
        
        var myRGBA = RGBAImage(image: image)!
        
        for i in 0..<myRGBA.width*myRGBA.height {
            
            myRGBA.pixels[i] = processPixel(myRGBA.pixels[i])
        }
        return myRGBA.toUIImage()!
    }
    
    
    
}

class ImageProcessing {
    
    var predefinedFilters = [String:Filter]()
    
    var sourceImage: UIImage?
    
    var filters = [Filter]()
    
    var intensity: Int = 5
    
    init() {
        
    }
    
    init (image: UIImage) {
        sourceImage = image
        predefinedFilters["10% Brightness"] = BrightnessFilter()
        predefinedFilters["50% Darker"] = BrightnessFilter(brightnessChange: 0.5)
        predefinedFilters["Overexpose"] = BrightnessFilter(brightnessChange: 1.6)
        predefinedFilters["Grayscale"] = GrayScaleFilter()
        predefinedFilters["RedAmplification"] = RedAmplificationFilter(amplifyColor: .Red)
    }
    
    func setImage(image: UIImage) {
        sourceImage = image
    }
    
    func updateIntensity(vale: Float) {
        for f in filters {
            f.setAmplificationRatio(vale)
        }
    }
    
    func applyFilters() -> UIImage? {
        
        var result: UIImage? = nil
        
        if let image = sourceImage {

            for f in filters {
                f.setup(image)
                result = f.apply(image)
            }
        }
        
        return result
    }
    
    func addFilter(f: Filter) {
        filters.append(f)
    }
    
    func clearFilters() {
        filters.removeAll()
    }
    
    func applyPredefinedFilter(byName: String) -> UIImage? {        
        
        if let image = sourceImage {
            return (predefinedFilters[byName]?.apply(image))!
        }
        
        return nil;
        
    }
    
}

enum FilterColor {
    case Red
    case Green
    case Blue
    
    func getPixelValue(p: Pixel) -> Int {
        switch self {
        case Red: return Int(p.red)
        case Green: return Int(p.green)
        case Blue: return Int(p.blue)
        }
    }

    }

class RedAmplificationFilter: Filter {
    
    var amplificationRatio = Float(0.0)
    
    var avgR: Int = 0
    
    var amplifyColor: FilterColor
    
    init (amplifyColor color: FilterColor, amplificationRatio: Float = 5) {
        
        self.amplificationRatio = amplificationRatio
        amplifyColor = color
    }
    
    func setAmplificationRatio(value: Float) {
        self.amplificationRatio = value
    }
    
    func setup(image: UIImage) {
        self.avgR = calculateAverageRed(RGBAImage(image: image)!)
    }
    
    
    func calculateAverageRed(myRGBA: RGBAImage) -> Int {
        var sumR = 0
        
        for i in 0..<myRGBA.width * myRGBA.height {
            let p = myRGBA.pixels[i]
            sumR += amplifyColor.getPixelValue(p)
            
        }
        let count = myRGBA.width*myRGBA.height
        
        return sumR/count
    }
    
    
    func processPixel (p: Pixel) -> Pixel {
        
        var computedPixel = p
        
        switch amplifyColor {
        case .Red:
            let diff = Int(p.red) - avgR
            if (diff > 0) {
                computedPixel.red = UInt8 (max(0,min(255,avgR + diff * Int(amplificationRatio))))
            }
        case .Green:
            let diff = Int(p.green) - avgR
            if (diff > 0) {
                computedPixel.green = UInt8 (max(0,min(255,avgR + diff * Int(amplificationRatio))))
            }
        case .Blue:
            let diff = Int(p.blue) - avgR
            if (diff > 0) {
                computedPixel.blue = UInt8 (max(0,min(255,avgR + diff * Int(amplificationRatio))))
            }
        }

        return computedPixel
        
    }
    
}

class GrayScaleFilter: Filter {
    
    func setAmplificationRatio(value: Float) {
        // do nothing
    }

    
    func processPixel (p: Pixel) -> Pixel {
        
        var computedPixel = p
        
        let maxValue = max(p.red, p.green, p.blue)
        let minValue = min(p.red, p.green, p.blue)
        
        let gray = UInt8((Float(maxValue) + Float(minValue)) / 2)
        
        computedPixel.red = UInt8(gray)
        computedPixel.green = UInt8(gray)
        computedPixel.blue = UInt8(gray)
        
        return computedPixel
        
    }
}

class BrightnessFilter : Filter {
    
    var brightnessChange: Float
    
    init(brightnessChange: Float = 1.1) {
        self.brightnessChange = brightnessChange
    }
    
    func setAmplificationRatio(value: Float) {
        brightnessChange = value
    }

    
    func bound(value: Float) -> Int {
        
        if value > 255 {
            return 255
        }
        else if value < 0 {
            return 0
        }
        
        return Int(value)
    }
    
    func processPixel(pixel: Pixel) -> Pixel {
        var computedPixel = pixel
        
        computedPixel.red = UInt8(bound(Float(pixel.red) * brightnessChange))
        computedPixel.green = UInt8(bound(Float(pixel.green) * brightnessChange))
        computedPixel.blue =  UInt8(bound(Float(pixel.blue) * brightnessChange))
        
        return computedPixel
    }
}
