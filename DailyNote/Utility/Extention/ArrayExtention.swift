//
//  ArrayExtention.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/11/13.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeObject<T>(_ object: T) where T:Equatable {
        let index = indexOfObject(object)
        if index != -1 {
            remove(at: index)
        }
    }
    
    mutating func indexOfObject<T>(_ object: T) -> Int where T:Equatable {
        var index = -1
        findRoop:for i in 0..<count {
            let obj:T = self[i] as! T
            if obj == object {
                index = i
                break findRoop
            }
        }
        return index
    }
}
