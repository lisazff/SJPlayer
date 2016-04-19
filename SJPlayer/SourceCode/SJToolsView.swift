//
//  SJToolsView.swift
//  SJPlayerDemo
//
//  Created by king on 16/4/19.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit

class SJToolsView: UIView {

    /// 顶部工具条
    public private(set) lazy var topView: SJTopView = SJTopView()
    /// 底部工具条
    public private(set) lazy var bottomView: SJBottomView = SJBottomView()
    /// 中间重拨按钮
    public private(set) lazy var redialBtn: UIButton = {
        let btn = UIButton(type: .Custom)
        btn.setImage(UIImage(named: repaestImageName), forState: .Normal)
        btn.hidden = true
        return btn
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        InitializeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        InitializeUI()
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        topView.frame = CGRect(x: 0, y: 0, width: self.sj_width, height: 35)
        redialBtn.sj_size = CGSize(width: 60, height: 60)
        redialBtn.center = self.center
        bottomView.frame = CGRect(x: 0, y: self.sj_height - 35, width: self.sj_width, height: 35)
    }
}

extension SJToolsView {
    
    private func InitializeUI() {
        addSubview(topView)
        addSubview(redialBtn)
        addSubview(bottomView)
    }
}

extension SJToolsView {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
       
    }
}