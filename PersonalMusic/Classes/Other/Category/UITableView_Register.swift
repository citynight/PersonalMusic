//
//  UITableView_Register.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/12.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit

extension UITableView {

    /// 注册nib
    ///
    /// - Parameter type: nib的名称
    public func registerNibFromClass<T: UITableViewCell>(type: T.Type) {
        let className = StringFromClass(T.self)
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellReuseIdentifier: className)
    }
    
    
    /// 注册cell
    ///
    /// - Parameter type: cell的名称
    public func registerClassFromClass<T: UITableViewCell>(type: T.Type) {
        let className = StringFromClass(T.self)
        register(T.self, forCellReuseIdentifier: className)
    }
    
    /// 获取cell
    ///
    /// - Parameters:
    ///   - type: cell名称
    ///   - indexPath: IndexPath
    /// - Returns: 获取到的cell
    public func dequeueReusableCell<T: UITableViewCell>(type: T.Type,
                                                        forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: StringFromClass(T.self), for: indexPath) as! T
    }
}
