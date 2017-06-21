//
//  SecondViewController.swift
//  SwiftFullScreenPop
//
//  Created by QFWangLP on 2017/6/21.
//  Copyright © 2017年 leefenghy. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        isInteractivePopDisable = true
        title = "Second"
        view.backgroundColor = UIColor.blue
        self.navigationController?.interactivePopGestureRecognizer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

