
//
//  UserTableViewDataSource.swift
//  WagChallengeSwift
//
//  Created by Jaden Nation on 10/13/17.
//  Copyright © 2017 Designer Jeans. All rights reserved.
//

import Foundation
import Cache
import Alamofire
import SwiftyJSON
import UIKit

class UserTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, RemoteDataDelegate, UIScrollViewDelegate {
    // MARK: - properties
    var userArr = [User]()
    static var sharedInstance = UserTableViewDataSource()
    static var cellHeight: CGFloat = UIScreen.main.bounds.height / 6
    weak var tableView: UITableView?
    
    // MARK: - RemoteDataDelegate methods
    func didReceiveUserList(list: [User], in controller: RemoteDataController) {
        userArr = list
        tableView?.reloadData()
        tableView?.backgroundView?.backgroundColor = userArr.count % 2 == 0 ? UIColor.named(.gray_0) : UIColor.named(.gray_1)
    }
    
    // MARK: - UITableView methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yVal = scrollView.contentOffset.y
        if yVal < 0 {
            scrollView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserTableViewDataSource.cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < userArr.count, let userCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell {
                userCell.adopt(user: userArr[indexPath.row])
                userCell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.named(.gray_1) : UIColor.named(.gray_0)
                userCell.isUserInteractionEnabled = true
                return userCell
        }
        
        return UITableViewCell()
    }
        
    // MARK: - methods
    func adopt(tableView: UITableView) {
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: .main), forCellReuseIdentifier: "UserTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorColor = .clear
        tableView.separatorStyle = .none
        
        self.tableView = tableView
    }
}
