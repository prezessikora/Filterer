//
//  FiltersViewController.swift
//  Filterer
//
//  Created by Krzysztof Sikora on 30/05/17.
//  Copyright © 2017 Design Love. All rights reserved.
//

import UIKit

extension ViewController {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fd.getFilterImages().count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FiltersCell", forIndexPath: indexPath) as! FilterCell
       
        cell.imageView.image = fd.getFilterImages()[indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        applyFilter(fd.filters[indexPath.item])
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.top * 2
        let availableHeight = filtersList.frame.height - paddingSpace
        
        let cellSize = CGSize(width: availableHeight, height: availableHeight)
        
        return cellSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
