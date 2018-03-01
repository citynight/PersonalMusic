//
//  MusicListViewController.swift
//  PersonalMusic
//
//  Created by Mekor on 2018/2/11.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit

class MusicListViewController: UIViewController {

    // MARK: - 数据
    private var musicList:[MusicModel] = [MusicModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    // UI
    private lazy var tableView: UITableView = {
       let tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibFromClass(type: MusicListCell.self)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Music List"
        setupUI()
        
        MusicDataTool.fetchMusic { [weak self] (musics) in
            guard let `self` = self else {return}
            self.musicList = musics
            MusicOperationTool.shared.musicMs = musics
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configNav()
    }

}

extension MusicListViewController {
    func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        configNav()
        let rightBarButtonItem = UIBarButtonItem(title: "从电脑导歌", style: .plain, target: self, action: #selector(downloadMusic))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    func configNav() {
        self.navigationController?.setNavigationAlpha(1)
        self.navigationController?.setTitleColor(UIColor.black)
    }
    
    @objc func downloadMusic() {
        guard let documentsPathStr = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentationDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first else {
            return
        }
        let documentsPath = documentsPathStr + "/musics"
        if !FileManager.default.fileExists(atPath: documentsPath) {
            try? FileManager.default.createDirectory(atPath: documentsPath, withIntermediateDirectories: true, attributes: nil)
        }
        print(documentsPath)
    }
}

extension MusicListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: MusicListCell.self, forIndexPath: indexPath)
        cell.show(musicInfo: musicList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.musicList[indexPath.row]
        MusicOperationTool.shared.playMusic(with: model)
        let vc = MusicDetailViewController(nibName: "MusicDetailViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
