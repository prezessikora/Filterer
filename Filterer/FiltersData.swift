//
//  FilterMenu.swift
//  Filterer
//
//  Created by Krzysztof Sikora on 23/05/17.
//  Copyright © 2017 Design Love. All rights reserved.
//

import UIKit

class FiltersData {
    
    var filterImages: [UIImage] = []
    
    var filters: [Filter] = [RedAmplificationFilter(amplifyColor: .Red),RedAmplificationFilter(amplifyColor: .Green),RedAmplificationFilter(amplifyColor: .Blue),GrayScaleFilter(),BrightnessFilter(brightnessChange: 1.5),BrightnessFilter(brightnessChange: 0.5)]
    
    init() {
        
    }
    
    func initializeThumbnails() {
        
        let image = UIImage(named:"sample")!
        
        for f in filters {
            let ip = ImageProcessing(image: image)
            ip.addFilter(f)
            filterImages.append(ip.applyFilters()!)
        }
        print("Finished initializing thumbnails.")


    }
    
    func getFilterImages() -> [UIImage] {
        return filterImages
    }
}
