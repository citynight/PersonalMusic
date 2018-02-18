//
//  UINavigationController_Extension.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/18.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit

extension UINavigationController {
    func setNavigationAlpha(_ alpha: CGFloat) {
        if navigationBar.subviews.count < 1 {
            return
        }
        guard let barBackgroundView = navigationBar.subviews.first else {
            return
        }
        guard let backgroundImageView = barBackgroundView.subviews[0] as? UIImageView else {
            barBackgroundView.alpha = alpha
            return
        }
        if self.navigationBar.isTranslucent {
            if backgroundImageView.image != nil {
                barBackgroundView.alpha = alpha
            }else {
                guard let backgroundEffectView = barBackgroundView.subviews[1] as? UIVisualEffectView else {
                    return
                }
                backgroundEffectView.alpha = alpha
            }
        }else {
            barBackgroundView.alpha = alpha
        }
        navigationBar.clipsToBounds = alpha == 0.0
    }
    
    func setTitleColor(_ color: UIColor) {
        navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : color]
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : color]

    }
}
