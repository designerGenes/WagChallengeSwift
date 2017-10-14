//
//  User.swift
//  WagChallengeSwift
//
//  Created by Jaden Nation on 10/13/17.
//  Copyright © 2017 Designer Jeans. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BadgeRecord {
    var bronzeCount: Int
    var silverCount: Int
    var goldCount: Int
    var iconBadges: [IconBadge]
}

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



class User: NSObject {
    // MARK: - properties
    static var averageReputation: Int = 0
    var displayName: String?
    var badgeRecord: BadgeRecord?
    var gravatarURL: URL?
    var reputation: Int?
    
    // MARK: - methods
   
    
    func determineBadges(from json: JSON) -> BadgeRecord {
        var iconBadges = [IconBadge]()
        var bronzeCount = 0
        var silverCount = 0
        var goldCount = 0
        
        if let badgeJSON = json["badge_counts"].dictionary {
            bronzeCount = badgeJSON["bronze"]?.intValue ?? 0
            silverCount = badgeJSON["silver"]?.intValue ?? 0
            goldCount = badgeJSON["gold"]?.intValue ?? 0
        }
        // EMPLOYEE: everybody gets at least this badge
        let isEmployee = json["is_employee"].bool ?? false
        let employmentBadge = isEmployee ? IconBadge(named: .employeeBadge, lore: "an employee") : IconBadge(named: .notEmployeeBadge, lore: "not an employee")
        iconBadges.append(employmentBadge)
        
        // OLD TIMER: user has been around a while
        if let creationDateRaw = json["creation_date"].int {
            let creationDate = Date(timeIntervalSince1970: Double(creationDateRaw))
            let yearsSinceCreation = Int(Date().timeIntervalSince(creationDate) / 60 / 60 / 24 / 365)
            if yearsSinceCreation > 0 {
                let oneYearBadge = IconBadge(named: .overOneYearBadge, lore: "an oldschool user")
                iconBadges.append(oneYearBadge)
                if yearsSinceCreation > 3 {
                    let threeYearBadge = IconBadge(named: .overThreeYearBadge, lore: "a veteran user")
                    iconBadges.append(threeYearBadge)
                }
            }
        }
        if let reputation = json["reputation"].int {
            self.reputation = reputation
            
            if let repChangeYear = json["reputation_change_year"].int, let repChangeQuarter = json["reputation_change_quarter"].int,
            let repChangeMonth = json["reputation_change_month"].int, let repChangeWeek = json["reputation_change_week"].int,
                let repChangeDay = json["reputation_change_day"].int {
                
                // REPUTABLE: user has above average reputation
                if reputation > User.averageReputation {
                    let reputableBadge = IconBadge(named: LocalAssetName.reputableBadge, lore: "a reputable user")
                    iconBadges.append(reputableBadge)
                }
                
                // FAST MOVER: user reputation has moved above average amount this week
                if repChangeWeek * 52 > repChangeYear {
                    let fastMoverBadge = IconBadge(named: .fastMoverBadge, lore: "moving fast!")
                    iconBadges.append(fastMoverBadge)
                }
                
                // RECENT SURGE: user has experienced high amount of reputation change today
                if (repChangeDay > repChangeWeek / 7) {
                    let recentSurgeBadge = IconBadge(named: .recentSurgeBadge, lore: "recently popular")
                    iconBadges.append(recentSurgeBadge)
                }
            }
        }
        return BadgeRecord(bronzeCount: bronzeCount, silverCount: silverCount, goldCount: goldCount, iconBadges: iconBadges)
    }
    
    init(fromJSON json: JSON) {
        super.init()
        displayName = json["display_name"].string ?? "unknown"
        badgeRecord = determineBadges(from: json)
        if let urlString = json["profile_image"].string {
            gravatarURL = URL(string: urlString)
        }
    }
}
