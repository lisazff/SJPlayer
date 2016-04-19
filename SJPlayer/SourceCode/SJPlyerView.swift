//
//  SJPlyerView.swift
//  SJPlayerDemo
//
//  Created by king on 16/4/19.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit
import AVFoundation

typealias backBlock = () -> ()


public enum SJPlyerViewStatus : Int {
    
    case Unknown
    case ReadyToPlay
    case Failed
}

/****************    公开方法      ************/
extension SJPlyerView {
    
    /**
     快速创建
     
     - parameter url:           url
     - parameter isfileplay:    是否是播放本地资源
     - parameter backOperation: 顶部返回按钮回调
     
     - returns: SJPlyerView
     */
    class func playVideoWithUrl(url: NSURL, isfileplay: Bool, backOperation: backBlock?) -> SJPlyerView {
        
        let playerView = SJPlyerView()
        playerView.configSJPlayer(url)
        playerView.url = url
        playerView.isFilePlay = isfileplay
        playerView.backOperation = backOperation
        return playerView
    }
    /**
     设置url
     
     - parameter url:        url
     - parameter isfileplay: 是否是播放本地资源
     */
    public func setVideoURL(url: NSURL, isfileplay: Bool) {
        configSJPlayer(url)
        self.isFilePlay = isfileplay
        self.url = url
    }
    /**
     切换
     
     - parameter url:        url
     - parameter isfileplay: 是否是播放本地资源
     */
    public func replaceWithURL(url: NSURL, isfileplay: Bool) {
        isReplayed = true
        self.isFilePlay = isfileplay
        resetPlayer()
        configSJPlayer(url)
        Play()
    }
    
    /**
     播放
     */
    public func Play() {
        
        player?.play()
        isPlayed = true
        toolsView.bottomView.playBtn.setImage(UIImage(named:pauseImageName), forState: .Normal)
    }
    /**
     暂停
     */
    public func Pause() {
        player?.pause()
    }
    /**
     重置播放器
     */
    public func resetPlayer() {
        reset()
        
    }
}

public class SJPlyerView : UIView {
    
    /// 操作层
    public private(set) lazy var toolsView: SJToolsView = SJToolsView()
    /// 状态
    public private(set) var playStatus: SJPlyerViewStatus?
    
    private var url: NSURL?

    private var player: AVPlayer? {
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
    private var isReplayed = false
    private var playStatusObserve: AnyObject?
    private lazy var dateFormatter = NSDateFormatter()
    private var playerItem: AVPlayerItem?
    private var playerLayer: AVPlayerLayer?
    private var backOperation: backBlock?
    
    
    override public class func layerClass() -> AnyClass {
        
        return AVPlayerLayer.self
    }

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
        toolsView.frame = self.bounds
    }
    
    deinit {
        print("销毁了")
        // 移除所有通知
        removeKVO()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension SJPlyerView {
    
    /// 初始化UI
    private func InitializeUI() {
        
        addSubview(toolsView)
        toolsView.backgroundColor = UIColor.clearColor()
        toolsView.bottomView.playBtn.enabled = false
        toolsView.bottomView.playBtn.addTarget(self, action: "playeBtnClick:", forControlEvents: .TouchUpInside)
        toolsView.bottomView.fullScreenBtn.addTarget(self, action: "fullScreenBtnClick:", forControlEvents: .TouchUpInside)
        toolsView.bottomView.videoSliderView.addTarget(self, action: "videoSliderChangeValue:", forControlEvents: .ValueChanged)
        toolsView.bottomView.videoSliderView.addTarget(self, action: "videoSliderChangeValueEnd:", forControlEvents: .TouchUpInside)
        toolsView.redialBtn.addTarget(self, action: "repeatPlay", forControlEvents: .TouchUpInside)
        toolsView.bottomView.fullScreenBtn.setImage(UIImage(named: fullScreenImageName), forState: .Normal)
        toolsView.topView.backBtn.addTarget(self, action: "backBtnClick", forControlEvents: .TouchUpInside)
    }
    /// 初始化播放相关
    private func configSJPlayer(url: NSURL) {
        
            // 初始化
            playerItem = AVPlayerItem(URL: url)
            // 创建player
            player = AVPlayer(playerItem: playerItem!)
            // 初始化playerLayer
            playerLayer = AVPlayerLayer(player: player)
            // 设置填充模式
            playerLayer?.videoGravity = AVLayerVideoGravityResizeAspect
            layer.insertSublayer(playerLayer!, atIndex: 0)
            /// 监听状态
            playerItem!.addObserver(self, forKeyPath: status, options: .New, context: nil)
            /// 监听缓冲进度
            playerItem!.addObserver(self, forKeyPath: loadedTimeRanges, options: .New, context: nil)
            toolsView.bottomView.playBtn.enabled = false
            /// 监听播放完毕通知
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayDidEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem!)
    }
    /// 复位
    private func reset() {
        
        isPlayed = false
        isFullScreen = false
        resetControlView()
        
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player?.replaceCurrentItemWithPlayerItem(nil)
        player = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        if isReplayed == false { self.removeFromSuperview() }
        
    }
    /// 复位控制层
    private func resetControlView() {

        toolsView.bottomView.playBtn.setImage(UIImage(named:playImageName), forState: .Normal)
        toolsView.bottomView.fullScreenBtn.setImage(UIImage(named: originalScreenImageName), forState: .Normal)
        toolsView.bottomView.videoSliderView.value = 0
        toolsView.bottomView.videoProgressView.progress = 0
    }
    
    private func removePlayer() {
        self.removeFromSuperview()
    }
    /// 移除KVO
    private func removeKVO() {
        
        // 移除KVO
        playerItem?.removeObserver(self, forKeyPath: status, context: nil)
        playerItem?.removeObserver(self, forKeyPath: loadedTimeRanges, context: nil)
        player?.removeTimeObserver(playStatusObserve!)
    }
    
}

/// 按钮事件
extension SJPlyerView {
    
