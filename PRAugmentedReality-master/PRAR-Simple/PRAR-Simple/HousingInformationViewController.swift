//
//  HousingInformationViewController.swift
//  PRAR-Simple
//
//  Created by Jingrong (: on 7/11/15.
//  Copyright © 2015 GeoffroyLesage. All rights reserved.
//

import UIKit

class HousingInformationViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var allCheckoutItemTiles: UICollectionView!
    
    @IBOutlet weak var buttonView: UIButton!
    
    var global_uid: String!
    var dataSet : 
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.yellowColor()
        global_uid = AppDelegate.getGlobalString()
        allCheckoutItemTiles.delegate = self
        allCheckoutItemTiles.dataSource = self
        allCheckoutItemTiles.superview?.backgroundColor = UIColor.whiteColor()
        
        AppDelegate.clearGlobalString()
    }
    
    // Collection View Stuff
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = allCheckoutItemTiles.dequeueReusableCellWithReuseIdentifier("HousingInformationViewCell", forIndexPath: indexPath) as! HousingInformationViewCell
//        cell.setUpCell()
        if (indexPath.item < 5) {
            cell.backgroundColor = UIColor.clearColor()
        } else {
            cell.backgroundColor = UIColor.grayColor()
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
