//
//  UIView+Convenience.swift
//  WagChallengeSwift
//
//  Created by Jaden Nation on 10/13/17.
//  Copyright © 2017 Designer Jeans. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func coverSelfEntirely(with subview: UIView, useAsOverlay: Bool = false, withInset percentInset: CGPoint = CGPoint.zero) {
        let xInset = frame.width * percentInset.x
        let yInset = frame.height * percentInset.y
        
        if useAsOverlay {
            if let superview = superview {
                if !superview.subviews.contains(subview) {
                    superview.addSubview(subview)
                }
            }
        } else {
            if !subviews.contains(subview) {
                addSubview(subview)
            }
        }
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        subview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        subview.widthAnchor.constraint(equalTo: widthAnchor, constant: -xInset).isActive = true
        subview.heightAnchor.constraint(equalTo: heightAnchor, constant: -yInset).isActive = true
        layoutIfNeeded()
    }
}
