//
//  LrcDataTool.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/18.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import Foundation

class LrcDataTool {
    class func getLrcModelsWithFileName(_ fileName: String) -> [LrcModel]{
        // 用于存储歌词数据模型的数组
        var lrcMs = [LrcModel]()
        // 获取对应的资源路径
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            return lrcMs
        }
        // 获取所有歌词的内容
        var lrcContent = ""
        do {
            lrcContent = try  String(contentsOfFile: path)
        }catch {
            print(error)
            return lrcMs
        }
        // 根据换行符, 解析出每一行
        let lrcStrs = lrcContent.split(separator: "\n")
        
        for timeAndText in lrcStrs {
            
            // [00:00.89]传奇
            // [ti:]
            
            // 过滤垃圾数据
            if timeAndText.contains("[ti:") || timeAndText.contains("[ar:") || timeAndText.contains("[al:")
            {
                continue
            }
            
            
            // 在这里, 可以拿到真正对的格式的数据
            // [00:00.89]传奇
            // 取出左中括号
            let resultLrcStr = timeAndText.replacingOccurrences(of: "[", with: "")
            
            // 00:00.91]简单爱 resultLrcStr
            let timeAndContent = resultLrcStr.split(separator:"]")
            
            // 容错处理, 防止解析错误格式的数据, 造成崩溃
            if timeAndContent.count != 2 {
                continue
            }
            let time = timeAndContent[0]
            let content = timeAndContent[1]
            
            // 创建歌词数据模型, 赋值
            let lrcM = LrcModel()
            lrcMs.append(lrcM)
            lrcM.beginTime = TimeTool.getTimeInterval(formatTime: String(time))  // 00:00.91
            lrcM.lrcText = String(content)
            
            // 遍历数组, 给每个模型的结束时间赋值
            let count = lrcMs.count
            for i in 0..<count {
                if i == count - 1 {
                    continue
                }
                let lrcM = lrcMs[i]
                let nextLrcM = lrcMs[i + 1]
                lrcM.endTime = nextLrcM.beginTime
            }
        }
        return lrcMs
    }
    
    class func getCurrentLrcM(currentTime: TimeInterval, lrcMs: [LrcModel]) -> (row: Int, lrcM: LrcModel?) {
        var index = 0
        for lrcM  in lrcMs {
            let endTime = lrcM.endTime == 0 ? Double(Int.max) : lrcM.endTime
            if  currentTime >= lrcM.beginTime && currentTime < endTime {
                return (index, lrcM)
            }
            index += 1
        }
        return (0, nil)
    }
}
