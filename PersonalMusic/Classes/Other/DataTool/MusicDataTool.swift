//
//  MusicDataTool.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/12.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import Foundation

class MusicDataTool: NSObject {
    class func fetchMusic(result:([MusicModel])->()) {
        var models = [MusicModel]()
        guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else {
            result(models)
            return
        }
        guard let array = NSArray(contentsOfFile: path) as? [JSONDictionary] else {
            result(models)
            return
        }
        
        models = array.flatMap{
            return MusicModel(with: $0)
        }
    }
}
