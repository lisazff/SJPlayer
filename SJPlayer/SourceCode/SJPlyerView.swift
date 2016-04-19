//
//  SJPlyerView.swift
//  SJPlayerDemo
//
//  Created by king on 16/4/19.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit
import AVFoundation

/****************    公开方法      ************/
extension SJPlyerView {
    
    /**
     播放
     */
    public func plyerViewPlay() {
        
        player?.play()
    }
    /**
     暂停
     */
    public func plyerViewPause() {
        player?.pause()
    }
    /**
     重播
     */
    public func plyerViewRedial() {
        repeatPlay()
    }
}

class SJPlyerView : UIView {
    
    /****************    公开属性      ************/
    public var url: NSURL? {
        didSet {
            if let url = url {
            isFilePlay = false
            resetPlayer()
            InitializePlay(url)
            }
        }
    }
    public var fileUrl: NSURL? {
        didSet{
            if let fileUrl = fileUrl {
            isFilePlay = true
            resetPlayer()
            InitializePlay(fileUrl)
            }
        }
    }
    /// 工具层
    public private(set) lazy var toolsView: SJToolsView = SJToolsView()

    public var player: AVPlayer? {
        get {
            return (self.layer as! AVPlayerLayer).player
        }
        set {
            (self.layer as! AVPlayerLayer).player = newValue
        }
    }
    
    /****************    内部属性/方法     ************/
    private var totalTime = "00:00"
    private var isPlayed = false
    private var isFilePlay: Bool?
    private var isFullScreen = false
    private var playStatusObserve: AnyObject?
    private lazy var dateFormatter = NSDateFormatter()
    private var playerItem: AVPlayerItem?
    
    
    
    override class func layerClass() -> AnyClass {
        
        return AVPlayerLayer.self
    }

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
        toolsView.frame = self.bounds
    }
    
    deinit {
        print("销毁了")
        resetPlayer()
        // 移除所有通知
        removeObserver()
    }
}

extension SJPlyerView {
    
    /// 初始化UI
    private func InitializeUI() {
        
        (self.layer as! AVPlayerLayer).videoGravity = AVLayerVideoGravityResizeAspectFill
        addSubview(toolsView)
        toolsView.backgroundColor = UIColor.clearColor()
        toolsView.bottomView.playBtn.enabled = false
        toolsView.bottomView.playBtn.addTarget(self, action: "playeBtnClick:", forControlEvents: .TouchUpInside)
        toolsView.bottomView.fullScreenBtn.addTarget(self, action: "fullScreenBtnClick:", forControlEvents: .TouchUpInside)
        toolsView.bottomView.videoSliderView.addTarget(self, action: "videoSliderChangeValue:", forControlEvents: .ValueChanged)
        toolsView.bottomView.videoSliderView.addTarget(self, action: "videoSliderChangeValueEnd:", forControlEvents: .TouchUpInside)
        toolsView.redialBtn.addTarget(self, action: "repeatPlay", forControlEvents: .TouchUpInside)
    }
    /// 初始化播放相关
    private func InitializePlay(url: NSURL) {
        
            playerItem = AVPlayerItem(URL: url)
            /// 监听状态
            playerItem!.addObserver(self, forKeyPath: status, options: .New, context: nil)
            /// 监听缓冲进度
            playerItem!.addObserver(self, forKeyPath: loadedTimeRanges, options: .New, context: nil)
            player = AVPlayer(playerItem: playerItem!)
            toolsView.bottomView.playBtn.enabled = false
            /// 监听播放完毕通知
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayDidEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem!)
    }
    /// 复位
    private func resetPlayer() {
        
        player?.pause()
        player = nil
        playerItem = nil
    }
    
    /// 移除所有通知
    private func removeObserver() {
        
        resetPlayer()
        // 移除所有通知
        playerItem?.removeObserver(self, forKeyPath: status, context: nil)
        playerItem?.removeObserver(self, forKeyPath: loadedTimeRanges, context: nil)
        player?.removeTimeObserver(playStatusObserve!)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
    }
    
}

/// 按钮事件
extension SJPlyerView {
    
    @objc private func playeBtnClick(btn: UIButton) {
        
        toolsView.redialBtn.hidden = true
        
        if !isPlayed {
            player?.play()
            btn.setImage(UIImage(named: pauseImageName), forState: .Normal)
        } else {
            player?.pause()
            btn.setImage(UIImage(named:playImageName), forState: .Normal)
        }
        isPlayed = !isPlayed
    }
    @objc private func fullScreenBtnClick(btn: UIButton) {
        
        if !isFullScreen {
            btn.setImage(UIImage(named: fullScreenImageName), forState: .Normal)
        } else {
            btn.setImage(UIImage(named: originalScreenImageName), forState: .Normal)
        }
        isFullScreen = !isFullScreen
    }
    
