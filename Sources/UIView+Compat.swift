//
//  UIView+LayoutDirections.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/2.
//
//

import UIKit

extension UIView {
    
    var layoutDirection: UIUserInterfaceLayoutDirection {
        if #available(iOS 9.0, *) {
            return UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute)
        } else {
            if let preferredLang = Locale.preferredLanguages.first {
                return (Locale.characterDirection(forLanguage: preferredLang) == .rightToLeft) ? .rightToLeft : .leftToRight
            }
            return .leftToRight
        }
    }
    
}
