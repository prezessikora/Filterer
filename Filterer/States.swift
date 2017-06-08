//
//  States.swift
//  Filterer
//
//  Created by Krzysztof Sikora on 02/06/17.
//  Copyright © 2017 Design Love. All rights reserved.
//

import UIKit

class NoImage {
    
    let controller: ViewController
    
    init(controller: ViewController) {
        self.controller = controller
    }
    
    func onShare(sender: AnyObject) {}
    
    func applyFilter() {}
    
    func onCompare() {}
    
    func switchImage() {}
    
    func onTap() {}
    
}

class Original: NoImage {
    
    override func onTap() {
        
        UIView.animateWithDuration(0.4, animations: {
            self.controller.scrollView.zoomScale = 1.5 * self.controller.scrollView.zoomScale
        })

    }
    
    override func switchImage() {
       controller.showfilteredImage()
    }
    
    override func onCompare() {
        controller.setView(to: .Filtered)
        controller.showActiveFilteredImage()
    }
    
    override func onShare(sender: AnyObject) {
        
        let imageToShare = controller.imageView.image
        
        let activityController = UIActivityViewController(activityItems: ["Check our or new cool app!",imageToShare!], applicationActivities: nil)
        
        controller.presentViewController(activityController, animated: true, completion: nil)
    }
    
    override func applyFilter() {
        let resultImage = controller.ip.applyFilters()
        
        controller.filteredImageView.image = resultImage
        
        UIView.animateWithDuration(1, animations: {
            self.controller.scrollViewFiltered.alpha = 1.0
        })
        
        
        controller.filteredImageActive = .First
        
        controller.setView(to: .Filtered)
        controller.compareButton.enabled = true
        controller.editButton.enabled = true
        
    }
}

class Filtered: NoImage {
    
    override func onTap() {
        UIView.animateWithDuration(0.4, animations: {
          switch self.controller.filteredImageActive {
                
            case .First:
                self.controller.scrollViewFiltered.zoomScale = 1.5 * self.controller.scrollViewFiltered.zoomScale
            case .Second:
                self.controller.scrollViewFiltered2.zoomScale = 1.5 * self.controller.scrollViewFiltered2.zoomScale
            case .NoImage:
                return
            }

            
        })
    }
    
    override func switchImage() {
        controller.showOriginalImage()
    }
    
    override func onCompare() {
        controller.setView(to: .Original)
        controller.showOriginalImage()
    }
    
    override func onShare(sender: AnyObject) {
        
        var imageToShare = controller.imageView.image
        
        switch controller.filteredImageActive {
            
        case .First:
            imageToShare = controller.filteredImageView.image
        case .Second:
            imageToShare = controller.filteredImageView2.image
        case .NoImage:
            return
        }
        
        let activityController = UIActivityViewController(activityItems: ["Check our or new cool app!",imageToShare!], applicationActivities: nil)
        
        controller.presentViewController(activityController, animated: true, completion: nil)
        
    }
    
    override func applyFilter() {
        
        let resultImage = controller.ip.applyFilters()
        
        if controller.filteredImageActive == .First {
            
            controller.filteredImageView2.image = resultImage
            UIView.animateWithDuration(1, animations: {
                self.controller.scrollViewFiltered2.alpha = 1.0
            })
            controller.filteredImageActive = .Second
            
            
        } else {
            controller.scrollViewFiltered.alpha = 1
            controller.filteredImageView.image = resultImage
            UIView.animateWithDuration(1, animations: {
                self.controller.scrollViewFiltered2.alpha = 0.0
            })
            controller.filteredImageActive = .First
            
        }
        
        controller.setView(to: .Filtered)
        controller.compareButton.enabled = true
        controller.editButton.enabled = true
        
    }
}
