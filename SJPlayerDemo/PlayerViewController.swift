//
//  PlayerViewController.swift
//  SJPlayerDemo
//
//  Created by king on 16/4/19.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    public let playerView = SJPlyerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.blackColor()
        playerView.frame = view.bounds
        view.addSubview(playerView)
        
    }

}
