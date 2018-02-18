//
//  LrcModel.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/18.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit

class LrcModel: NSObject {    
    /// 歌词开始时间
    var beginTime: TimeInterval = 0
    ///  歌词结束时间
    var endTime: TimeInterval = 0
    /// 歌词内容
    var lrcText: String = ""
}
