//
//  UIImage+Convenience.swift
//  WagChallengeSwift
//
//  Created by Jaden Nation on 10/13/17.
//  Copyright © 2017 Designer Jeans. All rights reserved.
//

import Foundation
import UIKit

enum LocalAssetName: String {
    case employeeBadge, fastMoverBadge, notEmployeeBadge, overOneYearBadge, overThreeYearBadge, recentSurgeBadge, reputableBadge
    
    case gravatarPlaceholder
}

extension UIImage {
    convenience init(fromAssetNamed name: LocalAssetName) {
        self.init(named: name.rawValue)!
    }
}

