//
//  WJLocalNotificationUtils.swift
//  DailyNote
//
//  Created by 王傲云 on 2017/1/25.
//  Copyright © 2017年 WangJace. All rights reserved.
//

import UIKit

class WJLocalNotificationUtils: NSObject {
    /** 添加创建并添加本地通知 */
    class func addNoteLocalNotification() {
        // 初始化一个通知
        let localNoti = UILocalNotification()
        
        // 通知的触发时间，例如即刻起15分钟后
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        components.hour = 23
        components.minute = 0
        components.second = 0
        localNoti.fireDate = calendar.date(from: components)
        // 设置时区
        localNoti.timeZone = NSTimeZone.default
        // 通知上显示的主题内容
        localNoti.alertBody = "时间的朋友，告诉我你今天做了什么"
        // 收到通知时播放的声音，默认消息声音
        localNoti.soundName = UILocalNotificationDefaultSoundName
        //待机界面的滑动动作提示
        localNoti.alertAction = "打开应用"
        // 应用程序图标右上角显示的消息数
        localNoti.applicationIconBadgeNumber = 1
        // 重复的发送的频率
        localNoti.repeatInterval = .day
        // 通知上绑定的其他信息，为键值对
        localNoti.userInfo = ["Name": "AddNoteNotification"]
        
        // 添加通知到系统队列中，系统会在指定的时间触发
        UIApplication.shared.scheduleLocalNotification(localNoti)
    }
    
    // 通过通知上绑定的id来取消通知，其中id也是你在userInfo中存储的信息
    class func deleteNoteLocalNotification() {
        if let locals = UIApplication.shared.scheduledLocalNotifications {
            for localNoti in locals {
                if let dict = localNoti.userInfo {
                    
                    if dict.keys.contains("Name") && dict["Name"] is String && (dict["Name"] as! String) == "AddNoteNotification" {
                        // 取消通知
                        UIApplication.shared.cancelLocalNotification(localNoti)
                    }
                }
            }
        }
    }
}
