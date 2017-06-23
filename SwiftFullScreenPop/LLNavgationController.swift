//
//  LLNavgationController.swift
//  SwiftFullScreenPop
//
//  Created by QFWangLP on 2017/6/21.
//  Copyright © 2017年 leefenghy. All rights reserved.
//

import UIKit

class LLNavgationController: UINavigationController,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UINavigationController.swizzle()
        self.delegate = self as UINavigationControllerDelegate
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        // 自定义back按钮
        if viewControllers.count > 1 {
            let image:UIImage = (UIImage(named:"backItem")?.withRenderingMode(.alwaysOriginal))!
            viewController.navigationItem.leftBarButtonItem =
                UIBarButtonItem(image: image,
                                style: .plain, target: self, action: #selector(self.back))
        }
    }
    // back按钮返回的事件
    func back() {
        popViewController(animated: false)
    }

 
}
