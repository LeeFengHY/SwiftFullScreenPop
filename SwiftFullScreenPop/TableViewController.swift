//
//  TableViewController.swift
//  SwiftFullScreenPop
//
//  Created by QFWangLP on 2017/6/21.
//  Copyright © 2017年 leefenghy. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }



    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let one = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")!
        let two = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if indexPath.row == 0 {
            one.textLabel?.text = "show navgationBar"
            return one
        }else {
            two.textLabel?.text = "hidden navgationBar"
            return two
        }

    }
}
