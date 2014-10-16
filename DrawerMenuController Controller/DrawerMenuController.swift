//
//  DrawerMenuExplain.swift
//  DrawerMenuController Controller
//
//  Created by SunSet on 14-7-18.
//  Copyright (c) 2014年 zhaokaiyuan. All rights reserved.
// qq 623046455 邮箱 zhaokaiyuan99@163.com


import UIKit

enum MenuDirection {
    case leftMenu
    case rightMenu
    case middleMenu
}



@objc protocol DrawerMenuControllerDelegate : NSObjectProtocol {
    
    //滑动变化
    optional func CustomlayoutViewWithOffset(xoffset:CGFloat,menuController:DrawerMenuController)
}



class DrawerMenuController: UIViewController ,UIGestureRecognizerDelegate {
    var delegate:DrawerMenuControllerDelegate?
    
    
    //是否边界影子
    var showBoundsShadow:Bool =  true {
        willSet{
            
        }
        didSet{
            
        }
        
    }
    
    //是否能滑动
    var needSwipeShowMenu:Bool = true
        
        {
        willSet{
            
        }
        didSet{
            if needSwipeShowMenu{
                self.view.addGestureRecognizer(movePan!)
            }else{
                self.view.removeGestureRecognizer(movePan!)
            }
        }
        
    }
    
    var minScale:CGFloat = 0.8                  //root 最小缩放
    var leftViewShowWidth:CGFloat = 220         //左边View 长度
    var leftSmoothWidth:CGFloat = 80          //滑动是缩放后平滑距离
    var rightViewShowWidth:CGFloat = 220        //右边
    var rightSmoothWidth:CGFloat = 80
    var directionAnimationDuration:CGFloat =  0.8        //左右滑动动画时间
    var backAnimationDuration:CGFloat =  0.35            //返回动画时间
    var bounces:Bool = true                              //滑动边界回弹
    var springBack:Bool = true  //是否支持回弹效果 object—c 只有ios7 以上有效 swift ios7以下未知 没有测试过
    var springBackDuration:CGFloat = 0.5        //回弹时间
    var SpringVelocity:CGFloat = 0.5
    
    
    var movePan:UIPanGestureRecognizer?
    var blackCoverPan:UIPanGestureRecognizer?
    var blackTapPan:UITapGestureRecognizer?
    
    var startPanPoint:CGPoint = CGPointMake(0, 0)
    var panMovingRightOrLeft:Bool = false
    
    var panRight:Bool = false
    var panLeft:Bool = false
    var isInAnimation:Bool = false
    
    var menuDirection:MenuDirection = MenuDirection.middleMenu
    
    var mainContentView:UIView?
    var leftSideView:UIView?
    var rightSideView:UIView?
    var blackCoverView:UIView?
    
    var rootViewController:UIViewController?{
        willSet{
            if (newValue != nil) {
                rootViewController?.removeFromParentViewController()
                rootViewController?.view.removeFromSuperview();
            }
        }
        didSet{
            if (rootViewController != nil){
                self.addChildViewController(rootViewController!)
                var frame:CGRect = CGRectZero
                var transform:CGAffineTransform  = CGAffineTransformIdentity
                frame = self.view.bounds;
                mainContentView!.addSubview(rootViewController!.view)
                mainContentView!.sendSubviewToBack(rootViewController!.view)
                rootViewController!.view.transform =  transform
                rootViewController!.view.frame = frame
                if (leftViewController?.view.subviews != nil)  {
                    self.showShadow(showBoundsShadow)
                    
                }else if (rightViewController?.view.subviews != nil)  {
                    
                    self.showShadow(showBoundsShadow)
                }
                
            }
        }
    }
    
    var leftViewController:UIViewController?{
        willSet{
            if (newValue) != nil {
                
                leftViewController?.removeFromParentViewController()
                leftViewController?.view.removeFromSuperview();
            }
            
        }
        didSet{
            if (leftViewController != nil){
                self.addChildViewController(leftViewController!)
                leftViewController!.view.frame = CGRectMake(0, 0, leftViewController!.view.frame.size.width,  leftViewController!.view.frame.size.height)
                leftSideView!.addSubview(leftViewController!.view)
            }
        }
    }
    
    var rightViewController:UIViewController?{
        willSet{
            if (newValue != nil) {
                rightViewController?.removeFromParentViewController()
                rightViewController?.view.removeFromSuperview();
            }
        }
        didSet{
            if (rightViewController != nil){
                self.addChildViewController(rightViewController!)
                rightViewController!.view.frame = CGRectMake(0, 0, rightViewController!.view.frame.size.width,  rightViewController!.view.frame.size.height)
                rightSideView!.addSubview(rightViewController!.view)
            }
        }
    }
    
