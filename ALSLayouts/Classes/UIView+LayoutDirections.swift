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
        return UIView.userInterfaceLayoutDirectionForSemanticContentAttribute(self.semanticContentAttribute)
    }
    
}