//
//  ZoomingAndScrolling.swift
//  Filterer
//
//  Created by Krzysztof Sikora on 06/06/17.
//  Copyright © 2017 Design Love. All rights reserved.
//

import UIKit

extension ViewController {
    
    // which view to zoom
    
    func viewForZoomingInScrollView(sv: UIScrollView) -> UIView? {
        if sv == scrollView {
            return imageView
        } else if sv == scrollViewFiltered {
            return filteredImageView
        } else {
            return filteredImageView2
        }
    }
    
    // sync 3 views scroll offset
    
    func scrollViewDidScroll(sv: UIScrollView) {

        scrollView.contentOffset.x = sv.contentOffset.x
        scrollView.contentOffset.y = sv.contentOffset.y
        
        scrollViewFiltered.contentOffset.x = sv.contentOffset.x
        scrollViewFiltered.contentOffset.y = sv.contentOffset.y

        
        scrollViewFiltered2.contentOffset.x = sv.contentOffset.x
        scrollViewFiltered2.contentOffset.y = sv.contentOffset.y
    }
    
    // sync 3 views zoom scale
    
    func scrollViewDidZoom(sv: UIScrollView) {
        scrollView.zoomScale = sv.zoomScale
        scrollViewFiltered.zoomScale = sv.zoomScale
        scrollViewFiltered2.zoomScale = sv.zoomScale
    }
    
    // zoom handlers
    
    @IBAction func onTap(sender: AnyObject) {
        currentImage!.onTap()
    }
    
    @IBAction func onTap2(sender: AnyObject) {
        currentImage!.onTap()
    }
    
    
    @IBAction func onTap3(sender: AnyObject) {
        currentImage!.onTap()
    }

}