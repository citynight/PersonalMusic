//
//  DownloadViewController.swift
//  PersonalMusic
//
//  Created by 李小争 on 2018/3/2.
//  Copyright © 2018年 Citynight. All rights reserved.
//

import UIKit
import GCDWebServers.GCDWebUploader

class DownloadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configNav()
    }

    
}
extension DownloadViewController {
    func configNav() {
        let rightBarButtonItem = UIBarButtonItem(title: "从电脑导歌", style: .plain, target: self, action: #selector(downloadMusic))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationController?.setNavigationAlpha(1)
        self.navigationController?.setTitleColor(UIColor.black)
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
        }else {
            print("启动失败")
        }
    }
}
extension DownloadViewController: GCDWebUploaderDelegate {
    
}
