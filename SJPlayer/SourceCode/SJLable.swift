//
//  SJLable.swift
//  SJPlayerDemo
//
//  Created by king on 16/4/19.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit

public class SJLable : UILabel {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        InitializeUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        InitializeUI()
        
    }
    private func InitializeUI() {
        
        backgroundColor = UIColor.clearColor()
        textColor = UIColor.whiteColor()
        textAlignment = .Center
        font = UIFont.systemFontOfSize(13)
        text = "00:00"
    }


}
