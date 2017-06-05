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
        currentImage!.onShare(sender)
    }
    
    @IBAction func onCompareButton(sender: AnyObject) {
        currentImage!.onCompare()
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