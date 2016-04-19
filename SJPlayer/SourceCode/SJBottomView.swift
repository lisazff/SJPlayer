//
//  SJBottomView.swift
//  SJPlayerDemo
//
//  Created by king on 16/4/19.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit

public class SJBottomView : UIView {

    /// 播放按钮
    public private(set) lazy var playBtn = UIButton()
    /// 全屏按钮
    public private(set) lazy var fullScreenBtn = UIButton()
    /// 缓冲进度条
    public private(set) lazy var videoProgressView = UIProgressView()
    /// 当前播放进度滑块
    public private(set) lazy var videoSliderView = UISlider()
    /// 当前播放时间标签
    public private(set) lazy var currentPlayTimeLabel: SJLable = SJLable()
    /// 总时间标签
    public private(set) lazy var totalPlayTimeLabel: SJLable = SJLable()
    /// 背景
    private lazy var bgImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        InitializeUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        InitializeUI()
        
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        bgImageView.frame = self.bounds
        
        let centerY = self.sj_height * 0.5
        playBtn.sj_x = 5
        playBtn.sj_size = CGSize(width: self.sj_height, height: self.sj_height)
        playBtn.sj_centerY = centerY
        
        currentPlayTimeLabel.sj_x = playBtn.sj_right
        currentPlayTimeLabel.sj_width = 40
        currentPlayTimeLabel.sj_height = self.sj_height
        currentPlayTimeLabel.sj_centerY = centerY
        
        fullScreenBtn.sj_right = self.sj_width - 5
        fullScreenBtn.sj_size = CGSize(width: self.sj_height, height: self.sj_height)
        fullScreenBtn.sj_centerY = centerY
        
        totalPlayTimeLabel.sj_size = currentPlayTimeLabel.sj_size
        totalPlayTimeLabel.sj_right = fullScreenBtn.sj_x
        totalPlayTimeLabel.sj_centerY = centerY
        
       
            
        videoProgressView.sj_x = currentPlayTimeLabel.sj_right + 10
         let videoProgressViewW = self.sj_width - totalPlayTimeLabel.sj_width - fullScreenBtn.sj_width - videoProgressView.sj_x
        videoProgressView.sj_width = videoProgressViewW - 10
        videoProgressView.sj_centerY = centerY
        
        videoSliderView.frame = videoProgressView.frame
        
    }
}
extension SJBottomView {
    
    /// 初始化
    private func InitializeUI() {
        
        playBtn.setImage(UIImage(named: playImageName), forState: .Normal)
        fullScreenBtn.setImage(UIImage(named: fullScreenImageName), forState: .Normal)
        videoProgressView.progress = 0
        videoSliderView.setValue(0.0, animated: true)
        bgImageView.image = UIImage(named: bottomImageName)
        addSubview(bgImageView)
        addSubview(playBtn)
        addSubview(currentPlayTimeLabel)
        addSubview(videoProgressView)
        addSubview(videoSliderView)
        addSubview(totalPlayTimeLabel)
        addSubview(fullScreenBtn)
    }
    
}
