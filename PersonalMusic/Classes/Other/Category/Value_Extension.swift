//
//  Value_Extension.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/12.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

extension String {
    /// 从Any？ 转字符串
    static func stringValue(_ any: Any?, defaultValue: String = "") -> String {
        guard let any = any else {
            return defaultValue
        }
        
        return "\(any)"
    }
}
