//
//  SJTopView.swift
//  SJPlayerDemo
//
//  Created by king on 16/4/19.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit

class SJTopView : UIView {

    /// 返回按钮
   public private(set) lazy var backBtn: UIButton = {
        let btn = UIButton(type: .Custom)
        btn.setImage(UIImage(named: backImageName), forState: .Normal)
        return btn
    }()
    /// 标题标签
    public private(set) lazy var titleLabe = UILabel()
    
    /// 背景
    private lazy var bgImageView = UIImageView()
    
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
        
        bgImageView.frame = self.bounds
        titleLabe.frame = self.bounds
        backBtn.sj_x = 20
        backBtn.sj_width = self.sj_height - 5
        backBtn.sj_height = self.sj_height - 5
        backBtn.sj_centerY = self.sj_centerY
    }

}
extension SJTopView {
    
    /// 初始化
    private func InitializeUI() {
        
        titleLabe.textColor = UIColor.whiteColor()
        titleLabe.font = UIFont.systemFontOfSize(15)
        titleLabe.backgroundColor = UIColor.clearColor()
        titleLabe.textAlignment = .Center
        
        bgImageView.image = UIImage(named: topImageName)
        addSubview(bgImageView)
        addSubview(titleLabe)
        addSubview(backBtn)
    }
    
}