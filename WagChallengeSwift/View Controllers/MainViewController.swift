//
//  ViewController.swift
//  WagChallengeSwift
//
//  Created by Jaden Nation on 10/13/17.
//  Copyright © 2017 Designer Jeans. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - properties
    
    // MARK: - methods
    override func viewDidLoad() {
        super.viewDidLoad()
        UserTableViewDataSource.sharedInstance.adopt(tableView: tableView)
    }
}

