//
//  PlayerViewController.swift
//  SJPlayerDemo
//
//  Created by king on 16/4/19.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

   
    var playerView: SJPlyerView!
    public var fileUrl: NSURL?
    public var url: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        playerView = SJPlyerView()
        playerView.backgroundColor = UIColor.blackColor()
        playerView.frame = CGRect(x: 10, y: 100, width: 350, height: 300)
        view.addSubview(playerView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print(self)
        print(playerView)
                if fileUrl != nil {
                    playerView.fileUrl = fileUrl!
                } else if url != nil {
                    playerView.url = url!
                }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        playerView.resetPlayer()
    }
    
}
