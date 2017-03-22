//
//  WJNoteTypeCollectionViewCell.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/12/29.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

class WJNoteTypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var markImageView: UIImageView!
    var model: WJNoteItemType? {
        didSet {
            label.text = model?.name
            label.backgroundColor = UIColor().HexToColor(hexString: (model?.color)!, alpha: kColorAlpha)
        }
    }
    var color: String? {
        didSet {
            label.text = ""
            label.backgroundColor = UIColor().HexToColor(hexString: color!, alpha: kColorAlpha)
        }
    }
    var isMark = false {
        didSet {
            markImageView.isHidden = !isMark
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
