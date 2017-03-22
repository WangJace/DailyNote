//
//  StringExtention.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/12/26.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import Foundation

extension String {
    // MARK: - MD5加密
    var MD5: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate(capacity: digestLen)
        
        return hash as String
    }
}
