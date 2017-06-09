
//
//  ViewController.swift
//  Filterer
//
//  Created by Krzysztof Sikora on 10/05/17.
//  Copyright © 2017 Design Love. All rights reserved.
//

import UIKit
import Dispatch

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
    // bottom menu
    
    @IBOutlet weak var bottomMenu: UIView!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var compareButton: UIButton!
    
    // images
    
    var originalImage: UIImage?
    
    var filteredImage: UIImage?


    @IBOutlet weak var imageView: UIImageView!
   
    @IBOutlet weak var originalLabel: UILabel!
    
    // additional menus
    
    @IBOutlet var filterEditMenu: UIView!
    
    @IBOutlet var filtersList: UIView!
    
    // filters collection view
    
    let sectionInsets = UIEdgeInsets(top: 2.0, left: 5.0, bottom: 2.0, right: 5.0)
    
    let fd  = FiltersData()
    
    @IBOutlet weak var filtersCollection: UICollectionView!
        
    // scrolling zooming
    
    @IBOutlet weak var scrollView: UIScrollView!

    
    var ip = ImageProcessing()
    
    @IBOutlet weak var intensitySlider: UISlider!
    
    @IBAction func onSlider(sender: AnyObject) {
        let slider = sender as! UISlider as UISlider
        ip.updateIntensity((slider.value))
        applyFilter()
    }
  
    
    func setUpTapRecognizers() {
  
        let tapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handlePress(_:)))
        tapRecognizer.minimumPressDuration = 0.5
        
        scrollView.addGestureRecognizer(tapRecognizer)
        

        let tapRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.onDoubleTap(_:)))
        tapRecognizer2.numberOfTapsRequired = 2
        
        scrollView.addGestureRecognizer(tapRecognizer2)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        filterEditMenu.translatesAutoresizingMaskIntoConstraints = false
        filtersList.translatesAutoresizingMaskIntoConstraints = false
        
        filtersList.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        filterEditMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        setUpTapRecognizers()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.fd.initializeThumbnails()
        })
        
      
        originalLabel.alpha = 0.5
    }
    
    func onDoubleTap(sender: UITapGestureRecognizer) {

        UIView.animateWithDuration(0.4, animations: {
            self.scrollView.zoomScale = 1.5 * self.scrollView.zoomScale
        })

    }
    
    func handlePress(sender: UITapGestureRecognizer) {
        
        if filteredImage != nil {
            if (sender.state == .Began) || (sender.state == .Ended) {
                if imageView.image == originalImage {
                    imageView.image = filteredImage
                    originalLabel.hidden = true
                } else {
                    imageView.image = originalImage
                    originalLabel.hidden = false
                }
            }
        }
    }
    
    func showMenu(menu: UIView, height: CGFloat) {
        view.addSubview(menu)
        
        let bottomConstraint = menu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = menu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = menu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = menu.heightAnchor.constraintEqualToConstant(height)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint,leftConstraint,rightConstraint,heightConstraint])
        
        view.layoutIfNeeded()

        menu.alpha = 0
        UIView.animateWithDuration(0.4) {
            menu.alpha = 1.0
        }
    }
    
    func hideMenu(menu: UIView) {
        UIView.animateWithDuration(0.4, animations: {
            menu.alpha = 0.0
            },completion: { (completed: Bool) -> Void in
                if (completed == true) {
                    menu.removeFromSuperview()
                }
        })
    }
   
    func applyFilter(filter: Filter) {
        ip.clearFilters()
        filter.setAmplificationRatio((intensitySlider.value))
        ip.addFilter(filter)
        applyFilter()
    }
    
    func applyFilter() {
        
        let resultImage = ip.applyFilters()
        
        filteredImage = resultImage
        
        UIView.transitionWithView(imageView,duration: 0.4,options: UIViewAnimationOptions.TransitionCrossDissolve,animations: {
            self.imageView.image = resultImage
            },completion: nil)
        
        originalLabel.hidden = true
        compareButton.enabled = true
        editButton.enabled = true
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}

