//
//  Extensions.swift
//  DRPR Mobile Tech Test
//
//  Created by Daniel Pulgarin R. on 13/08/22.
//

import Foundation
import UIKit

public var favoritePosts = [Int:Bool]()

// MARK: - String
extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}


// MARK: - View
extension UIView {
    func addBottomBorder(color: UIColor, margins: CGFloat = 0, borderLineSize: CGFloat = 0.5) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .height,
                                                multiplier: 1, constant: borderLineSize))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .leading,
                                              multiplier: 1, constant: margins))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .trailing,
                                              multiplier: 1, constant: margins))
    }
}
