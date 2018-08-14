//
//  TableCell.swift
//  BairesListDemoIOS
//
//  Created by NeoNHugo on 8/13/18.
//  Copyright © 2018 NeoNHugo. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var middleText: UILabel!
    @IBOutlet weak var bottomText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
