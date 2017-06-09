//
//  NewImage.swift
//  Filterer
//
//  Created by Krzysztof Sikora on 02/06/17.
//  Copyright © 2017 Design Love. All rights reserved.
//

import UIKit

extension ViewController {

    @IBAction func onNewPhoto(sender: AnyObject) {
        
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: {action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: {action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    func cleanUpAfterPreviousImage() {
        if (filtersList.alpha > 0) {
            hideMenu(filtersList)
            filterButton.selected = false
        }
        if (filterEditMenu.alpha > 0) {
            hideMenu(filterEditMenu)
            editButton.selected = false
        }        
    }


    func newImageSelected(image: UIImage) {
        imageView.image = image
        originalImage = image
        
        filterButton.enabled = true
        shareButton.enabled = true
        
        editButton.enabled = false
        compareButton.enabled = false
        
        originalLabel.hidden = true
        
        ip.setImage(image)
        
        cleanUpAfterPreviousImage()
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newImageSelected(image)
        }
        
    }

    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        self.presentViewController(cameraPicker, animated: true, completion: nil)
    }

    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        self.presentViewController(cameraPicker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

