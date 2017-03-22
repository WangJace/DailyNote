//
//  WJHomeViewModel.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/11/7.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

class WJHomeViewModel: NSObject {
    var dataSource = [WJNoteItem]()
    var statisticData = [WJHomeStatisticDataModel]()
    var totalTimeLength: TimeInterval = 0
    var reloadData: ((Void) -> Void)?
    func queryNoteList(date: Date) {
        dataSource.removeAll()
        statisticData.removeAll()
        totalTimeLength = 0
        
        if reloadData != nil {
            reloadData!()
        }
        
        let query = BmobQuery.init(className: "Notes")
        let conditions = [["userId":kUserDefault.object(forKey: kUserId)], ["date":NSNumber.init(value: date.getDateTimeInteral())]]
        query?.addTheConstraintByAndOperation(with: conditions)
        query?.order(byAscending: "startTime")
        query?.findObjectsInBackground({ [weak self] (arr, error) in
            if let temp = arr {
                for obj in temp {
                    let noteItem = obj as! BmobObject
                    let objId = noteItem.objectId as String
                    let startTime = noteItem.object(forKey: "startTime") as! NSNumber
                    let endTime = noteItem.object(forKey: "endTime") as! NSNumber
                    let typeId = noteItem.object(forKey: "typeId") as! String
                    let content = noteItem.object(forKey: "content") as! String
                    let date = noteItem.object(forKey: "date") as! NSNumber
                    let model = WJNoteItem.init(itemId: objId,startTime: startTime.doubleValue, endTime: endTime.doubleValue, typeId: typeId, content: content, date: date.doubleValue)
                    self?.totalTimeLength += model.timeLength
                    
                    let typeName = WJNoteTypeManager.shared.getTypeName(typeId)
                    let typeColor = WJNoteTypeManager.shared.getColor(typeId)
                    var isExist = false
                    for i in 0..<(self?.statisticData.count)! {
                        let statisticModel = (self?.statisticData[i])!
                        if statisticModel.typeName == typeName {
                            self?.statisticData[i].timeLength += model.timeLength
                            isExist = true
                            break
                        }
                    }
                    
                    if !isExist {
                        self?.statisticData.append(WJHomeStatisticDataModel(timeLength: model.timeLength, color: typeColor, typeName: typeName))
                    }
                    
                    self?.dataSource.append(model)
                }
            }
            if self?.reloadData != nil {
                self?.reloadData!()
            }
        })
    }
    
    func delectNoteItem(index: Int) {
        let noteItem = dataSource[index]
        let deleteOperator:BmobObject = BmobObject(outDataWithClassName: "Notes", objectId: noteItem.itemId)
        deleteOperator.deleteInBackground { (isSuccessful, error) in
            if (isSuccessful) {
                //删除成功后的动作
                print ("success");
            }else{
                print("delete error \(error?.localizedDescription)")
            }
        }
    }
}
