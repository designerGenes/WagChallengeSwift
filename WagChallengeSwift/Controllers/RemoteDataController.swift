//
//  RemoteDataController.swift
//  WagChallengeSwift
//
//  Created by Jaden Nation on 10/13/17.
//  Copyright © 2017 Designer Jeans. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import AlamofireImage

protocol RemoteDataDelegate: class {
    func didReceiveUserList(list: [User], in controller: RemoteDataController)
}

class RemoteDataController: NSObject {
    // MARK: - properties
    static var sharedInstance = RemoteDataController()
    private let baseURL = URL(string: "https://api.stackexchange.com/2.2/users?site=stackoverflow")!
    private let bgroundQueue = DispatchQueue(label: "networkBGQueue", qos: .background)
    private var sessionManager: SessionManager?
    private let imageCache = AutoPurgingImageCache()
    var isDownloading: Bool = false
    private var activeDownloaders = [URL: ImageDownloader]()
    
    // MARK: - methods
    func downloadImage(at url: URL, callback: UIImageCallback?) {
        if let sessionManager = sessionManager {
            let urlRequest = URLRequest(url: url)
            if let cachedImg = imageCache.image(for: urlRequest, withIdentifier: url.absoluteString) {
                callback?(cachedImg)
            } else {
                let downloader = ImageDownloader(sessionManager: sessionManager)
                activeDownloaders[url] = downloader
                downloader.download(urlRequest, filter: nil) { res in
                    DispatchQueue.main.async {
                        guard res.error == nil else {
                            print("Error: \(res.error!.localizedDescription)")
                            callback?(nil)
                            return
                        }
                        let img = res.result.value
                        if let img = img {
                            self.imageCache.add(img, for: urlRequest, withIdentifier: url.absoluteString)
                        }
                        callback?(img)
                        self.activeDownloaders[url] = nil
                    }
                }
            }
            
            
           
        }
    }
    
    func updateData(delegate: RemoteDataDelegate?, callback: VoidCallback? = nil) {
        if !isDownloading {
            isDownloading = true
            sessionManager?.request(baseURL).responseJSON(queue: bgroundQueue, options: [], completionHandler: { res in
                self.isDownloading = false
                DispatchQueue.main.async {
                    guard res.error == nil else {
                        print("Error: \(res.error!.localizedDescription)")
                        callback?()
                        return
                    }
                    if let resultValue = res.result.value {
                        let resultJSON = JSON(resultValue)
            
                        if let items = resultJSON["items"].array {
                            print("downloaded \(items.count) JSON user objects ")
                            // get average reputation.  This method is imperfect because
                            // we are only comparing against the current page and would be implemented
                            // differently in a full app
                            let reputationArr = items.filter({$0["reputation"].int != nil}).map({$0["reputation"].intValue})
                            let averageRep = reputationArr.reduce(0, {$0 + $1}) / reputationArr.count
                            User.averageReputation = averageRep
                            print("average User Reputation is \(averageRep)")
                            
                            let userList: [User] = items.map({ User(fromJSON: $0) })
                            print("generated list of \(userList.count) users")
                            delegate?.didReceiveUserList(list: userList, in: self)

                        }
                        
                    }
                }
            })
        }
    }
    
    override init() {
        super.init()
        sessionManager = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 15
            configuration.requestCachePolicy = .returnCacheDataElseLoad
            configuration.urlCache = nil // debug
            return SessionManager(configuration: configuration)
        }()
        
        
        
    }
    
}