    @objc private func videoSliderChangeValue(sender: UISlider) {
        player?.pause()
//        print("change: \(sender.value)")
        if sender.value == 0.0 {
            // 让其从头开始播放
            player?.seekToTime(kCMTimeZero, completionHandler: { [unowned self](_) -> Void in
                self.player?.play()
                self.toolsView.bottomView.playBtn.setImage(UIImage(named: pauseImageName), forState: .Normal)
                self.isPlayed = !self.isPlayed
                })

        }
    }
    @objc private func videoSliderChangeValueEnd(sender: UISlider) {
        
//        print("change: \(sender.value)")
        // 计算拖动的位置
        let changeTime = CMTimeMakeWithSeconds(Float64(NSInteger(sender.value)), 1)
        // 从拖动到的位置播放
        player?.seekToTime(changeTime, completionHandler: { [unowned self](_) -> Void in
            self.player?.play()
            self.toolsView.bottomView.playBtn.setImage(UIImage(named:pauseImageName), forState: .Normal)
            self.isPlayed = true
        })
    }
    
    @objc private func moviePlayDidEnd(item: AVPlayerItem) {
        
//        print("播放完毕")
        // 回到当初状态
        player?.seekToTime(kCMTimeZero, completionHandler: { [unowned self] (_) -> Void in
            self.toolsView.bottomView.videoSliderView.setValue(0.0, animated: true)
            self.toolsView.bottomView.playBtn.setImage(UIImage(named:playImageName), forState: .Normal)
            self.isPlayed = false
            self.toolsView.redialBtn.hidden = false
            self.removeObserver()
        })
    }
    
    @objc private func repeatPlay() {
        print("重拨")
        toolsView.redialBtn.hidden = true
        
    }
}

/// 通知相关
extension SJPlyerView {
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let item: AVPlayerItem = object as! AVPlayerItem
        
        if keyPath == status {
            if item.status == .ReadyToPlay {
                
                print("可以播放")
                toolsView.bottomView.playBtn.enabled = true
                // 获取视频的总长度
                let duration = item.duration
                // 装换成秒数
                let totalSeconde = item.duration.value / CMTimeValue(item.duration.timescale)
                // 转换成字符串
                totalTime = dealTime(totalSeconde)
                // 处理滑块
                dealViedoSlider(duration)
                // 监听播放状态
                observePlayStatus(item)
            } else if item.status == .Failed {
                print("播放失败")
            }
            
        } else if keyPath == loadedTimeRanges {
            if isFilePlay == true { return }
            // 计算缓冲进度
            let timeInterval = calculateBuffer()
            let duration = item.duration
            let totalDuration = CMTimeGetSeconds(duration)
            toolsView.bottomView.videoProgressView.setProgress(Float(timeInterval / totalDuration), animated: true)
        }
    }
    
    private func observePlayStatus(item: AVPlayerItem) {
        
        playStatusObserve = player?.addPeriodicTimeObserverForInterval(CMTime(value: 1, timescale: 1), queue: dispatch_get_main_queue(), usingBlock: { [unowned self] (time) -> Void in
            // 当前第几秒
            let currentSecond = item.currentTime().value / CMTimeValue(item.currentTime().timescale)
            self.toolsView.bottomView.videoSliderView.setValue(Float(currentSecond), animated: true)
            let timeStr = self.dealTime(currentSecond)
            self.toolsView.bottomView.currentPlayTimeLabel.text = timeStr
            self.toolsView.bottomView.totalPlayTimeLabel.text = self.totalTime
            
            if self.isFilePlay == true {
            let progress = Float(currentSecond) / Float(self.toolsView.bottomView.videoSliderView.sj_width)
            self.toolsView.bottomView.videoProgressView.setProgress(progress, animated: true)
            }
        })
        
    }
    
    private func dealTime(time: CMTimeValue) -> String {
        
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(time))
        dateFormatter.dateFormat = time / 3600 >= 1 ? "HH:mm:ss" : "mm:ss"
        
        return dateFormatter.stringFromDate(date)
    }
    
    private func dealViedoSlider(duration: CMTime) {
        toolsView.bottomView.videoSliderView.maximumValue = Float(CMTimeGetSeconds(duration))
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 2, height: 2), false, 0.0)
        let tmpImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
//        toolsView.bottomView.videoSliderView.setMinimumTrackImage(tmpImage, forState: .Normal)
        toolsView.bottomView.videoSliderView.setMaximumTrackImage(tmpImage, forState: .Normal)
    }
    
    private func calculateBuffer() -> NSTimeInterval {
        
        let loadeTimeRanges = player?.currentItem?.loadedTimeRanges
        // 获取缓冲区域
        let timeRange = loadeTimeRanges?.first?.CMTimeRangeValue
        let start = CMTimeGetSeconds((timeRange?.start)!)
        let duration = CMTimeGetSeconds((timeRange?.duration)!)
        // 计算缓冲总进度
        return start + duration
    }
}