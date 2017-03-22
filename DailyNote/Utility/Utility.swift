//
//  Utility.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/11/13.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit


// MARK: ScreenBounds
let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

// MARK: 例 -- rgba(0.3, 0.2, 0.6, 0.3)
func rgba(_ red:CGFloat, _ green:CGFloat, _ blue:CGFloat, _ alpha:CGFloat) -> UIColor {
    return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
}

// MARK: 例 -- RGBA(214, 23, 255, 0.7)
func RGBA(_ red:CGFloat, _ green:CGFloat, _ blue:CGFloat, _ alpha:CGFloat) -> UIColor {
    return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}

func showAlert(title: String, msg: String, confirmText:String) -> UIAlertController {
    let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction.init(title: confirmText, style: .default, handler: { (action) in
        
    }))
    return alert
}
