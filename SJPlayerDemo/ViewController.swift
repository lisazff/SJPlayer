//
//  ViewController.swift
//  SJPlayerDemo
//
//  Created by king on 16/4/19.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
    let VC = PlayerViewController()
    
    let filePathUrl2: NSURL = {
        let path = "/Users/king/Pictures/Worth it - Fifth Harmony ft.Kid Ink - May J Lee Choreography.mp4"
        return NSURL(fileURLWithPath: path)
    }()
    
    let videoUrl = NSURL(string: "http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBAction func playLocal() {
        
        VC.playerView.fileUrl = filePathUrl2
        navigationController?.pushViewController(VC, animated: true)
    }

    @IBAction func playNetwork() {
        
        VC.playerView.url = videoUrl
        navigationController?.pushViewController(VC, animated: true)
    }

}

