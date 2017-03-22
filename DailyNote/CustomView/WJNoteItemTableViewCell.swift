//
//  WJNoteItemTableViewCell.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/11/7.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

class WJNoteItemTableViewCell: UITableViewCell {

    @IBOutlet weak var typeBgView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var model: WJNoteItem? {
        didSet {
            if model != nil {
                timeLabel?.text = model?.getTime()
                contentLabel?.text = model?.content
                typeBgView?.backgroundColor = WJNoteTypeManager.shared.getColor(model?.typeId)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
