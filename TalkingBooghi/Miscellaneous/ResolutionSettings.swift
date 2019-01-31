//
//  ResolutionSettings.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 07/10/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    public var screenResolutionType: String {
        switch (UIDevice.current.userInterfaceIdiom, UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width) {
        case (.pad, 1366, 1366):
            return "iPadPro12"
        case (.pad, 1024, 768):
            return "iPad"
        case (.phone, 896, 414):
            return "iPhoneXsMax"
        case (.phone, 812, 375):
            return "iPhoneX"
        case (.phone, 1366, 1366):
            return "iPadPro12"
        case (.phone, 667, 375):
            return "iPhone"
        case (.phone, 736, 414):
            return "iPhonePlus"
        case (.phone, 568, 320):
            return "iPhoneSE"
        default:
            return "default"
        }
    }
}

extension UIView {
    func wiggle() {
        let wiggleAnim = CABasicAnimation(keyPath: "position")
        wiggleAnim.duration = 0.05
        wiggleAnim.repeatCount = Float.infinity
        wiggleAnim.autoreverses = true
        wiggleAnim.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        wiggleAnim.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(wiggleAnim, forKey: "position")
    }
    func rotateWiggle() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = -Double.pi/120
        rotationAnimation.toValue = Double.pi/120 //Minus can be Direction
        rotationAnimation.duration = 0.15
        rotationAnimation.autoreverses = true
        rotationAnimation.repeatCount = .infinity
        layer.add(rotationAnimation, forKey: nil)
    }
}
