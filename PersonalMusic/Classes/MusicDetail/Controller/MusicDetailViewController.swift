//
//  MusicDetailViewController.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/12.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit

class MusicDetailViewController: UIViewController {

    /// 已经播放时长
    @IBOutlet weak var costTimeLabel: UILabel!
    /// 总时长
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    @IBOutlet weak var playOrPauseBtn: UIButton!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var centerImageView: UIImageView!
    
    @IBOutlet weak var progressSlider: UISlider!
    
    
    @IBAction func playOrPause(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            MusicOperationTool.shared.playCurrentMusic()
            resumeRotation()
        }else {
            MusicOperationTool.shared.pauseCurrentMusic()
            pauseRotation()
        }
    }
    @IBAction func preMusic() {
        MusicOperationTool.shared.preMusic()
        updateMusicInfo()
    }
    
    @IBAction func nextMusic() {
        MusicOperationTool.shared.nextMusic()
        updateMusicInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMusicInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.centerImageView.layer.cornerRadius = self.centerImageView.frame.width * 0.5
    }
}
extension MusicDetailViewController {
    func setupUI() {
        self.centerImageView.layer.masksToBounds = true
        self.centerImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.centerImageView.layer.borderWidth = 6
        progressSlider.setThumbImage(UIImage(named:"player_slider_playback_thumb"), for: .normal)
    }
    func updateMusicInfo() {
        let messageModel = MusicOperationTool.shared.getMusicMsgModel()
        guard let musicModel = messageModel.musicM else {
            return
        }
        self.backImageView.image = UIImage(named:musicModel.icon)
        self.centerImageView.image = UIImage(named:musicModel.icon)
        self.totalTimeLabel.text = TimeTool.getFormatTime(timeInterval: messageModel.totalTime)
        
        beginRotation()
        
        if messageModel.isPlaying {
            resumeRotation()
        }else {
            pauseRotation()
        }
    }
    
    /// 开始旋转
    func beginRotation() {
        centerImageView.layer.removeAnimation(forKey: "rotation")
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 30
        animation.isRemovedOnCompletion = false
        animation.repeatCount = MAXFLOAT
        centerImageView.layer.add(animation, forKey: "rotation")
    }
    
    
    /// 暂停旋转(此处的实现, 是使用到了一个CALayer分类, 来暂停核心动画)
    func pauseRotation() {
        centerImageView.layer.pauseAnimate()
    }
    func resumeRotation() {
        centerImageView.layer.resumeAnimate()
    }
}
