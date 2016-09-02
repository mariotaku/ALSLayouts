//
//  ALSLayoutParams.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/1.
//
//

import Foundation

public class ALSLayoutParams {
    
    public var gravity: Int = ALSGravity.NO_GRAVITY
    
    public var marginTop: CGFloat = 0
    public var marginBottom: CGFloat = 0
    public var marginLeft: CGFloat = 0
    public var marginRight: CGFloat = 0
    public var marginLeading: CGFloat = 0
    public var marginTrailng: CGFloat = 0
    
    public var alignParentTop: Bool = false
    public var alignParentBottom: Bool = false
    public var alignParentLeading: Bool = false
    public var alignParentTrailng: Bool = false
    
    public var widthMode: SizeMode = .StaticSize
    public var heightMode: SizeMode = .StaticSize
    
    func resolveMarginLeftAbsolute(layoutDirection: UIUserInterfaceLayoutDirection) -> CGFloat {
        if (marginLeft != 0) {
            return marginLeft
        } else if (layoutDirection == .RightToLeft) {
            return marginTrailng
        } else {
            return marginLeading
        }
    }
    
    func resolveMarginRightAbsolute(layoutDirection: UIUserInterfaceLayoutDirection) -> CGFloat {
        if (marginRight != 0) {
            return marginRight
        } else if (layoutDirection == .RightToLeft) {
            return marginLeading
        } else {
            return marginTrailng
        }
    }
    
    public enum SizeMode: String {
        case StaticSize, WrapContent, MatchParent
    }
}