    func showShadow(show: Bool)
    {
        mainContentView!.layer.shadowOpacity = show ? 0.8 : 0.0
        if show {
            mainContentView!.layer.cornerRadius = 0.4
            mainContentView!.layer.cornerRadius = 0.4
            mainContentView!.layer.shadowOffset = CGSizeZero;
            mainContentView!.layer.shadowRadius = 4.0;
            mainContentView!.layer.shadowPath = UIBezierPath(rect: mainContentView!.bounds).CGPath
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initSubviews()
        
        //滑动手势
        movePan = UIPanGestureRecognizer(target: self, action: "moveViewWithGesture:")
        movePan!.delegate  = self
        mainContentView!.addGestureRecognizer(movePan!)
        
        
        
        blackTapPan = UITapGestureRecognizer(target: self, action: "handleSingleFingerEvent:")
        blackTapPan!.numberOfTouchesRequired = 1; //手指数
        blackTapPan!.numberOfTapsRequired = 1; //tap次数
        blackTapPan!.delegate = self
        blackCoverView!.addGestureRecognizer(blackTapPan!)
        blackTapPan!.enabled = false
        
        
        blackCoverPan = UIPanGestureRecognizer(target: self, action: "blackCoverGesture:")
        blackCoverPan!.delegate  = self
        blackCoverView!.addGestureRecognizer(blackCoverPan!)
        blackCoverPan!.enabled = false
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSubviews(){
        leftSideView = UIView(frame: self.view.bounds)
        self.view.addSubview(leftSideView!)
        rightSideView = UIView(frame: self.view.bounds)
        self.view.addSubview(rightSideView!)
        mainContentView = UIView(frame: self.view.bounds)
        self.view.addSubview(mainContentView!)
        blackCoverView = UIView(frame: self.view.bounds)
        mainContentView!.addSubview(blackCoverView!)
        blackCoverView!.backgroundColor = UIColor.blackColor()
        blackCoverView!.alpha = 0
        blackCoverView!.hidden = true
    }
    
    func willShowLeftViewController(){
        rightSideView!.hidden = true
        leftSideView!.hidden = false
        self.view.sendSubviewToBack(rightSideView!)
        
        blackCoverView!.hidden = false
    }
    
    func willShowRightViewController(){
        
        rightSideView!.hidden = false
        leftSideView!.hidden = true
        self.view.sendSubviewToBack(leftSideView!)
        blackCoverView!.hidden = false
    }
    
    
    func handleSingleFingerEvent(sender:UITapGestureRecognizer ){
        self.hideSideViewController(true)
    }
    
    func blackCoverGesture(sender: UIPanGestureRecognizer){
        if blackCoverPan!.state == UIGestureRecognizerState.Began {
            
            
        }else if blackCoverPan!.state == UIGestureRecognizerState.Ended {
            
            
        }
    }
    
    func moveViewWithGesture(sender: UIPanGestureRecognizer)
    {
        if menuDirection != MenuDirection.middleMenu {
            return
        }
        
        
        if isInAnimation {
            return
        }
        
        var velocity:CGPoint=movePan!.velocityInView(self.view)
        
        if ( movePan!.state == UIGestureRecognizerState.Began) {
            startPanPoint = mainContentView!.frame.origin
            if mainContentView!.frame.origin.x == 0 {
                self.showShadow(showBoundsShadow)
            }
        }
        var currentPostion = movePan!.translationInView(self.view)
        var xoffset:CGFloat = startPanPoint.x + currentPostion.x
        if xoffset > 0 {
            if (leftViewController != nil) {
                if !panLeft {
                    panLeft = true
                    self.willShowLeftViewController()
                    panRight = false
                }
                panLeft = true
                self.willShowLeftViewController()
                panRight = false
                if bounces{
                    self.layoutCurrentViewWithOffset(xoffset)
                }else {
                    self.layoutCurrentViewWithOffset(leftViewShowWidth < xoffset ? leftViewShowWidth : xoffset)
                }
                
            }
            
            
        }else if xoffset < 0{
            if (rightViewController != nil) {
                if !panRight {
                    panRight = true
                    self.willShowRightViewController()
                    panLeft = false
                }
                panRight = true
                self.willShowRightViewController()
                panLeft = false
                if bounces {
                    self.layoutCurrentViewWithOffset(xoffset)
                }else{
                    self.layoutCurrentViewWithOffset(rightViewShowWidth < abs(xoffset) ? -rightViewShowWidth : xoffset)
                }
            }
        }
        
        
        if ( movePan!.state == UIGestureRecognizerState.Ended) {
            if mainContentView!.frame.origin.x == 0 {
                self.showShadow(false)
            }else {
                if panMovingRightOrLeft && mainContentView!.frame.origin.x > 20 {
                    self.showLeftViewController(true)
                }else if !panMovingRightOrLeft &&  mainContentView!.frame.origin.x < -20 {
                    self.showRightViewController(true)
                }else {
                    self.hideSideViewController(true)
                }
            }
        }else{
            if velocity.x > 0{
                panMovingRightOrLeft = true
            }else if velocity.x < 0 {
                panMovingRightOrLeft = false
            }
        }
    }
    
    func showLeftViewController(animated:Bool){
        if (leftViewController == nil) {
            return;
        }
        menuDirection = MenuDirection.leftMenu
        self.willShowLeftViewController()
        var animatedTime:NSTimeInterval  = 0
        if (animated) {
            animatedTime = Double(abs(leftViewShowWidth - mainContentView!.frame.origin.x) / leftViewShowWidth * directionAnimationDuration)
            
        }
        blackTapPan!.enabled = true
        blackCoverPan!.enabled = true
        isInAnimation = true
        self.showAnimationEffects(animatedTime, ShowWidth: self.leftViewShowWidth,{  (finish:Bool) -> Void in
            self.isInAnimation = false
        })
    }
    
    func showAnimationEffects(animatedTime:NSTimeInterval,ShowWidth:CGFloat, pletion:(finish:Bool)->Void){
        isInAnimation = true
        var Version:NSString = UIDevice.currentDevice().systemVersion
        if springBack &&   Version.floatValue >= 7.0 &&  ShowWidth != 0{
            UIView.animateWithDuration(animatedTime , delay: 0, usingSpringWithDamping: CGFloat( springBackDuration) , initialSpringVelocity: SpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                self.layoutCurrentViewWithOffset(ShowWidth)
                }, completion:  {
                    (finish:Bool) -> Void in
                    self.isInAnimation = false
                    pletion(finish: finish)
            })
            
        }else {
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.animateWithDuration(animatedTime, animations: {
                self.layoutCurrentViewWithOffset(ShowWidth)
                
                }, completion: {
                    (finish:Bool) -> Void in
                    
                    if  finish{
                        pletion(finish: finish)
                    }
            })
            
        }
        
    }
    
    func showRightViewController(animated:Bool){
        if (rightViewController == nil) {
            return;
        }
        menuDirection = MenuDirection.rightMenu
        self.willShowRightViewController()
        var animatedTime:NSTimeInterval  = 0
        if (animated) {
            animatedTime = Double(abs(rightViewShowWidth + mainContentView!.frame.origin.x) / rightViewShowWidth * directionAnimationDuration)
            
        }
        blackTapPan!.enabled = true
        blackCoverPan!.enabled = true
        isInAnimation = true
        self.showAnimationEffects(animatedTime, ShowWidth: -self.rightViewShowWidth,{  (finish:Bool) -> Void in
            self.isInAnimation = false
        })
    }
    
    
    func hideSideViewController(animated:Bool){
        self.showShadow(false)
        menuDirection = MenuDirection.middleMenu
        var animatedTime:NSTimeInterval  = 0
        if (animated) {
            animatedTime = Double(abs( mainContentView!.frame.origin.x / (mainContentView!.frame.origin.x > 0 ? leftViewShowWidth : rightViewShowWidth ) * backAnimationDuration))
        }
        isInAnimation = true
        self.showAnimationEffects(animatedTime, ShowWidth: 0, pletion: {(finish:Bool) -> Void in
            self.isInAnimation = false
            if finish {
                self.blackCoverView!.hidden = true
                self.blackTapPan!.enabled = false
                self.blackCoverPan!.enabled = false
                self.panLeft = false
                self.panRight = false
                self.rightSideView!.hidden = true
                self.leftSideView!.hidden = true
            }
        })
    }
    
    
    func layoutCurrentViewWithOffset(xoffset:CGFloat){
        
        if  (delegate?.CustomlayoutViewWithOffset? != nil) {
            delegate?.CustomlayoutViewWithOffset?(xoffset,menuController: self)
            return
        }
        self.mainCurrentViewWithOffset(xoffset)
        
    }
    
    func mainCurrentViewWithOffset(xoffset:CGFloat){
        blackCoverView!.alpha = abs(xoffset/leftViewShowWidth) * 0.5
        
        var scale:CGFloat = 0.0
        if xoffset > 0 {
            scale = 1 - abs(xoffset/(leftViewShowWidth-leftSmoothWidth)) * (1-minScale)
        }else if  xoffset < 0 {
            scale = 1 - abs(xoffset/(rightViewShowWidth-rightSmoothWidth)) * (1-minScale)
        }else {
            scale = 1
        }
        scale = max(scale, minScale)
        mainContentView!.transform =  CGAffineTransformScale(CGAffineTransformIdentity,scale,scale)
        var newFrame = CGRectMake(xoffset,  (self.view.frame.size.height - self.view.frame.size.height * scale )/2 , self.view.frame.size.width * scale, self.view.frame.size.height * scale)
        
        println(newFrame)
        if xoffset > 0 {
            newFrame.origin.x  = xoffset
        }else if  xoffset < 0 {
            newFrame.origin.x  = xoffset +  (1.0 - scale) * self.view.frame.size.width
            
        }
        mainContentView!.frame = newFrame
    }
    
}
