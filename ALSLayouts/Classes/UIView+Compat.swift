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
            return UIView.userInterfaceLayoutDirectionForSemanticContentAttribute(self.semanticContentAttribute)
        } else {
            if let preferredLang = NSLocale.preferredLanguages().first {
                return (NSLocale.characterDirectionForLanguage(preferredLang) == .RightToLeft) ? .RightToLeft : .LeftToRight
            }
            return .LeftToRight
        }
    }
    
    var compatLayoutMargins: UIEdgeInsets {
        if #available(iOS 8.0, *) {
            return self.layoutMargins
        } else {
            return UIEdgeInsetsZero
        }
    }
    
}