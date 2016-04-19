//
//  UIView+Extension.swift
//  SJPlayerDemo
//
//  Created by king on 16/4/19.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit

/*************************** UIView扩展 ************************************/
extension UIView {
    
    public var sj_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }
    public var sj_x:CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
    }
    public var sj_y:CGFloat {
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin.y = newValue
        }
    }
    public var sj_width:CGFloat {
        get{
            return self.frame.size.width
        }
        set{
            self.frame.size.width = newValue
        }
    }
    public var sj_height:CGFloat {
        get{
            return self.frame.size.height
        }
        set{
            self.frame.size.height = newValue
        }
    }
    public var sj_centerX:CGFloat {
        get{
            return self.center.x
        }
        set{
            self.center.x = newValue
        }
    }
    public var sj_centerY:CGFloat {
        get{
            return self.center.y
        }
        set{
            self.center.y = newValue
        }
    }
    public var sj_right:CGFloat {
        get{
            return CGRectGetMaxX(self.frame)
        }
        set{
            self.frame.origin.x = newValue - sj_width
        }
    }
    public var sj_bottom:CGFloat {
        get{
            return CGRectGetMaxY(self.frame)
        }
        set{
            self.frame.origin.y = newValue - sj_height
        }
    }
}
