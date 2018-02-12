//
//  CALayer_Extension.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/12.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit

extension CALayer {
    // 暂停动画
    func pauseAnimate() {
        let pausedTime: CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime
    }
    
    // 恢复动画
    func resumeAnimate() {
        let pausedTime: CFTimeInterval = timeOffset
        speed = 1.0;
        timeOffset = 0.0;
        beginTime = 0.0;
        let timeSincePause: CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause;
    }
}
