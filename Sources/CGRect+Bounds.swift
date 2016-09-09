//
//  CGRect+Bounds.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/1.
//
//

import Foundation

internal extension CGRect {
    
    mutating func set(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) {
        self.origin.y = top
        self.origin.x = left
        self.size.height = bottom - top
        self.size.width = right - left
    }
    
    var top: CGFloat {
        get { return origin.y }
        set {
            let diff = newValue - top
            origin.y = newValue
            size.height = size.height - diff
        }
    }
    
    var left: CGFloat {
        get { return origin.x }
        set {
            let diff = newValue - left
            origin.x = newValue
            size.width = size.width - diff
        }
    }
    
    var bottom: CGFloat {
        get { return origin.y + size.height }
        set {
            let diff = newValue - bottom
            size.height = size.height + diff
        }
    }
    
    var right: CGFloat {
        get { return origin.x + size.width }
        set {
            let diff = newValue - right
            size.width = size.width + diff
        }
    }
    
}