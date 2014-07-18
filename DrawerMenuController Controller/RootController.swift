//
//  DrawerMenuExplain.swift
//  DrawerMenuController Controller
//
//  Created by SunSet on 14-7-18.
//  Copyright (c) 2014年 zhaokaiyuan. All rights reserved.
// qq 623046455 邮箱 zhaokaiyuan99@163.com




import UIKit 

class RootViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "TableViewCellIdentifier")
        
        
        // tas.assaf()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        if indexPath.row == 0 {
 
            var rootController =  MainViewController(nibName:nil,  bundle: nil)
            rootController.view.backgroundColor = UIColor.whiteColor()
             var leftViewController = FirstViewController()
            leftViewController.view.backgroundColor = UIColor.brownColor()
            var rightViewController = SecondViewController()
             rightViewController.view.backgroundColor = UIColor.purpleColor()
            
            
            var drawerMenuController:DrawerMenuController = DrawerMenuController()
            drawerMenuController.rootViewController = rootController
            drawerMenuController.leftViewController = leftViewController
            drawerMenuController.rightViewController = rightViewController
            drawerMenuController.needSwipeShowMenu = true
            (UIApplication.sharedApplication().delegate as AppDelegate).menuController = drawerMenuController
            UIApplication.sharedApplication().delegate.window!.rootViewController = drawerMenuController
            
 
            
        }else if indexPath.row == 1{
            var rootController =  MainViewController(nibName:nil,  bundle: nil)
            rootController.view.backgroundColor = UIColor.whiteColor()
            var leftViewController = FirstViewController()
            leftViewController.view.backgroundColor = UIColor.brownColor()
            var rightViewController = SecondViewController()
            rightViewController.view.backgroundColor = UIColor.purpleColor()
            var drawerMenuController:DrawerMenuController = DrawerMenuController()
            drawerMenuController.rootViewController = rootController
            drawerMenuController.leftViewController = leftViewController
            drawerMenuController.rightViewController = rightViewController
            drawerMenuController.needSwipeShowMenu = true
            drawerMenuController.delegate = rootController
              (UIApplication.sharedApplication().delegate as AppDelegate).menuController = drawerMenuController
            UIApplication.sharedApplication().delegate.window!.rootViewController = drawerMenuController
            
        }else if indexPath.row == 2{
            var rootController =  MainViewController(nibName:nil,  bundle: nil)
            rootController.view.backgroundColor = UIColor.whiteColor()
            var leftViewController = FirstViewController()
            leftViewController.view.backgroundColor = UIColor.brownColor()
            var rightViewController = SecondViewController()
            rightViewController.view.backgroundColor = UIColor.purpleColor()
            var drawerMenuController:CustomMenuController = CustomMenuController()
            drawerMenuController.rootViewController = rootController
            drawerMenuController.leftViewController = leftViewController
            drawerMenuController.rightViewController = rightViewController
            drawerMenuController.needSwipeShowMenu = true
            drawerMenuController.delegate = rootController
            (UIApplication.sharedApplication().delegate as AppDelegate).menuController = drawerMenuController
            UIApplication.sharedApplication().delegate.window!.rootViewController = drawerMenuController
            
        }
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if cell == nil { // no value
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell") as UITableViewCell
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            var label = UILabel()
            label.frame = CGRectMake(0, 0, 320, 36)
            label.font = UIFont.boldSystemFontOfSize(13)
            label.textColor = UIColor.blackColor()
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = NSTextAlignment.Center
            cell!.contentView.addSubview(label)
            label.tag = 1000001
        }
        var label:UILabel = cell!.contentView.viewWithTag(1000001) as  UILabel
        
        if indexPath.row == 0 {
            label.text = "DrawerMenuController"
        }else if indexPath.row == 1{
            label.text = "CustomMenuController"
        } else if indexPath.row == 2{
            label.text = "DrawerMenuController+自定义"
        }else {
            label.text = "DrawerMenuExplain.swift 说明"
         
        }
        return cell!
    }
    
    
    
}
