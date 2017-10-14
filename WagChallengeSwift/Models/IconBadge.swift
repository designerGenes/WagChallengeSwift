//
//  IconBadge.swift
//  WagChallengeSwift
//
//  Created by Jaden Nation on 10/14/17.
//  Copyright © 2017 Designer Jeans. All rights reserved.
//

import Foundation
import UIKit

class IconBadge: UIImageView {
    var lore: String?
    init(named name: LocalAssetName, lore: String) {
        super.init(image: UIImage(fromAssetNamed: name))
        self.lore = lore
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
