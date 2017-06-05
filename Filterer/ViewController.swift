
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
    
    // image views
    
    @IBOutlet weak var imageView: UIImageView!
   
    @IBOutlet weak var filteredImageView: UIImageView!
    
    @IBOutlet weak var filteredImageView2: UIImageView!
    
    
    @IBOutlet weak var originalLabel: UILabel!
    
    // additional menus
    
    @IBOutlet var filterEditMenu: UIView!
    
    @IBOutlet var filtersList: UIView!
    
    // filters collection view
    
    let sectionInsets = UIEdgeInsets(top: 2.0, left: 5.0, bottom: 2.0, right: 5.0)
    
    let fd  = FiltersData()
    
    @IBOutlet weak var filtersCollection: UICollectionView!
        
    var ip = ImageProcessing()
    
    @IBOutlet weak var intensitySlider: UISlider!

    var filteredImageActive : FilteredImage = .NoImage
    
    enum FilteredImage {
        case NoImage
        case First
        case Second
    }
    
    var currentImage: NoImage?
    
    enum CurrentImage {
        case Original
        case Filtered
    }
    
    func setView(to image:CurrentImage) {
        switch image {
        case .Original:
            currentImage = Original(controller: self)
            originalLabel.hidden = false
        case .Filtered:
            currentImage = Filtered(controller: self)
            originalLabel.hidden = true
        }
    }
    
    @IBAction func onSlider(sender: AnyObject) {
        let slider = sender as! UISlider as UISlider
        ip.updateIntensity((slider.value))
        applyFilter()
    }
    
    func showOriginalImage() {
        filteredImageView.alpha = 0
        filteredImageView2.alpha = 0
        setView(to: .Original)
    }
    
    func showfilteredImage() {
        
        switch filteredImageActive {
            
        case .First:
            filteredImageView.alpha = 1
            filteredImageView2.alpha = 0

        case .Second:
            filteredImageView.alpha = 0
            filteredImageView2.alpha = 1
        
        case .NoImage:
            return
        }
        
        setView(to: .Filtered)
    }
    
    func addTapRecognizer(forImage iView: UIImageView) {
        let tapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handlePress(_:)))
        
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapRecognizer)
        
        tapRecognizer.minimumPressDuration = 0
    }
    
    func setUpTapRecognizers() {
        addTapRecognizer(forImage: imageView)
        addTapRecognizer(forImage: filteredImageView)
        addTapRecognizer(forImage: filteredImageView2)
    }        
    
    override func viewDidLoad() {
        
        currentImage = Original(controller: self)
        
        super.viewDidLoad()
        
        filterEditMenu.translatesAutoresizingMaskIntoConstraints = false
        filtersList.translatesAutoresizingMaskIntoConstraints = false
        
        filtersList.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        filterEditMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        //setUpTapRecognizers()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.fd.initializeThumbnails()
        })
        
        
        
        originalLabel.alpha = 0.5
    }
    
    func handlePress(sender: UITapGestureRecognizer) {
        
        if filteredImageActive != .NoImage {
            if (sender.state == .Began) || (sender.state == .Ended) {
                currentImage!.switchImage()
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

        currentImage!.applyFilter()
    }
            
    func showActiveFilteredImage() {
        switch filteredImageActive {
        case .First:
            UIView.animateWithDuration(1, animations: {
                self.filteredImageView.alpha = 1.0
            })
        case .Second:
            UIView.animateWithDuration(1, animations: {
                self.filteredImageView2.alpha = 1.0
            })
        case .NoImage:
            return
        }

    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

