//
//  ALSBaselineSupport.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/8.
//
//

import Foundation

/**
 Protocol for custom views calculating baseline value like Android does
 */
public protocol ALSBaselineSupport {
    
    /**
     Return the offset of the widget's text baseline from the widget's top
     boundary. If this widget does not support baseline alignment, this
     function returns `NaN`.
     
     Hint: for UILabel, this implementation returns `font.ascender`
     
     - returns: the offset of the baseline within the widget's bounds or `NaN`
     if baseline alignment is not supported
     */
    func calculateBaselineBottomValue() -> CGFloat
    
}