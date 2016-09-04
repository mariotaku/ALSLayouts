//
//  UIView+Baseline.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/4.
//
//

import Foundation

extension UIView {
    
    var baselineBottomValue: CGFloat {
        if (self is UILabel) {
            let label = self as! UILabel
            if let font = label.font {
//                let scale = UIScreen.mainScreen().scale
                return font.ascender
            }
        }
        return CGFloat.NaN
    }
    
}