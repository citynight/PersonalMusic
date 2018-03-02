//
//  DownloadTipView.swift
//  PersonalMusic
//
//  Created by 李小争 on 2018/3/2.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit

class DownloadTipView: UIView {

    
    @IBOutlet weak var ipLabel: UILabel!
    
    var closeComplete: (()->())?
    @IBAction func closeButtonClick(_ sender: UIButton) {
        self.closeComplete?()
    }
}
