//
//  ImageTool.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/21.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit

class ImageTool: NSObject {
    class func creatImage(with text: String, inImage image:UIImage) -> UIImage?{
        let size = image.size
        // 1. 开启图形上下文
        UIGraphicsBeginImageContext(size)
        
        // 2. 绘制大图片
        
        image.draw(in: CGRect(origin: .zero, size: size))
        // 3. 绘制文字
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let dic = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20),
            NSAttributedStringKey.paragraphStyle: style
        ]
        let textRect = CGRect(x: 0, y: 0, width: size.width, height: 26)
        (text as NSString).draw(in: textRect, withAttributes: dic)
        
        // 4. 取出图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. 关闭图形上下文
        UIGraphicsEndImageContext()
        
        return resultImage
    }
}
