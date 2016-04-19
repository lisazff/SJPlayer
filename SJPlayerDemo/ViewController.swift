//
//  ViewController.swift
//  SJPlayerDemo
//
//  Created by king on 16/4/19.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit

let filePathUrl: NSURL = {
    let path = "/Users/king/Pictures/Worth it - Fifth Harmony ft.Kid Ink - May J Lee Choreography.mp4"
    return NSURL(fileURLWithPath: path)
}()
let videoUrl1 = NSURL(string: "http://f4v.233.com/learn/-FZGsXHsPhM6vS9du2AtRJgOL351PznkVQzMbynXUs7LDuC36dG0omTt2fiNY3GEkm832GPw-CTYrz7X6b4SJnAjCqqQfvThOXDcRyV3wG7wK1ppdMSGq1ItiowIipMpTzMjvH5ibewZ+uO-SP+7Z110xpgYuORB8EDHQGV-8j4lz3FkvsFWulId-43M+bX1FUah5YM7fOWMVjoxBibDfwYO-D7Tbyc2nX-xSCSaIDE+yDPQdTSFCnhqN-ITVtbPn4ybWXj1A0lreUHjVnMIbg==")

let videoUrl2 = NSURL(string: "http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA")

class ViewController: UIViewController {

  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBAction func playLocal() {
        
        let VC = PlayerViewController()
        VC.fileUrl = filePathUrl
        navigationController?.pushViewController(VC, animated: true)
    }

    @IBAction func playNetwork() {
        
        let VC = PlayerViewController()
        VC.url = videoUrl2
        navigationController?.pushViewController(VC, animated: true)
    }

}

