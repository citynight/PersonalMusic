//
//  MusicModel.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/12.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit

class MusicModel: NSObject {
    /** 歌曲名称 */
    var name: String
    /** 歌曲文件名称 */
    var filename: String
    /** 歌词文件名称 */
    var lrcname: String
    /** 歌手名称 */
    var singer: String
    /** 歌手头像名称 */
    var singerIcon: String
    /** 专辑头像图片 */
    var icon: String
    
    init(with dic:JSONDictionary) {
        name = String.stringValue(dic["name"])
        filename = String.stringValue(dic["filename"])
        lrcname = String.stringValue(dic["lrcname"])
        singer = String.stringValue(dic["singer"])
        singerIcon = String.stringValue(dic["singerIcon"])
        icon = String.stringValue(dic["icon"])
        super.init()
    }
}
