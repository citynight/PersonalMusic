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
    
    @IBOutlet weak var lrcLabel: UILabel!
    
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
    
    @IBAction func touchDown(_ sender: UISlider) {
        removeTimer()
    }
    
    @IBAction func touchUp(_ sender: UISlider) {
        addTimer()
        let messageModel = MusicOperationTool.shared.getMusicMsgModel()
        let currentTime = messageModel.totalTime * Double(self.progressSlider.value)
        MusicOperationTool.shared.seekToTimeInterval(currentTime)
    }
    @IBAction func valueChange(_ sender: UISlider) {
        let messageModel = MusicOperationTool.shared.getMusicMsgModel()
        let currentTime = messageModel.totalTime * Double(self.progressSlider.value)
        MusicOperationTool.shared.seekToTimeInterval(currentTime)
        costTimeLabel.text = TimeTool.getFormatTime(timeInterval: currentTime)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configNav()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMusicInfo()
        addTimer()
        addLink()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configNav()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
        removeLink()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.centerImageView.layer.cornerRadius = self.centerImageView.frame.width * 0.5
    }
    deinit {
        print("释放")
    }
    
    //MARK: - Private
    // 负责更新歌词的link
    private var updateLrcLink: CADisplayLink?
    // 负责更新很多次的timer
    private var updateTimer: Timer?
    private var lrcMs:[LrcModel] = []
}
extension MusicDetailViewController {
    func configNav() {
        self.navigationController?.setNavigationAlpha(0)
        self.navigationController?.setTitleColor(UIColor.white)

    }
    func setupUI() {
        self.view.backgroundColor = UIColor.white
                
        self.centerImageView.layer.masksToBounds = true
        self.centerImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.centerImageView.layer.borderWidth = 6
        progressSlider.setThumbImage(UIImage(named:"player_slider_playback_thumb"), for: .normal)
    }
    func updateMusicInfo() {
        let messageModel = MusicOperationTool.shared.getMusicMsgModel()
        guard let musicModel = messageModel.musicM else {
            title = ""
            return
        }
        title = musicModel.name
        lrcMs = LrcDataTool.getLrcModelsWithFileName(musicModel.lrcname)
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
    
}

extension MusicDetailViewController {
    func addLink() {
        if updateLrcLink != nil {
            return
        }
        let target = TargetProxy(target: self, selector: #selector(updateLrc))
        updateLrcLink = CADisplayLink(target: target, selector:  #selector(target.execute))
        updateLrcLink?.add(to: RunLoop.current, forMode: .commonModes)
    }

    func removeLink() -> () {
        updateLrcLink?.invalidate()
        updateLrcLink = nil
    }

    func addTimer() {
        if updateTimer != nil {
            return
        }
        let target = TargetProxy(target: self, selector: #selector(setUpTimes))
        updateTimer = Timer(timeInterval: 1, target: target, selector: #selector(target.execute), userInfo: nil, repeats: true)
        RunLoop.current.add(updateTimer!, forMode: .commonModes)
    }
    
    func removeTimer() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
}

@objc
extension MusicDetailViewController {
    private func updateLrc() {
        let messageModel = MusicOperationTool.shared.getMusicMsgModel()
        let time = messageModel.costTime
        let lrcM = LrcDataTool.getCurrentLrcM(currentTime: time, lrcMs: lrcMs).lrcM
        
        lrcLabel.text = lrcM?.lrcText
        
    }
    private func setUpTimes() {
        let messageModel = MusicOperationTool.shared.getMusicMsgModel()
        costTimeLabel.text = TimeTool.getFormatTime(timeInterval: messageModel.costTime)
        progressSlider.value = Float(messageModel.costTime / messageModel.totalTime)
        playOrPauseBtn.isSelected = messageModel.isPlaying
    }
}

extension MusicDetailViewController {
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
