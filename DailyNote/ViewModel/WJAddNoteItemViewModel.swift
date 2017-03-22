//
//  WJAddNoteItemViewModel.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/12/28.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

class WJAddNoteItemViewModel: NSObject {
    var model: WJNoteItem = WJNoteItem()
    var addSuccess:((Bool)->Void)?
    override init () {
        super.init()
    }
    
    func addNoteItem() {
        let noteItem:BmobObject = BmobObject(className: "Notes")
        noteItem.setObject(kUserDefault.object(forKey: kUserId), forKey: "userId")
        noteItem.setObject(model.startTime, forKey: "startTime")
        noteItem.setObject(model.endTime, forKey: "endTime")
        noteItem.setObject(model.typeId, forKey: "typeId")
        noteItem.setObject(model.content, forKey: "content")
        noteItem.setObject(model.date, forKey: "date")
        
        noteItem.saveInBackground { [weak self] (isSuccessful, error) in
            if error != nil{
                //发生错误后的动作
                print("error is \(error?.localizedDescription)")
                if self?.addSuccess != nil {
                    self?.addSuccess!(false)
                }
            }else{
                //创建成功后会返回objectId，updatedAt，createdAt等信息
                if self?.addSuccess != nil {
                    self?.addSuccess!(true)
                }
            }
        }
    }
}
