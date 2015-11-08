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
    
    func setUpCell(label: String, value: String) {
        self.attributeLabel.text = label
        self.attributeValue.text = value
    }
}