    @objc private func backBtnClick() {
        
        resetPlayer()
        if backOperation != nil { backOperation!() }
    }
    
    
    @objc private func playeBtnClick(btn: UIButton) {
        
        toolsView.redialBtn.hidden = true
        
        if !isPlayed {
            playerLayer!.player!.play()
            btn.setImage(UIImage(named: pauseImageName), forState: .Normal)
        } else {
            playerLayer!.player!.pause()
            btn.setImage(UIImage(named:playImageName), forState: .Normal)
        }
        isPlayed = !isPlayed
    }
    @objc private func fullScreenBtnClick(btn: UIButton) {
        
        if !isFullScreen {
            btn.setImage(UIImage(named: originalScreenImageName), forState: .Normal)
        } else {
            btn.setImage(UIImage(named: fullScreenImageName), forState: .Normal)
        }
        isFullScreen = !isFullScreen
    }
    
    @objc private func videoSliderChangeValue(sender: UISlider) {
        playerLayer!.player!.pause()
        if sender.value == 0.0 {
            // 让其从头开始播放
            player?.seekToTime(kCMTimeZero, completionHandler: { [weak self](_) -> Void in
               
                if let weakSelf = self {
                    weakSelf.player?.play()
                    weakSelf.toolsView.bottomView.playBtn.setImage(UIImage(named: pauseImageName), forState: .Normal)
                    weakSelf.isPlayed = !weakSelf.isPlayed
                }
            })

        }
    }
    @objc private func videoSliderChangeValueEnd(sender: UISlider) {
        
        // 计算拖动的位置
        let changeTime = CMTimeMakeWithSeconds(Float64(NSInteger(sender.value)), 1)
        // 从拖动到的位置播放
        player?.seekToTime(changeTime, completionHandler: { [weak self](_) -> Void in
            if let weakSelf = self {
            weakSelf.player?.play()
            weakSelf.toolsView.bottomView.playBtn.setImage(UIImage(named:pauseImageName), forState: .Normal)
            weakSelf.toolsView.bottomView.videoSliderView.value = 0
            weakSelf.toolsView.bottomView.videoProgressView.progress = 0
            weakSelf.isPlayed = true
            }
        })
    }
    
    @objc private func moviePlayDidEnd(item: AVPlayerItem) {
        
        // 播放完毕
        // 回到当初状态
        playerLayer!.player!.seekToTime(kCMTimeZero, completionHandler: { [weak self] (_) -> Void in
            if let weakSelf = self {
//                weakSelf.toolsView.bottomView.videoSliderView.setValue(0.0, animated: true)
//                weakSelf.toolsView.bottomView.playBtn.setImage(UIImage(named:playImageName), forState: .Normal)
                weakSelf.resetControlView()
                weakSelf.isPlayed = false
                weakSelf.toolsView.redialBtn.hidden = false
                weakSelf.removeKVO()
            }
        })
    }
    
    @objc private func repeatPlay() {
        toolsView.redialBtn.hidden = true
        isReplayed = true
        resetPlayer()
        configSJPlayer(url!)
        Play()
    }
}

/// 通知相关
extension SJPlyerView {
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let item: AVPlayerItem = object as! AVPlayerItem
        
        if keyPath == status {
            if item.status == .ReadyToPlay {
                playStatus = SJPlyerViewStatus.ReadyToPlay
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
                playStatus = SJPlyerViewStatus.Failed
//                print("播放失败")
            } else if item.status == .Unknown {
                playStatus = SJPlyerViewStatus.Unknown
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
        
        playStatusObserve = player?.addPeriodicTimeObserverForInterval(CMTime(value: 1, timescale: 1), queue: dispatch_get_main_queue(), usingBlock: { [weak self] (time) -> Void in
            
            if let weakSelf = self {
            // 当前第几秒
            let currentSecond = item.currentTime().value / CMTimeValue(item.currentTime().timescale)
            weakSelf.toolsView.bottomView.videoSliderView.setValue(Float(currentSecond), animated: true)
            let timeStr = weakSelf.dealTime(currentSecond)
            weakSelf.toolsView.bottomView.currentPlayTimeLabel.text = timeStr
            weakSelf.toolsView.bottomView.totalPlayTimeLabel.text = weakSelf.totalTime
            
            if weakSelf.isFilePlay == true {
                let progress = Float(currentSecond) / Float(weakSelf.toolsView.bottomView.videoSliderView.sj_width)
                weakSelf.toolsView.bottomView.videoProgressView.setProgress(progress, animated: true)
                }
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