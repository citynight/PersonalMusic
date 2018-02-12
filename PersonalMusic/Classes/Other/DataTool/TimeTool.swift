//
//  TimeTool.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/12.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit

class TimeTool: NSObject {
    class func getFormatTime(timeInterval: TimeInterval) -> String {
        
        // timeInterval 21.123
        let min = Int(timeInterval) / 60
        let sec = Int(timeInterval) % 60
        
        return String(format: "%02d: %02d", min, sec) 
    }
    
    
    class func getTimeInterval(formatTime: String) -> TimeInterval {
        
        // 00:00.91
        let minSec = formatTime.split(separator: ":")
        if minSec.count != 2 {
            return 0
        }
        let min = TimeInterval(minSec[0]) ?? 0.0
        let sec = TimeInterval(minSec[1]) ?? 0.0
        return min * 60.0 + sec
    }
}
