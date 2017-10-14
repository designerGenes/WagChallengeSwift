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
    let contentLoadingLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    // MARK: - methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentLoadingLabel.center = view.center
        activityIndicator.center = view.center.applying(CGAffineTransform(translationX: 0, y: 32))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 2,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [.autoreverse, .repeat], animations: {
                            self.contentLoadingLabel.alpha = 1
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserTableViewDataSource.sharedInstance.adopt(tableView: tableView)
        let backingView = UIView()
        backingView.backgroundColor = UIColor.named(.gray_0)
        tableView.backgroundView = backingView
        tableView.isHidden = true
        view.insertSubview(contentLoadingLabel, belowSubview: tableView)
        contentLoadingLabel.attributedText = NSAttributedString(string: "Loading", attributes: [
            NSAttributedStringKey.font: UIFont(name: "SanFranciscoDisplay-Bold", size: 26),
            NSAttributedStringKey.kern: 2,
            NSAttributedStringKey.foregroundColor: UIColor.white
            ])
        contentLoadingLabel.sizeToFit()
        contentLoadingLabel.alpha = 0
        view.insertSubview(activityIndicator, belowSubview: tableView)
        activityIndicator.startAnimating()
    }
}

