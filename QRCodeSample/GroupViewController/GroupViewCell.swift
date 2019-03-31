//
//  GroupViewCell.swift
//  QRCodeSample
//
//  Created by Azuma on 2019/03/29.
//  Copyright © 2019 Azuma. All rights reserved.
//

import UIKit

class GroupViewCell: UICollectionViewCell {

    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var vote1Label: UILabel!
    @IBOutlet weak var vote2Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        layer.cornerRadius = 8.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
    }

}
