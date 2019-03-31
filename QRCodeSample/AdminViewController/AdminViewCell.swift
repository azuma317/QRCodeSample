//
//  AdminViewCell.swift
//  QRCodeSample
//
//  Created by Azuma on 2019/03/30.
//  Copyright © 2019 Azuma. All rights reserved.
//

import UIKit

class AdminViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        layer.cornerRadius = 8.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
    }

}
