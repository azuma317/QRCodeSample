//
//  ResultViewCell.swift
//  QRCodeSample
//
//  Created by Azuma on 2019/03/30.
//  Copyright © 2019 Azuma. All rights reserved.
//

import UIKit

class ResultViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
