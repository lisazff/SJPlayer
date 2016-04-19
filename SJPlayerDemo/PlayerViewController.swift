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
    var fileUrl: NSURL?
    var url: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        let btn = UIButton()
        btn.backgroundColor = UIColor.blueColor()
        btn.setTitle("切换视频", forState: .Normal)
        btn.frame = CGRect(x: 100, y: 500, width: 100, height: 50)
        btn.addTarget(self, action: "playNext", forControlEvents: .TouchUpInside)
        view.addSubview(btn)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if fileUrl != nil {
            playerView = SJPlyerView.playVideoWithUrl(fileUrl!, isfileplay: true, backOperation: nil)
        } else if url != nil {
            playerView = SJPlyerView.playVideoWithUrl(url!, isfileplay: false, backOperation: { [weak self]() -> () in
                print("点击了返回按钮")
                if let weakSelf = self {
                    weakSelf.navigationController?.popViewControllerAnimated(true)
                }
            })
        }
        playerView.backgroundColor = UIColor.blackColor()
        playerView.frame = CGRect(x: 10, y: 100, width: 350, height: 300)
        view.addSubview(playerView)

    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        playerView.resetPlayer()
      
    }
    
    func playNext() {
        
        if playerView.playStatus == SJPlyerViewStatus.ReadyToPlay {
        let  urlStr = "/Users/king/Pictures/好酷的舞蹈哦！.mp4"
        playerView.replaceWithURL(NSURL(fileURLWithPath: urlStr), isfileplay: true)
        }
    }
}
