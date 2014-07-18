//
//  DrawerMenuExplain.swift
//  DrawerMenuController Controller
//
//  Created by SunSet on 14-7-18.
//  Copyright (c) 2014年 zhaokaiyuan. All rights reserved.
// qq 623046455 邮箱 zhaokaiyuan99@163.com



import UIKit

class FirstViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        var image:UIImageView = UIImageView(image: UIImage(named: "1.png"))
        self.view.addSubview(image)
        image.frame = self.view.frame
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

