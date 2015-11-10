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
    
    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var buttonView: UIButton!
    
    let labelParams = [
        "address",
        "baths",
        "bedrooms",
        "garageSpaces",
        "originalPrice",
        "ownership",
        "yearBuilt",
        "stories",
        "squareFootage",
        "type",
        "daysOnMarket",
        "price",
    ]
    
    
    
    let totalCellCount = 12
    var global_uid: String!
    var apiData: NSDictionary!
//    var dataSet : 
    
    override func viewDidLoad() {
        global_uid = AppDelegate.getGlobalString()
        doAPIStuff()

    }
    
    // Collection View Stuff
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalCellCount
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = allCheckoutItemTiles.dequeueReusableCellWithReuseIdentifier("HousingInformationViewCell", forIndexPath: indexPath) as! HousingInformationViewCell
        cell.backgroundColor = self.getFunColors(indexPath.item)
        
        // Label & Value
        cell.setUpCell( getValue(indexPath.item).label ,value: getValue(indexPath.item).value)

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doAPIStuff() {

        let specificLocationAPI = String(format: "%@%@", "https://zipcode-rece.c9users.io:8080/api/retsly/listing?id=", global_uid)
        print (specificLocationAPI)
        let request = NSURLRequest(URL: NSURL(string: specificLocationAPI)!)
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            do {
                try self.apiData = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                if let _ = self.allCheckoutItemTiles {
                    indicator.stopAnimating()
                    self.allCheckoutItemTiles.delegate = self
                    self.allCheckoutItemTiles.dataSource = self
//                    self.allCheckoutItemTiles.reloadData()
                }
                self.setUpImage()
                AppDelegate.clearGlobalString()
                self.setUpBothButtons()
            } catch {
                
            }
        }
        
    }
    func getValue(idx: Int) -> (label: String, value: String) {
        let _label = labelParams[idx]
        let _value = String(apiData[_label]!)
        
        return (_label, _value)
    }
    func setUpImage() {
        let newImageOfHouse = UIImageView(frame: CGRect(x: 0, y: 25, width: 327, height: 219))
//        if let _ = self.apiData["media"] {
//            print ("IMAGE UNAVAILABLE")
//            return
//        } else {
//            if let url = NSURL(string: (self.apiData["media"]![0]["url"] as! String)) {
//                if let data = NSData(contentsOfURL: url) {
//                    newImageOfHouse.image = UIImage(data: data)
//                    self.view.addSubview(newImageOfHouse)
//                }
//            }
//        }
//        let urlString = "https://s3.amazonaws.com/retsly_images_production/armls/20150528203134338311000000/1.jpg"
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//            if let test =  UIImage(data: NSData(contentsOfURL: NSURL(string:urlString)!)!) {
//                self.houseImage.image = test                
//            }
//
//        })
    }
    
    private func getFunColors(idx: Int) -> UIColor {
        let arrayOfColors = ["A0C5E6 ","DE6768 ","F4B171 ","94C380 "]
        let currentElementIdx = idx % 4
        let currentColor = UIColorFromRGB(arrayOfColors[currentElementIdx], alpha: 1.0)
        return currentColor
        
    }
    func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor{
        var scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
    func setUpBothButtons() {
        let navigationView = UIButton(frame: CGRect(x: 217, y: 489, width: 60, height: 60))
        navigationView.setImage(UIImage(named: "navigation12"), forState: .Normal)
        navigationView.addTarget(self, action: "navigationButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(navigationView)
        
        let contactView = UIButton(frame: CGRect(x: 45, y: 489, width: 60, height: 60))
        contactView.setImage(UIImage(named: "phone325"), forState: .Normal)
        contactView.addTarget(self, action: "contactButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(contactView)
    }
    
    func navigationButtonPressed() {
        let stringURL = "http://maps.apple.com/?q=" + (String(self.apiData["coordinates"]![1])) + "," + (String(self.apiData["coordinates"]![0]))
        let targetURL = NSURL(string: stringURL)
        UIApplication.sharedApplication().openURL(targetURL!)
    }
    
    func contactButtonPressed() {
        let agentPhone = "6505578509"
        if let url = NSURL(string: "tel://\(agentPhone)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}
