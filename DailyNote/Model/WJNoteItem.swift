//
//  WJNoteItem.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/11/7.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

struct WJNoteItemType {
    var typeId:String
    var name:String
    var color:String
    
    func getColor() -> UIColor {
        return UIColor.init().HexToColor(hexString: color, alpha: kColorAlpha)
    }
}

class WJNoteItem:NSObject {
    var itemId:String
    var startTime:TimeInterval
    var endTime:TimeInterval
    var typeId:String
    var content:String
    var timeLength:TimeInterval = 0
    var date:TimeInterval
    
    private let formatter: DateFormatter = DateFormatter()
    
    override init() {
        startTime = Date().timeIntervalSince1970
        endTime = Date().timeIntervalSince1970
        typeId = ""
        content = ""
        date = Date().timeIntervalSince1970
        itemId = ""
        super.init()
    }
    
    init(itemId:String, startTime:TimeInterval, endTime:TimeInterval, typeId:String, content: String, date:TimeInterval) {
        self.itemId = itemId
        self.startTime = startTime
        self.endTime = endTime
        self.typeId = typeId
        self.content = content
        self.date = date
        self.timeLength = endTime-startTime
    }
    
    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "\(formatter.string(from: Date.init(timeIntervalSince1970: startTime)))-\(formatter.string(from: Date.init(timeIntervalSince1970: endTime)))"
    }
    
    func calculateTimeLength() {
        timeLength = endTime-startTime
    }
}
