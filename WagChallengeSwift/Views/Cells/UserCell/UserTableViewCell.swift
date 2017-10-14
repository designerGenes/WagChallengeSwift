//
//  UserTableViewCell.swift
//  WagChallengeSwift
//
//  Created by Jaden Nation on 10/13/17.
//  Copyright © 2017 Designer Jeans. All rights reserved.
//

import UIKit
import Foundation
import AlamofireImage

class UserTableViewCell: UITableViewCell {
    // MARK: - outlets
    
    @IBOutlet weak var imageViewShell: UIView!
    @IBOutlet weak var gravatarImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var badgeCountLabel: UILabel!
    
    
    // MARK: - properties
    private var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    private var imageFrameView = UIView()
    private var iconBadges = [IconBadge]()
    private var iconBadgeTapAreas = [UIControl]()
    private var badgeCountTapArea: UIControl?
    private var displayName: NSAttributedString?
    private var badgeCountText: NSAttributedString?
    private var gravatarImage: UIImage?
    private var gravatarImageBackingView: UIView?
    
    private func sfDisplayBold(size: CGFloat) -> UIFont {
        return UIFont(name: "SanFranciscoDisplay-Bold", size: size)!
    }
    
    // MARK: - RemoteDataDelegate methods
    func didFinishDownloading(image: UIImage, in controller: RemoteDataController) {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - methods
    @objc func touchedDownOnBadgeCount(control: UIControl) {
        displayNameLabel.attributedText = makeBadgeCountText(goldStr: "GOLD", silvStr: "SLVR", brnzStr: "BRNZ", size: 24)
    }
    
    @objc func touchedDownOnBadge(control: UIControl) {
        guard control.tag < iconBadges.count else {
            return
        }
        for (z, badge) in iconBadges.enumerated() {
            if z != control.tag {
                badge.alpha = 0.2
            }
        }
        let iconBadge = iconBadges[control.tag]
        iconBadge.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
        revealDescriptionForBadge(badge: iconBadge)
        gravatarImageView.image = iconBadge.image
    }
    
    func revealDescriptionForBadge(badge: IconBadge) {
        displayNameLabel.attributedText = NSAttributedString(string: badge.lore ?? "unknown", attributes: [
            .font : sfDisplayBold(size: 24),
            .kern : 2,
            .foregroundColor: UIColor.white
            ])
    }
    
    @objc func hideDescriptionText() {
        for badge in iconBadges {
            badge.alpha = 1
            badge.transform = CGAffineTransform.identity
        }
        badgeCountLabel.attributedText = badgeCountText
        displayNameLabel.attributedText = displayName
        gravatarImageView.image = gravatarImage
    }
    
    
    func layoutIconBadges(for user: User) {
        if let iconBadges = user.badgeRecord?.iconBadges {
            self.iconBadges = iconBadges
            for (z, iconBadge) in iconBadges.enumerated() {
                contentView.addSubview(iconBadge)
                
                iconBadge.translatesAutoresizingMaskIntoConstraints = false
                iconBadge.heightAnchor.constraint(equalToConstant: 32).isActive = true
                iconBadge.widthAnchor.constraint(equalTo: iconBadge.heightAnchor).isActive = true
                iconBadge.topAnchor.constraint(equalTo: badgeCountLabel.bottomAnchor, constant: 0).isActive = true
                let leftAnchorView = z > 0 ? iconBadges[z-1].rightAnchor : badgeCountLabel.leftAnchor
                let leftMargin: CGFloat = 8 //= z > 0 ?  8 : 8
                iconBadge.leftAnchor.constraint(equalTo: leftAnchorView, constant: leftMargin).isActive = true
                
                let tapInterceptArea = UIControl()
                iconBadgeTapAreas.append(tapInterceptArea)
                contentView.insertSubview(tapInterceptArea, aboveSubview: iconBadge)
                tapInterceptArea.translatesAutoresizingMaskIntoConstraints = false
                tapInterceptArea.widthAnchor.constraint(equalTo: iconBadge.widthAnchor).isActive = true
                tapInterceptArea.heightAnchor.constraint(equalTo: iconBadge.heightAnchor).isActive = true
                tapInterceptArea.centerXAnchor.constraint(equalTo: iconBadge.centerXAnchor).isActive = true
                tapInterceptArea.centerYAnchor.constraint(equalTo: iconBadge.centerYAnchor).isActive = true

                tapInterceptArea.tag = z
                
                tapInterceptArea.addTarget(self, action: #selector(touchedDownOnBadge(control:)), for: .touchDown)
                tapInterceptArea.addTarget(self, action: #selector(hideDescriptionText), for: [.touchUpInside, .touchDragOutside, .touchCancel])

            }
        }
        
    }

    private func makeBadgeCountText(goldStr: String, silvStr: String, brnzStr: String, size: CGFloat = 22) -> NSAttributedString {
        var badgeCountAttributedString = NSMutableAttributedString(string: "")
        
        let colors = [DesignColor.gold, .silver, .bronze].map({UIColor.named($0)})
        for (z, badgeCountRaw) in [goldStr, silvStr, brnzStr].enumerated() {
            var badgeCountRaw = badgeCountRaw
            if let numericForm = Int(badgeCountRaw) {
                badgeCountRaw = numericForm.withFixedDigitCount(digitCount: 4)
            }
            
            let attributes: [NSAttributedStringKey: Any] = [
                .font : sfDisplayBold(size: size),
                .kern : 1.5,
                .foregroundColor: colors[z]
            ]
            
            let badgeCountColored = NSAttributedString(string: "\(badgeCountRaw) ", attributes: attributes)
            badgeCountAttributedString.append(badgeCountColored)
        }
        
        
        return badgeCountAttributedString
    }
    
    func drawBadgeCountText(for user: User) {
        if let badgeRecord = user.badgeRecord {
            self.badgeCountText = makeBadgeCountText(goldStr: String(badgeRecord.goldCount), silvStr: String(badgeRecord.silverCount), brnzStr: String(badgeRecord.bronzeCount))
            badgeCountLabel.attributedText = self.badgeCountText
        }
        badgeCountTapArea = UIControl()
        contentView.addSubview(badgeCountTapArea!)
    
        badgeCountTapArea?.translatesAutoresizingMaskIntoConstraints = false
        badgeCountTapArea?.centerXAnchor.constraint(equalTo: badgeCountLabel.centerXAnchor).isActive = true
        badgeCountTapArea?.centerYAnchor.constraint(equalTo: badgeCountLabel.centerYAnchor).isActive = true
        badgeCountTapArea?.heightAnchor.constraint(equalTo: badgeCountLabel.heightAnchor).isActive = true
        badgeCountTapArea?.widthAnchor.constraint(equalTo: badgeCountLabel.widthAnchor).isActive = true
        badgeCountTapArea?.addTarget(self, action: #selector(touchedDownOnBadgeCount(control:)), for: .touchDown)
        badgeCountTapArea?.addTarget(self, action: #selector(hideDescriptionText), for: [.touchUpInside, .touchDragOutside, .touchCancel])
        layoutSubviews()
    }
    
    func downloadGravatar(from url: URL) {
        self.gravatarImageView.image = nil
        self.activityIndicator.startAnimating()
        RemoteDataController.sharedInstance.downloadImage(at: url) { img in
            if let img = img {
                let img = img.af_imageRoundedIntoCircle()
                DispatchQueue.main.async {
                    self.gravatarImageView.image = img
                    self.gravatarImage = img
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    override func layoutSubviews() {
        activityIndicator.center = gravatarImageView.center
    }
    
    override func prepareForReuse() {
        for iconBadge in iconBadges {
            iconBadge.removeFromSuperview()
        }
        
        gravatarImageView.image = nil
        for tapArea in iconBadgeTapAreas {
            tapArea.removeFromSuperview()
        }
        
        badgeCountTapArea?.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewShell.backgroundColor = UIColor.clear
        
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)

        insertSubview(imageFrameView, belowSubview: gravatarImageView)
        imageFrameView.backgroundColor = UIColor.named(.gray_1)
        imageFrameView.translatesAutoresizingMaskIntoConstraints = false
        imageFrameView.centerXAnchor.constraint(equalTo: gravatarImageView.centerXAnchor).isActive = true
        imageFrameView.centerYAnchor.constraint(equalTo: gravatarImageView.centerYAnchor).isActive = true
        
        let gravatarImageBackingView = UIView()
        self.gravatarImageBackingView = gravatarImageBackingView
        gravatarImageView.superview?.insertSubview(gravatarImageBackingView, belowSubview: gravatarImageView)
        gravatarImageBackingView.translatesAutoresizingMaskIntoConstraints = false
        gravatarImageBackingView.widthAnchor.constraint(equalTo: gravatarImageView.widthAnchor).isActive = true
        gravatarImageBackingView.heightAnchor.constraint(equalTo: gravatarImageView.heightAnchor).isActive = true
        gravatarImageBackingView.centerYAnchor.constraint(equalTo: gravatarImageView.centerYAnchor).isActive = true
        gravatarImageBackingView.centerXAnchor.constraint(equalTo: gravatarImageView.centerXAnchor).isActive = true
        gravatarImageBackingView.backgroundColor = UIColor.black
        gravatarImageBackingView.layer.cornerRadius = gravatarImageView.frame.width / 2
        gravatarImageBackingView.layer.masksToBounds = true
    }
    
    func adopt(user: User) {
        self.displayName = NSAttributedString(string: user.displayName ?? "unknown", attributes: [
            .font : sfDisplayBold(size: 22),
            .kern : 2,
            .foregroundColor: UIColor.white
            ])
        displayNameLabel.attributedText = displayName
        
        drawBadgeCountText(for: user)
        layoutIconBadges(for: user)
        if let gravatarURL = user.gravatarURL {
            downloadGravatar(from: gravatarURL)
        }
        
        
    }
}
