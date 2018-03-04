//
//  MusicListCell.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/12.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit

class MusicListCell: UITableViewCell {

    // MARK: - UI
    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: - 数据
    func show(musicInfo music: MusicModel) {
        self.singerNameLabel.text = music.artist
        self.songNameLabel.text = music.title
        self.iconImageView.image = UIImage(named:music.singerIcon)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
