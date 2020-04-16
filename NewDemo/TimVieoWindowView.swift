//
//  TimVieoWindowView.swift
//  NewDemo
//
//  Created by botu on 2020/4/15.
//  Copyright © 2020 slowdony. All rights reserved.
//

import UIKit
let centerX :CGFloat = 0
let centerY :CGFloat = 0
enum SuspendedBallLocation:Int {
        case SuspendedBallLocation_LeftTop = 0
        case SuspendedBallLocation_Top
        case SuspendedBallLocation_RightTop
        case SuspendedBallLocation_Right
        case SuspendedBallLocation_RightBottom
        case SuspendedBallLocation_Bottom
        case SuspendedBallLocation_LeftBottom
        case SuspendedBallLocation_Left
    }




class TimVieoWindowView: UIView {

    private var ballBtn:UIButton?
    private var timeLable:UILabel?
    private var currentCenter:CGPoint?
    private var panEndCenter:CGPoint = CGPoint.init(x: 0, y: 0)
    private var currentLocation:SuspendedBallLocation?{
        didSet{
            if currentLocation ==  SuspendedBallLocation.SuspendedBallLocation_LeftTop {
                self.layer.anchorPoint = CGPoint.init(x: 0, y: 0)
            }else if currentLocation ==  SuspendedBallLocation.SuspendedBallLocation_Top {
                self.layer.anchorPoint = CGPoint.init(x: 0, y: 0)
            }else if currentLocation ==  SuspendedBallLocation.SuspendedBallLocation_RightTop {
                self.layer.anchorPoint = CGPoint.init(x: 1, y: 0)
            }else if currentLocation ==  SuspendedBallLocation.SuspendedBallLocation_Left {
                self.layer.anchorPoint = CGPoint.init(x: 0, y: 0)
            }else if currentLocation ==  SuspendedBallLocation.SuspendedBallLocation_Right {
                self.layer.anchorPoint = CGPoint.init(x: 1, y: 0)
            }else if currentLocation ==  SuspendedBallLocation.SuspendedBallLocation_LeftBottom {
                self.layer.anchorPoint = CGPoint.init(x: 0, y: 0)
            }else if currentLocation ==  SuspendedBallLocation.SuspendedBallLocation_Bottom {
                self.layer.anchorPoint = CGPoint.init(x: 1, y: 0)
            }else if currentLocation ==  SuspendedBallLocation.SuspendedBallLocation_RightBottom {
                self.layer.anchorPoint = CGPoint.init(x: 1, y: 0)
            }
        }
    }
    
    var callingVC : UIViewController!

    
    
    override init(frame: CGRect) {
            super.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            
            
            //增加呼出界面
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            callingVC = (storyboard.instantiateViewController(withIdentifier: "video")as? test1ViewController)!
            
            self.addSubview(callingVC.view)
            
            
            ballBtn = UIButton.init(type: .custom)
//            ballBtn?.setBackgroundImage(UIImage.init(named: "shrink"), for: .normal)
        ballBtn?.setTitle("点我", for: UIControl.State.normal)
            ballBtn?.imageView?.contentMode = .center
            ballBtn?.frame = CGRect.init(x: 3, y: 40, width: 50, height: 40)
        ballBtn?.backgroundColor = UIColor.red
            ballBtn?.addTarget(self, action: #selector(clickBallViewAction), for: .touchUpInside)
            self.addSubview(self.ballBtn!)
            
            
            self.backgroundColor = UIColor.clear
            self.currentCenter = CGPoint.init(x: frame.size.width/2, y: frame.size.height/2) //初始位置
            self.calculateShowCenter(point: self.currentCenter!)
            self.configLocation(point: self.currentCenter!)
            //跟随手指拖动
            let moveGes:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.dragBallView))
            self.addGestureRecognizer(moveGes)
            
