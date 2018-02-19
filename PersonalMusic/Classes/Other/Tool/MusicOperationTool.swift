//
//  MusicOperationTool.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/12.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit
import AVFoundation

class MusicMessageModel: NSObject {
    /// 当前正在播放的音乐数据模型
    var musicM: MusicModel?
    /// 已经播放时间
    var costTime: TimeInterval = 0
    /// 总时长
    var totalTime: TimeInterval = 0
    /// 播放状态
    var isPlaying: Bool = false
}


class MusicOperationTool: NSObject {
    
    static let shared = MusicOperationTool()
    override init() {
        super.init()
    }
    // MARK: - Open
    /// 播放的音乐信息数据模型
    func getMusicMsgModel() -> MusicMessageModel {
        let musicMsgModel = MusicMessageModel()
        let musicModel = self.musicMs[self.currentPlayIndex]
        musicMsgModel.musicM = musicModel
        // 已经播放时长
        musicMsgModel.costTime = self.currentPlayer?.currentTime ?? 0
        musicMsgModel.totalTime = self.currentPlayer?.duration ?? 0
        musicMsgModel.isPlaying = self.currentPlayer?.isPlaying ?? false
        return musicMsgModel
    }
    
    /// 播放的音乐列表
    var musicMs: [MusicModel] = [MusicModel]()
    
    // MARK: - Private
    private let audioTool: AudioTool = AudioTool()
    private var currentPlayer: AVAudioPlayer?
    private var currentPlayIndex: Int = 0 {
        didSet {
            if currentPlayIndex < 0 {
                currentPlayIndex = self.musicMs.count - 1
            }
            if currentPlayIndex > self.musicMs.count - 1 {
                currentPlayIndex = 0
            }
        }
    }
    // MARK: - Interface
    
    /// 在播放某一首音乐对应的数据模型时, 计算出对应的索引
    ///
    /// - Parameter model: 音乐数据模型
    func playMusic(with model: MusicModel) {
        currentPlayer = audioTool.playAudio(with: model.filename)
        currentPlayIndex = musicMs.index(of: model) ?? 0
    }
    
    
    /// 暂停当前正在播放的音乐
    func pauseCurrentMusic() {
        audioTool.pauseAudio()
    }
    
    /// 继续播放当前音乐
    func playCurrentMusic() {
        let model = musicMs[currentPlayIndex]
        playMusic(with: model)
    }
    
    /// 播放下一首
    func nextMusic() {
        currentPlayIndex = currentPlayIndex + 1
        let model = musicMs[currentPlayIndex]
        playMusic(with: model)
    }
    
    /// 上一首
    func preMusic() {
        currentPlayIndex = currentPlayIndex - 1
        let model = musicMs[currentPlayIndex]
        playMusic(with: model)

    }
    
    /// 更新锁屏信息
    func updateLockScreenMessage() {
        
    }
    
    /// 设置播放的进度
    ///
    /// - Parameter currentTime: 当前播放时间
    func seekToTimeInterval(_ currentTime: TimeInterval) {
        audioTool.seekToTimeInterval(with: currentTime)
    }
    
    /*
     /**
     *  更新锁屏信息
     */
     - (void)updateLockScreenMessage;
     
     /**
     *  设置播放的进度
     */
     - (void)seekToTimeInterval:(NSTimeInterval)currentTime;
     
     /**
     *  设置代理, 用于传递音乐播放完成的事件给外界
     */
     @property (nonatomic, weak) id<AVAudioPlayerDelegate> delegate;
     
     */
    
    
}


