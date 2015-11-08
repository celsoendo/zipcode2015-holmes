//
//  PropertyDetailViewController.swift
//  PanicAR-Demo
//
//  Created by Jingrong (: on 7/11/15.
//  Copyright © 2015 doPanic GmbH. All rights reserved.
//

import UIKit

class PropertyDetailViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    /* Attributes */
    
    // Storyboard outlets
    @IBOutlet weak var allPropertyTiles: UICollectionView!
    
    override func viewDidLoad() {
        allPropertyTiles.delegate = self
        allPropertyTiles.dataSource = self
    }
    
    // Collection View Stuff
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Total categories
        return 10
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = allPropertyTiles.dequeueReusableCellWithReuseIdentifier("PropertyDetailViewCell", forIndexPath: indexPath) as! PropertyDetailViewCell
        cell.setUpCell()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //        if indexPath.item == 0 {
        //            self.performSegueWithIdentifier("ViewUserToneAnalyzerSegue", sender: self)
        //
        //        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}