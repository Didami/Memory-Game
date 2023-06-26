//
//  Extensions+Constants.swift
//  Memory Game
//
//  Created by Didami on 26/06/23.
//

import UIKit

import UIKit

// MARK: - UIColor
extension UIColor {
    
    static let mainColor = UIColor(r: 188, g: 204, b: 215)
    static let secondColor = UIColor(r: 69, g: 95, b: 108)
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

// MARK: - Constants
public enum Constants {
    
    static let superViewSpacing: CGFloat = 12
    
    static let standardSpacing: CGFloat = 24
    static let safeSpacing: CGFloat = 12
    
    static let doubleSpacing: CGFloat = 48
    
    static let stackStandardSpacing: CGFloat = 27
    static let stackSafeSpacing: CGFloat = 12
    
    static let cellSpacing: CGFloat = 42
    static let sectionSpacing: CGFloat = 51
    
    static let cornerRadius: CGFloat = 24
    
    static let iconSize: CGFloat = 48
    
    static let mainAnimationDuration: CGFloat = 0.6
}
