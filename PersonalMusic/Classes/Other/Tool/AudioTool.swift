//
//  AudioTool.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/12.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit
import AVFoundation

class AudioTool: NSObject {
    
    //MARK: - LifeCycle
    override init() {
        super.init()
        backPlay()
    }
    
    // MARK: - Property
    private var player: AVAudioPlayer?
    weak var delegate:AVAudioPlayerDelegate? {
        didSet {
            self.player?.delegate = delegate
        }
    }
    
    // MARK: - Open Interface
    
    /// 根据歌曲名称,播放音乐
    ///
    /// - Parameter fileName: 歌曲文件名称
    /// - Returns: 播放器(用于外界获取播放进度信息)
    func playAudio(with url: URL) -> AVAudioPlayer? {
       
        if player?.url == url {
            player?.play()
            return player
        }
        
        guard let player = try? AVAudioPlayer(contentsOf: url) else {
            self.player = nil
            return nil
        }
        self.player = player
        player.delegate = delegate
        player.prepareToPlay()
        player.play()
        return player
    }
    
    /// 暂停当前正在播放的音乐
    func pauseAudio() {
        self.player?.pause()
    }
    
    /// 停止当前正在播放的音乐
    func stopAudio() {
        self.player?.stop()
        self.player = nil
    }
    
    /// 设置当前播放器的播放进度
    ///
    /// - Parameter currentTime: 播放进度
    func seekToTimeInterval(with currentTime:TimeInterval) {
        self.player?.currentTime = currentTime
    }
    
}
extension AudioTool {
    
    /// 设置后台播放
    func backPlay() {
        // 1. 获取音频会话
        let session = AVAudioSession.sharedInstance()
        do {
            // 2. 设置会话类别(后台播放)
            try session.setCategory(AVAudioSessionCategoryPlayback)
            // 3. 激活会话
            try session.setActive(true)
        }catch {
            print(error)
            return
        }
    }
}
