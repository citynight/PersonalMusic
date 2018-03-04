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
    var title: String
    /** 歌手名称 */
    var artist: String
    /** 专辑名称*/
    var albumName: String = ""
    /** 歌曲文件路径 */
    var filePath: URL?
    /** 歌词文件名称 */
    var lrcname: String
        /** 歌手头像名称 */
    var singerIcon: String
    /** 专辑头像图片 */
    var icon: String
    var iconImage: UIImage?
    
    init(with dic:JSONDictionary) {
        title = String.stringValue(dic["name"])
        filePath = Bundle.main.url(forResource: String.stringValue(dic["filename"]), withExtension: nil)
        lrcname = String.stringValue(dic["lrcname"])
        artist = String.stringValue(dic["singer"])
        singerIcon = String.stringValue(dic["singerIcon"])
        icon = String.stringValue(dic["icon"])
        super.init()
    }
    override init() {
        title = ""
        lrcname = ""
        artist = ""
        singerIcon = ""
        icon = ""
        super.init()
    }
}
