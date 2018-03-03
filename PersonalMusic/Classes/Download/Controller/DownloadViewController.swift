//
//  DownloadViewController.swift
//  PersonalMusic
//
//  Created by 李小争 on 2018/3/2.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit
import GCDWebServers.GCDWebUploader
import SnapKit
import AVFoundation

class DownloadViewController: UIViewController {

    private lazy var downloadTipView: DownloadTipView = {
        let view = UINib(nibName: "DownloadTipView", bundle: nil).instantiate(withOwner: self, options: nil).first as! DownloadTipView
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var webServer: GCDWebUploader?
    private lazy var dataSource:[String] = []
    
    private lazy var documentsPath: String = {
        guard let documentsPathStr = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentationDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first else {
            return ""
        }
        let documentsPath = documentsPathStr + "/musics"
        if !FileManager.default.fileExists(atPath: documentsPath) {
            try? FileManager.default.createDirectory(atPath: documentsPath, withIntermediateDirectories: true, attributes: nil)
        }
        return documentsPath
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchFileNames()
    }
    deinit {
        webServer?.stop()
        print("jieshu")
    }
}
extension DownloadViewController {
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        configTableView()
        configIpView()
        configNav()
        
    }
    func configNav() {
        let rightBarButtonItem = UIBarButtonItem(title: "从电脑导歌", style: .plain, target: self, action: #selector(downloadMusic))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationController?.setNavigationAlpha(1)
        self.navigationController?.setTitleColor(UIColor.black)
    }
    
    func configTableView() {
        view.addSubview(tableView)
        tableView.registerClassFromClass(type: UITableViewCell.self)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func configIpView() {
        view.addSubview(downloadTipView)
        downloadTipView.isHidden = true
        downloadTipView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(250)
        }
    }
    
    func fetchFileNames() {
        let subpaths = FileManager.default.subpaths(atPath: documentsPath)
        let dataSource = subpaths ?? []
        
        for i in dataSource {
            let url = URL(fileURLWithPath: documentsPath + "/\(i)")
            let mp3Asset = AVAsset(url: url)
            print("歌词：",mp3Asset.lyrics)
            for format in mp3Asset.availableMetadataFormats {
                for item in mp3Asset.metadata(forFormat: format) {
                    print(item.commonKey?.rawValue)
                    // 歌曲图片
                    if item.commonKey?.rawValue == "artwork" {
                        if let data = item.value as? Data {
                            let image = UIImage(data: data)
                            print(image)
                        }
                    }
                    // 专辑名称
                    if item.commonKey?.rawValue == "albumName" {
                        print(item.value)
                    }
                    // 艺术家
                    if item.commonKey?.rawValue == "artist" {
                        print(item.value)
                    }
                    // 歌曲名称
                    if item.commonKey?.rawValue == "title" {
                        print(item.value)
                    }
                }
            }
                
            
            
        }
        
        
        tableView.reloadData()
    }
}

@objc
extension DownloadViewController {
    func downloadMusic() {
        downloadTipView.isHidden = false
        if webServer == nil {
            webServerConfig(with: documentsPath)
        }
    }
}

extension DownloadViewController {
    func webServerConfig(with path: String) {
        let webServer = GCDWebUploader(uploadDirectory: path)
        webServer.delegate = self
        webServer.allowHiddenItems = true
        if webServer.start() {
            print("服务器启动")
            let ip = webServer.serverURL?.absoluteString
            downloadTipView.ipLabel.text = ip
        }else {
            print("启动失败")
            downloadTipView.isHidden = true
        }
        self.webServer = webServer
        downloadTipView.closeComplete = {[weak self] in
            guard let `self` = self else {
                return
            }
            webServer.stop()
            self.webServer = nil
            self.downloadTipView.isHidden = true
        }
    }
}
extension DownloadViewController: GCDWebUploaderDelegate {
    func webUploader(_ uploader: GCDWebUploader, didUploadFileAtPath path: String) {
        print("upload", path)
        fetchFileNames()
    }
    
    func webUploader(_ uploader: GCDWebUploader, didMoveItemFromPath fromPath: String, toPath: String) {
        print("MOVE",fromPath,toPath)
        fetchFileNames()
    }
    
    func webUploader(_ uploader: GCDWebUploader, didDeleteItemAtPath path: String) {
        print("DELETE",path)
        fetchFileNames()
    }
    func webUploader(_ uploader: GCDWebUploader, didCreateDirectoryAtPath path: String) {
        print("CREATE",path)
        fetchFileNames()
    }
}
extension DownloadViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: UITableViewCell.self, forIndexPath: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = dataSource[indexPath.row]
        let path = documentsPath + "/\(name)"
        MusicOperationTool.shared.playMusic(with: path)
    }
}
