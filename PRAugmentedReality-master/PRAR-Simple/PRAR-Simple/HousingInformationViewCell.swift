//
//  HousingInformationViewCell.swift
//  PRAR-Simple
//
//  Created by Jingrong (: on 8/11/15.
//  Copyright © 2015 GeoffroyLesage. All rights reserved.
//

import UIKit

class HousingInformationViewCell: UICollectionViewCell {
    @IBOutlet weak var attributeLabel: UILabel!

    @IBOutlet weak var attributeValue: UILabel!
    
    func setUpCell(idx: Int) {
        self.attributeLabel.text = "Label is here"
        self.attributeValue.text = "Value is here"
    }
}
