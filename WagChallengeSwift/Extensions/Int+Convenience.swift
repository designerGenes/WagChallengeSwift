//
//  Int+Convenience.swift
//  WagChallengeSwift
//
//  Created by Jaden Nation on 10/13/17.
//  Copyright © 2017 Designer Jeans. All rights reserved.
//

import Foundation

extension Int {
    func withFixedDigitCount(digitCount: Int, cutAfter: Bool = true) -> String {
        var strSelf = "\(self)"
        if cutAfter && strSelf.count > digitCount {
            var nines = ""
            for _ in 0..<digitCount {
                nines += "9"
            }
            strSelf = "+\(nines)"
            return strSelf
        }
        
        while strSelf.count < digitCount {
            strSelf.characters.insert("0", at: strSelf.characters.startIndex)
        }
        
        return strSelf
    }
}
