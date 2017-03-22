//
//  WJNoteTypeManager.swift
//  DailyNote
//
//  Created by 王傲云 on 2017/1/7.
//  Copyright © 2017年 WangJace. All rights reserved.
//

import UIKit

class WJNoteTypeManager: NSObject {
    static let shared = WJNoteTypeManager()
    var noteTypes:[WJNoteItemType] = [WJNoteItemType]()
    private override init() {
        super.init()
        if let arr = getLocalNoteTypeData() {
            noteTypes.append(contentsOf: arr)
        }
    }
    
    func getLocalNoteTypeData() -> [WJNoteItemType]? {
        let path = NSHomeDirectory()+"/Documents/NoteType.plist"
        if FileManager().fileExists(atPath: path) {
            let arr = NSArray.init(contentsOfFile: path)!
            var data = [WJNoteItemType]()
            for i in 0..<arr.count {
                let dic = arr[i] as! [String : String]
                data.append(WJNoteItemType(typeId:dic["id"]!, name:dic["name"]!, color: dic["color"]!))
            }
            return data
        }
        return nil
    }
    
    func localizableNoteTypeList(_ temp: [[String:String]]) -> Bool{
        let path = NSHomeDirectory()+"/Documents/NoteType.plist"
        createFile(path)
        noteTypes.removeAll()
        let arr = NSMutableArray()
        for dic in temp {
            arr.add(dic)
            noteTypes.append(WJNoteItemType(typeId: dic["id"]!, name: dic["name"]!, color: dic["color"]!))
        }
        return arr.write(toFile: path, atomically: true)
    }
    
    func localizableNoteType(_ temp: [String:String]) -> Bool{
        let path = NSHomeDirectory()+"/Documents/NoteType.plist"
        createFile(path)
        let arr = NSMutableArray.init(array: NSArray.init(contentsOfFile: path)!)
        arr.add(temp)
        noteTypes.append(WJNoteItemType(typeId: temp["id"]!, name: temp["name"]!, color: temp["color"]!))
        return arr.write(toFile: path, atomically: true)
    }
    
    func moveNoteTypeListRow(_ sourceRow:Int, to destinationRow: Int) -> Bool {
        let path = NSHomeDirectory()+"/Documents/NoteType.plist"
        createFile(path)
        let arr = NSMutableArray.init(array: NSArray.init(contentsOfFile: path)!)
        arr.exchangeObject(at: sourceRow, withObjectAt: destinationRow)
        if arr.write(toFile: path, atomically: true) {
            (noteTypes[sourceRow], noteTypes[destinationRow]) = (noteTypes[destinationRow], noteTypes[sourceRow])
            return true
        }
        else {
            return false
        }
    }
    
    func updateLocalizableNoteType(_ temp: [String:String]) -> Bool {
        let path = NSHomeDirectory()+"/Documents/NoteType.plist"
        createFile(path)
        let arr = NSMutableArray.init(array: NSArray.init(contentsOfFile: path)!)
        for i in 0..<arr.count {
            let dic = arr[i] as! [String : String]
            if dic["id"] == temp["id"] {
                arr.removeObject(at: i)
                arr.insert(temp, at: i)
                noteTypes[i].name = dic["name"]!
                noteTypes[i].color = dic["color"]!
                break
            }
        }
        
        return arr.write(toFile: path, atomically: true)
    }
    
    func deleteLocalizableNoteType(_ id: String) -> Bool {
        let path = NSHomeDirectory()+"/Documents/NoteType.plist"
        createFile(path)
        let arr = NSMutableArray.init(array: NSArray.init(contentsOfFile: path)!)
        for i in 0..<arr.count {
            let dic = arr[i] as! [String : String]
            if dic["id"] == id {
                arr.removeObject(at: i)
                noteTypes.remove(at: i)
                break
            }
        }
        return arr.write(toFile: path, atomically: true)
    }
    
    internal func createFile(_ path: String) {
        let fileManager = FileManager.init()
        if !fileManager.fileExists(atPath: path) {
            let flag = fileManager.createFile(atPath: path, contents: nil, attributes: nil)
            print(flag)
        }
    }
    
    func getColor(_ typeId: String?) -> UIColor {
        if let id = typeId {
            var color = ""
            for temp in noteTypes {
                if temp.typeId == id {
                    color = temp.color
                    break
                }
            }
            return UIColor.init().HexToColor(hexString: color, alpha: kColorAlpha)
        }
        else {
            return UIColor.init().HexToColor(hexString: (noteTypes.first?.color)!, alpha: kColorAlpha)
        }
    }
    
    func getTypeName(_ typeId: String?) -> String {
        if let id = typeId {
            var name = ""
            for temp in noteTypes {
                if temp.typeId == id {
                    name = temp.name
                    break
                }
            }
            return name
        }
        else {
            return ""
        }
    }
}
