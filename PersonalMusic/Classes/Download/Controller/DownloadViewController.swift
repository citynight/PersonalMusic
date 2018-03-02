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

class DownloadViewController: UIViewController {

    private lazy var downloadTipView: DownloadTipView = {
        let view = UINib(nibName: "DownloadTipView", bundle: nil).instantiate(withOwner: self, options: nil).first as! DownloadTipView
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    deinit {
        print("jieshu")
    }
}
extension DownloadViewController {
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        configIpView()
        configNav()
    }
    func configNav() {
        let rightBarButtonItem = UIBarButtonItem(title: "从电脑导歌", style: .plain, target: self, action: #selector(downloadMusic))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationController?.setNavigationAlpha(1)
        self.navigationController?.setTitleColor(UIColor.black)
    }
    
    func configIpView() {
        view.addSubview(downloadTipView)
        downloadTipView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(250)
        }
        downloadTipView.closeComplete = {[weak self] in
            guard let `self` = self else {
                return
            }
            self.downloadTipView.isHidden = true
        }
    }
}

@objc
extension DownloadViewController {
    func downloadMusic() {
        guard let documentsPathStr = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentationDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first else {
            return
        }
        let documentsPath = documentsPathStr + "/musics"
        if !FileManager.default.fileExists(atPath: documentsPath) {
            try? FileManager.default.createDirectory(atPath: documentsPath, withIntermediateDirectories: true, attributes: nil)
        }
        print(documentsPath)
        
        webServerConfig(with: documentsPath)
    }
}

extension DownloadViewController {
    func webServerConfig(with path: String) {
        let webServer = GCDWebUploader(uploadDirectory: path)
        webServer.delegate = self
        webServer.allowHiddenItems = true
        if webServer.start() {
            print("服务器启动")
            downloadTipView.isHidden = false
        }else {
            print("启动失败")
            downloadTipView.isHidden = true
        }
    }
}
extension DownloadViewController: GCDWebUploaderDelegate {
    func webUploader(_ uploader: GCDWebUploader, didUploadFileAtPath path: String) {
        print("upload", path)
    }
    
    func webUploader(_ uploader: GCDWebUploader, didMoveItemFromPath fromPath: String, toPath: String) {
        print("MOVE",fromPath,toPath)
    }
    
    func webUploader(_ uploader: GCDWebUploader, didDeleteItemAtPath path: String) {
        print("DELETE",path)
    }
    func webUploader(_ uploader: GCDWebUploader, didCreateDirectoryAtPath path: String) {
        print("CREATE",path)
    }
}
