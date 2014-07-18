//
//  DrawerMenuExplain.swift
//  DrawerMenuController Controller
//
//  Created by SunSet on 14-7-18.
//  Copyright (c) 2014年 zhaokaiyuan. All rights reserved.
// qq 623046455 邮箱 zhaokaiyuan99@163.com


import UIKit

class MainViewController:UIViewController,DrawerMenuControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var leftBtn:UIButton = UIButton(frame: CGRectMake(20,0, 60, 40))
        leftBtn.addTarget(self, action: "leftItemClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(leftBtn)
        leftBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        leftBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        leftBtn.setTitle("leftBtn", forState: UIControlState.Normal)
        leftBtn.setTitle("leftBtn", forState: UIControlState.Highlighted)
        

        var rightBtn:UIButton = UIButton(frame: CGRectMake(self.view.frame.size.width-65,0, 65, 40))
        rightBtn.addTarget(self, action: "rightItemClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(rightBtn)
        rightBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        rightBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        rightBtn.setTitle("rightBtn", forState: UIControlState.Normal)
        rightBtn.setTitle("rightBtn", forState: UIControlState.Highlighted)
        
        
        
        
        var  label:UILabel = UILabel(frame:CGRectMake(60,40, 200, 30))
        label.text = "侧滑菜单"
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(16)
        label.backgroundColor = UIColor.clearColor()
        self.view.addSubview(label)
        
        
        var button:UIButton = UIButton(frame: CGRectMake(60,100, 200, 30))
        button.addTarget(self, action: "back:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        button.setTitle("back  ", forState: UIControlState.Normal)
        button.setTitle("back  ", forState: UIControlState.Highlighted)

        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //DrawerMenuControllerDelegate
    func CustomlayoutViewWithOffset(xoffset: CGFloat, menuController: DrawerMenuController) {
        println(xoffset)
         menuController.mainCurrentViewWithOffset(xoffset)
        if xoffset > 0 {
            menuController.leftSideView!.frame = CGRectMake( ( -menuController.leftSideView!.frame.size.width + xoffset +  xoffset / menuController.leftViewShowWidth * ( menuController.leftSideView!.frame.size.width - xoffset) ) , 0, menuController.leftSideView!.frame.size.width, menuController.leftSideView!.frame.size.height)
            menuController.leftSideView!.alpha = xoffset/menuController.leftViewShowWidth
        }
    }
    
    
    
    func leftItemClick(){
        
        
      (UIApplication.sharedApplication().delegate as AppDelegate).menuController?.showLeftViewController(true)
    
    }
    
    func rightItemClick(){
        (UIApplication.sharedApplication().delegate as AppDelegate).menuController?.showRightViewController(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back(sender:UIButton){
        var mainViewController = RootViewController(nibName:nil,  bundle: nil)
        var navigationViewController = UINavigationController(rootViewController: mainViewController)
        UIApplication.sharedApplication().delegate.window!.rootViewController = navigationViewController
        
    }

    
}