//
//  String_Extension.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/12.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import Foundation
/// get AnyObject‘s class Name with String type
///
/// - Parameter object: AnyObject
/// - Returns: class with String type
public func StringFromClass(_ object: AnyObject) -> String {
    return NSStringFromClass(type(of: object)).components(separatedBy: ".").last! as String
}


/// get current String’s type
///
/// - Parameter type: anytype
/// - Returns: String type
public func StringFromType<T>(type: T) -> String {
    return String(describing: type.self).components(separatedBy: ".").last!
}

extension String {
    var length : Int {
        return self.count
    }
}
