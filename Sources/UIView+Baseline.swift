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
        switch self {
        case is UILabel:
            if let font = (self as! UILabel).font {
                return font.ascender
            }
        case is UITextView:
            if let font = (self as! UITextView).font {
                return font.ascender
            }
        case is UITextField:
            if let font = (self as! UITextField).font {
                return font.ascender
            }
        case is ALSBaselineSupport:
            return (self as! ALSBaselineSupport).calculateBaselineBottomValue()
        default: break
        }
        return CGFloat.nan
    }
    
}
