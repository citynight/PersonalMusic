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
    
    @IBAction func playOrPause(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            MusicOperationTool.shared.playCurrentMusic()
        }else {
            MusicOperationTool.shared.pauseCurrentMusic()
        }
    }
    @IBAction func preMusic() {
        MusicOperationTool.shared.preMusic()
    }
    
    @IBAction func nextMusic() {
        MusicOperationTool.shared.nextMusic()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateMusicInfo()
    }

    
}
extension MusicDetailViewController {
    func updateMusicInfo() {
        let messageModel = MusicOperationTool.shared.getMusicMsgModel()
        guard let musicModel = messageModel.musicM else {
            return
        }
        self.backImageView.image = UIImage(named:musicModel.icon)
        self.centerImageView.image = UIImage(named:musicModel.icon)
        self.totalTimeLabel.text = TimeTool.getFormatTime(timeInterval: messageModel.totalTime)
        
    }
}
