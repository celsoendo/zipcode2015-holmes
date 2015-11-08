//
//  PropertyModel.swift
//  PRAR-Simple
//
//  Created by Jingrong (: on 8/11/15.
//  Copyright © 2015 GeoffroyLesage. All rights reserved.
//

import Foundation

@objc class PropertyModel:NSObject {
    
    class var sharedInstance: PropertyModel {
        struct Static {
            static var instance: PropertyModel?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = PropertyModel()
        }
        
        return Static.instance!
    }
    
    /* Attributes */
    @objc var propertyDetailManager: [Int: NSDictionary]!
    
    override init() {
        propertyDetailManager = [Int: NSDictionary]()
    }
    
    /* Functions */
    
    /* Setters */
    @objc func fillUpDetails(input : NSDictionary, propertyIdentifier: Int) {
        self.propertyDetailManager[propertyIdentifier] = input;
    }
    
    /* Getters */
    @objc func getDetails(propertyIdentifier: Int) -> NSDictionary {
        return self.propertyDetailManager[propertyIdentifier]!
    }
    
}
