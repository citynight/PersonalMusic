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
    
    /// 指针
    @IBOutlet weak var needleView: UIImageView!
    
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
    
    /// 第几句歌词
    private var lrcRow = 0
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
        lrcLabel.text = ""
        let messageModel = MusicOperationTool.shared.getMusicMsgModel()
        guard let musicModel = messageModel.musicM else {
            title = ""
            return
        }
        title = musicModel.title
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
        let trouble = LrcDataTool.getCurrentLrcM(currentTime: time, lrcMs: lrcMs)
        if trouble.row == lrcRow && !lrcLabel.text!.isEmpty {
            return
        }
        let lrcM = trouble.lrcM
        lrcRow = trouble.row
        lrcLabel.text = lrcM?.lrcText
        
        MusicOperationTool.shared.updateLockScreenMessage()
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
        
        played(with: true)
    }
    
    /// 暂停旋转(此处的实现, 是使用到了一个CALayer分类, 来暂停核心动画)
    func pauseRotation() {
        centerImageView.layer.pauseAnimate()
        pushed(with: true)
    }
    func resumeRotation() {
        centerImageView.layer.resumeAnimate()
        played(with: true)
    }

    // MARK: - 指针动画
    
    /// 播放音乐时，指针恢复，图片旋转
    ///
    /// - Parameter animated: 是否显示动画效果
    func played(with animated:Bool) {
        
        setAnchor(point: CGPoint(x: 25.0/97, y: 25.0/153), forView: needleView)
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.needleView.transform = .identity
            })
        }else {
            self.needleView.transform = .identity
        }
    }
    
    ///  停止音乐时，指针旋转-30°，图片停止旋转
    ///
    /// - Parameter animated: 是否显示动画效果
    func pushed(with animated: Bool) {
        setAnchor(point: CGPoint(x: 25.0/97, y: 25.0/153), forView: needleView)
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.needleView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/6))
            })
        }else {
            self.needleView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/6))
        }
    }
    
    private func setAnchor(point anchorPoint: CGPoint, forView view:UIView) {
        let oldOrigin = view.frame.origin
        view.layer.anchorPoint = anchorPoint
        let newOrigin = view.frame.origin
        let transition = CGPoint(x: newOrigin.x - oldOrigin.x, y: newOrigin.y - oldOrigin.y)
        view.center = CGPoint(x: view.center.x - transition.x, y: view.center.y - transition.y)
    }
}
