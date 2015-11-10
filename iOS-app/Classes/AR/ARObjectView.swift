//
//  ARObjectView.swift
//  PRAR-Simple
//
//  Created by Jingrong (: on 7/11/15.
//  Copyright © 2015 GeoffroyLesage. All rights reserved.
//

import UIKit

class ARObjectView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    let tapRec = UITapGestureRecognizer()
    
    convenience init() {
        self.init()
        tapRec.addTarget(self, action: "tappedView")
    }
    
    func tappedView(){
        print ("hi")
    }
    
}
