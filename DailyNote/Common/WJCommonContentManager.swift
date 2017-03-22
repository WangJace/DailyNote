//
//  WJCommonContentManager.swift
//  DailyNote
//
//  Created by 王傲云 on 2017/3/13.
//  Copyright © 2017年 WangJace. All rights reserved.
//

import UIKit

class WJCommonContentManager: NSObject {
    static let shared = WJCommonContentManager()
    var commontContents:[String] = [String]()
    private override init() {
        super.init()
        if let arr = getLocalCommonContentData() {
            commontContents.append(contentsOf: arr)
        }
    }
    
    func getLocalCommonContentData() -> [String]? {
        let path = NSHomeDirectory()+"/Documents/CommonContent.plist"
        if FileManager().fileExists(atPath: path) {
            let arr = NSArray.init(array: NSArray.init(contentsOfFile: path)!)
            var data = [String]()
            for i in 0..<arr.count {
                data.append(arr[i] as! String)
            }
            return data
        }
        else {
            createFile(path)
            let data = ["看书", "看电影", "打篮球", "跑步", "旅游"];
            let arr = NSArray.init(array: data)
            guard arr.write(toFile: path, atomically: true) else {
                return nil
            }
            return data
        }
    }
    
    func addCommonContent(content: String) -> Bool {
        let path = NSHomeDirectory()+"/Documents/CommonContent.plist"
        guard let arr = NSMutableArray.init(contentsOfFile: path) else {
            return false
        }
        arr.add(content)
        if arr.write(toFile: path, atomically: true) {
            commontContents.append(content)
            return true
        }
        else {
            return false
        }
    }
    
    func updateCommonContent(index: Int, content: String) -> Bool {
        let path = NSHomeDirectory()+"/Documents/CommonContent.plist"
        guard let arr = NSMutableArray.init(contentsOfFile: path) else {
            return false
        }
        arr[index] = content
        if arr.write(toFile: path, atomically: true) {
            commontContents[index] = content
            return true
        }
        else {
            return false
        }
    }
    
    func deleteCommonContent(index: Int) -> Bool {
        let path = NSHomeDirectory()+"/Documents/CommonContent.plist"
        guard let arr = NSMutableArray.init(contentsOfFile: path) else {
            return false
        }
        arr.removeObject(at: index)
        if arr.write(toFile: path, atomically: true) {
            commontContents.remove(at: index)
            return true
        }
        else {
            return false
        }
    }
    
    func moveCommonContentListRow(_ sourceRow:Int, to destinationRow: Int) -> Bool {
        let path = NSHomeDirectory()+"/Documents/CommonContent.plist"
        createFile(path)
        let arr = NSMutableArray.init(contentsOfFile: path)!
        arr.exchangeObject(at: sourceRow, withObjectAt: destinationRow)
        if arr.write(toFile: path, atomically: true) {
            (commontContents[sourceRow], commontContents[destinationRow]) = (commontContents[destinationRow], commontContents[sourceRow])
            return true
        }
        else {
            return false
        }
    }
    
    internal func createFile(_ path: String) {
        let fileManager = FileManager.init()
        if !fileManager.fileExists(atPath: path) {
            let flag = fileManager.createFile(atPath: path, contents: nil, attributes: nil)
            print(flag)
        }
    }
}
