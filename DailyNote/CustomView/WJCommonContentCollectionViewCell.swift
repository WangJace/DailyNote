//
//  WJCommonContentCollectionViewCell.swift
//  DailyNote
//
//  Created by 王傲云 on 2017/3/13.
//  Copyright © 2017年 WangJace. All rights reserved.
//

import UIKit

class WJCommonContentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var markImageView: UIImageView!
    var isMark = false {
        didSet {
            markImageView.isHidden = !isMark
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentLabel.layer.cornerRadius = 8
        contentLabel.layer.masksToBounds = true
    }

}
