//
//  MusicOperationTool.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/12.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

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
        guard let url = Bundle.main.url(forResource: model.filename, withExtension: nil) else {
            return
        }
        
        currentPlayer = audioTool.playAudio(with: url)
        currentPlayIndex = musicMs.index(of: model) ?? 0
    }
    
    func playMusic(with filePath: String) {
        guard let url = URL(string: filePath) else {
            return
        }
        currentPlayer = audioTool.playAudio(with: url)
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
        // 取出需要展示的数据模型
        let musicMessageM = getMusicMsgModel()
        // 1. 获取锁屏中心
        let center = MPNowPlayingInfoCenter.default()
        
        // 2. 给锁屏中心赋值
        let musicName = musicMessageM.musicM?.name ?? ""
        let singerName = musicMessageM.musicM?.singer ?? ""
        let costTime = musicMessageM.costTime
        let totalTime = musicMessageM.totalTime
        let imageName = musicMessageM.musicM?.icon ?? ""
        
        // 1. 获取当前正在播放的歌词
        
        let lrcFileName = musicMessageM.musicM?.lrcname ?? ""
        let lrcMs = LrcDataTool.getLrcModelsWithFileName(lrcFileName)
        let lrcMRow = LrcDataTool.getCurrentLrcM(currentTime: musicMessageM.costTime, lrcMs: lrcMs)
        let lrcM = lrcMRow.lrcM
        
        // 1 60
        let lrcText = lrcM?.lrcText ?? ""
        print(lrcM?.lrcText ?? "")
        
        // 2. 绘制到图片, 生成一个新的图片
        
        let placehoulder =  UIImage(named:"lkq.jpg")!
        let resultImage = UIImage(named: imageName) ?? placehoulder
//        ImageTool.creatImage(with: lrcText, inImage: UIImage(named: imageName) ?? placehoulder) ?? placehoulder
        
        // 3. 设置专辑图片
        let artwork = MPMediaItemArtwork.init(boundsSize: resultImage.size, requestHandler: { (size) -> UIImage in
            return resultImage
        })

        let dic: NSMutableDictionary = [
            MPMediaItemPropertyTitle: "我的音乐",
            MPMediaItemPropertyAlbumTitle: musicName,
            MPMediaItemPropertyArtist: singerName,
            MPMediaItemPropertyPlaybackDuration: totalTime,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: costTime,
            MPMediaItemPropertyArtwork: artwork,
            MPMediaItemPropertyLyrics: lrcText
        ]
        
        let dicCopy = dic.copy()
        center.nowPlayingInfo = dicCopy as? [String: AnyObject]
        
        // 3. 接收远程事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
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
     *  设置代理, 用于传递音乐播放完成的事件给外界
     */
     @property (nonatomic, weak) id<AVAudioPlayerDelegate> delegate;
     
     */
    
    
}


