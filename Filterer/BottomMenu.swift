//
//  BottomMenu.swift
//  Filterer
//
//  Created by Krzysztof Sikora on 02/06/17.
//  Copyright © 2017 Design Love. All rights reserved.
//

import UIKit

extension ViewController {
    @IBAction func onShare(sender: AnyObject) {
        
        let imageToShare = imageView.image
        
        let activityController = UIActivityViewController(activityItems: ["Check our or new cool app!",imageToShare!], applicationActivities: nil)
        
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    @IBAction func onCompareButton(sender: AnyObject) {
        //currentImage!.onCompare()
        if imageView.image == originalImage {
            
            UIView.transitionWithView(imageView,duration: 0.4,options: UIViewAnimationOptions.TransitionCrossDissolve,animations: {
                self.imageView.image = self.filteredImage
                },completion: nil)

            originalLabel.hidden = true


        } else {
            UIView.transitionWithView(imageView,duration: 0.4,options: UIViewAnimationOptions.TransitionCrossDissolve,animations: {
                self.imageView.image = self.originalImage
                },completion: nil)
            originalLabel.hidden = false
            
        }
    }

    
    @IBAction func onFilter(sender: UIButton) {
        if self.filterEditMenu.alpha > 0.0 {
            hideMenu(filterEditMenu)
            editButton.selected = false
        }
        
        if (sender.selected) {
            hideMenu(filtersList)
            sender.selected = false
        }
        else {
            showMenu(filtersList,height: CGFloat(80))
            sender.selected = true
        }
        
    }
    
    @IBAction func onEdit(sender: UIButton) {
        if self.filtersList.alpha > 0.0 {
            hideMenu(filtersList)
            filterButton.selected = false
        }
        
        if (sender.selected) {
            hideMenu(filterEditMenu)
            sender.selected = false
        }
        else {
            showMenu(filterEditMenu,height: CGFloat(44))
            sender.selected = true
        }
        
    }

}