            //添加到window上
            self.ww_getKeyWindow().addSubview(self)
            //显示在视图的最上层
        self.ww_getKeyWindow().bringSubviewToFront(self)
     
        }
    
    
    
    
    
    //跟随手指拖动
        @objc func dragBallView(panGes:UIPanGestureRecognizer) {
            if self.frame.size.width != kScreenW {
                let translation:CGPoint = panGes.translation(in: self.ww_getKeyWindow())
                let center:CGPoint = self.center
                self.center = CGPoint.init(x: center.x+translation.x, y: center.y+translation.y)
                panGes .setTranslation(CGPoint.init(x: 0, y: 0), in: self.ww_getKeyWindow())
                if panGes.state == UIGestureRecognizer.State.ended{
                    self.panEndCenter = self.center
                    self.caculateBallCenter()
                }
            }
            
        }
        //计算中心位置
        func caculateBallCenter() {
            if (self.panEndCenter.x>centerX && self.panEndCenter.x < kScreenW-centerX && self.panEndCenter.y>centerY && self.panEndCenter.y<kScreenH-centerY) {
                //在上下左右距离边30的矩形里
                if (self.panEndCenter.y<3*centerY) {
                    
                    if self.panEndCenter.x < 4*centerX {
                        self.calculateBallNewCenter(point: CGPoint.init(x: 3*centerX , y: 30+centerY))
                    }else{
                        self.calculateBallNewCenter(point: CGPoint.init(x: self.panEndCenter.x, y: 30+centerY))
                    }
                    
                    
                }
                else if (self.panEndCenter.y>kScreenH-3*centerY)
                {
                    //                左下角
                    //
                    if self.panEndCenter.x < 4*centerX {
                        self.calculateBallNewCenter(point: CGPoint.init(x: centerX+2*centerY, y: kScreenH-4*centerY-10))
                    }else{
                        self.calculateBallNewCenter(point: CGPoint.init(x: self.panEndCenter.x, y: kScreenH-4*centerY-10))
                    }
                    
                    
                }
                else
                {
                    if (self.panEndCenter.x<=kScreenW/2) {
                         self.calculateBallNewCenter(point: CGPoint.init(x: centerX+2*centerY, y: self.panEndCenter.y))
                        
                    }
                    else{
                        self.calculateBallNewCenter(point: CGPoint.init(x: kScreenW-centerX, y: self.panEndCenter.y))
                    }
                }
            }
            else
            {
                if (self.panEndCenter.x<=centerX && self.panEndCenter.y<=centerY)
                {
                    self.calculateBallNewCenter(point: CGPoint.init(x: 3*centerX, y: centerY))
                }
                else if (self.panEndCenter.x>=kScreenW-centerX && self.panEndCenter.y<=centerY)
                {
                    //右上角
                    self.calculateBallNewCenter(point: CGPoint.init(x: kScreenW-centerX, y:centerY))
                }
                else if (self.panEndCenter.x>=kScreenW-centerX && self.panEndCenter.y>=kScreenH-centerY)
                {
                    self.calculateBallNewCenter(point: CGPoint.init(x: kScreenW-centerX, y: kScreenH-centerY))
                }
                else if(self.panEndCenter.x<=centerX && self.panEndCenter.y>=kScreenH-centerY)
                {
                    self.calculateBallNewCenter(point: CGPoint.init(x: centerX, y: kScreenH-centerY))
                }
                else if (self.panEndCenter.x>centerX && self.panEndCenter.x<kScreenW-centerX && self.panEndCenter.y<centerY)
                {
                    //左上角
                    if self.panEndCenter.x<4*centerX{
                        self.calculateBallNewCenter(point: CGPoint.init(x: 3*centerX, y: centerY))
                    }else{
                        self.calculateBallNewCenter(point: CGPoint.init(x: self.panEndCenter.x, y: centerY))
                    }
                    
                    
                }
                else if (self.panEndCenter.x>centerX && self.panEndCenter.x<kScreenW-centerX && self.panEndCenter.y>kScreenH-centerY)
                {
                    self.calculateBallNewCenter(point: CGPoint.init(x: self.panEndCenter.x, y:kScreenH-centerY))
                }
                else if (self.panEndCenter.y>centerY && self.panEndCenter.y<kScreenH-centerY && self.panEndCenter.x<centerX)
                {
                    self.calculateBallNewCenter(point: CGPoint.init(x: 3*centerX, y: self.panEndCenter.y))
                }
                else if (self.panEndCenter.y>centerY && self.panEndCenter.y<kScreenH-centerY && self.panEndCenter.x>kScreenW-centerX)
                {
                    //右下角
                    if self.panEndCenter.y>kScreenH-4*centerY {
                        self.calculateBallNewCenter(point: CGPoint.init(x: kScreenW-centerX, y:kScreenH-4*centerY-10))
                    }else{
                        self.calculateBallNewCenter(point: CGPoint.init(x: kScreenW-centerX, y:self.panEndCenter.y))
                    }
                    
                    
                }
            }
            
        }


    //计算浮窗新的中心点
        func calculateBallNewCenter(point:CGPoint) {
            self.currentCenter = point
            self.configLocation(point: point)
            unowned let weakSelf = self
            UIView.animate(withDuration: 0.3) {
                weakSelf.center = CGPoint.init(x: point.x, y: point.y)
            }
        }

    
    
    
    
    
    //MARK:- 悬浮窗按钮方法
        @objc func clickBallViewAction() {
            if self.frame.size.width == kScreenW {
                //缩小
                //固定缩放的中心点为右上角
                let frame = self.callingVC.view.frame
                self.layer.anchorPoint = CGPoint.init(x: 1, y: 0)
                self.frame = frame
                
                self.smallToShow()
//                var callingVCFrame = self.callingVC.view.frame
//                callingVCFrame.origin.y -= 70
//                callingVCFrame.origin.x -= 50
//                callingVCFrame.size.width += 100
//                callingVCFrame.size.height += 140
//                self.ballBtn?.frame = callingVCFrame
//                ballBtn?.setBackgroundImage(UIImage.init(named: "拨打中"), for: .normal)
                ballBtn?.setTitle("拨打中?", for: UIControl.State.normal)
//                ballBtn?.imageView?.contentMode = .scaleToFill
                
                
                
                
                
                let point = CGPoint.init(x: kScreenW-centerX, y:centerY) //初始位置
                self.calculateShowCenter(point: point)
                self.configLocation(point: point)
                
            }else{
                //放大
                
                
                //固定缩放的中心点为右上角
                let frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH)
                self.layer.anchorPoint = CGPoint.init(x: 1, y: 0)
                self.frame = frame
                
                self.bigToShow()
                self.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH)
                self.ballBtn?.frame = CGRect.init(x: kScreenW-51, y: 40, width: 31, height: 23)
                ballBtn?.setBackgroundImage(UIImage.init(named: "shrink"), for: .normal)
                ballBtn?.imageView?.contentMode = .center
                
                
            }
        }
    //放大
        func bigToShow(){
            let animation = CAKeyframeAnimation.init(keyPath: "transform")
            animation.duration = 0.5
            let values = NSMutableArray.init()
            values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(0.2, 0.17, 1.0)))
            values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
            animation.values = values as? [Any]
            
            self.layer.add(animation, forKey: nil)
            self.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
        
        //缩小
        func smallToShow(){
            let animation = CAKeyframeAnimation.init(keyPath: "transform")
            animation.duration = 0.5
            let values = NSMutableArray.init()
            values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
            values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(0.2, 0.17, 1.0)))
            animation.values = values as? [Any]
            
            self.layer.add(animation, forKey: nil)
            self.layer.transform = CATransform3DMakeScale(0.2, 0.17, 1)
        }
   
    
    
    
    
    
    //MARK:- private utility
        func ww_getKeyWindow() -> UIWindow {
            if UIApplication.shared.keyWindow == nil {
                return ((UIApplication.shared.delegate?.window)!)!
            }else{
                return UIApplication.shared.keyWindow!
            }
        }
    //计算浮窗展示的中心点
        func calculateShowCenter(point:CGPoint) {
            unowned let weakSelf = self
            UIView.animate(withDuration: 0.3) {
                weakSelf.center = CGPoint.init(x: point.x, y: point.y)
            }
        }
     //当前方位
        func configLocation(point:CGPoint) {
            if (point.x <= centerX*3 && point.y <= centerY*3) {
                self.currentLocation = .SuspendedBallLocation_LeftTop;
            }
            else if (point.x>centerX*3 && point.x<kScreenW-centerX*3 && point.y == centerY)
            {
                self.currentLocation = .SuspendedBallLocation_Top;
            }
            else if (point.x >= kScreenW-centerX*3 && point.y <= 3*centerY)
            {
                self.currentLocation = .SuspendedBallLocation_RightTop;
            }
            else if (point.x == kScreenW-centerX && point.y>3*centerY && point.y<kScreenH-centerY*3)
            {
                self.currentLocation = .SuspendedBallLocation_Right;
            }
            else if (point.x >= kScreenW-3*centerX && point.y >= kScreenH-3*centerY)
            {
                self.currentLocation = .SuspendedBallLocation_RightBottom;
            }
            else if (point.y == kScreenH-centerY && point.x > 3*centerX && point.x<kScreenW-3*centerX)
            {
                self.currentLocation = .SuspendedBallLocation_Bottom;
            }
            else if (point.x <= 3*centerX && point.y >= kScreenH-3*centerY)
            {
                self.currentLocation = .SuspendedBallLocation_LeftBottom;
            }
            else if (point.x == centerX && point.y > 3*centerY && point.y<kScreenH-3*centerY)
            {
                self.currentLocation = .SuspendedBallLocation_Left;
            }
        }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
