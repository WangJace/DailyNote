//
//  DateExtention.swift
//  DailyNote
//
//  Created by 王傲云 on 2017/2/6.
//  Copyright © 2017年 WangJace. All rights reserved.
//

import Foundation

extension Date {
    func getDateTimeInteral() -> TimeInterval {
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return (calendar.date(from: components)?.timeIntervalSince1970)!
    }
}
