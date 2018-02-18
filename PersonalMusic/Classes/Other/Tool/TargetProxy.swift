//
//  TargetProxy.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/18.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit

class TargetProxy: NSObject{
    private weak var target: NSObject?
    private var selector: Selector
    
    init(target: NSObject, selector: Selector) {
        self.target = target
        self.selector = selector
    }
    
    @objc func execute() {
       _ = target?.perform(selector)
    }

}
