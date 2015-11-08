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
    
    let totalCellCount = 14
    var global_uid: String!
//    var dataSet : 
    
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
        return totalCellCount
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = allCheckoutItemTiles.dequeueReusableCellWithReuseIdentifier("HousingInformationViewCell", forIndexPath: indexPath) as! HousingInformationViewCell
        cell.backgroundColor = UIColor.grayColor()
        cell.setUpCell(indexPath.item)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func getValue(idx: Int) -> (label: String, value: String) {
//        
//    }
}
