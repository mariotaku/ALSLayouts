//
//  ALSLayoutParams.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/1.
//
//

import Foundation

public class ALSLayoutParams {
    
    public var widthMode: SizeMode = .StaticSize
    public var heightMode: SizeMode = .StaticSize
    
    public var hidden: Bool = false
    
    public var gravity: Int = ALSGravity.NO_GRAVITY
    
    public var marginTop: CGFloat = 0
    public var marginBottom: CGFloat = 0
    public var marginLeft: CGFloat = 0
    public var marginRight: CGFloat = 0
    public var marginLeading: CGFloat = 0
    public var marginTrailng: CGFloat = 0
    
    public var alignParentTop: Bool = false
    public var alignParentBottom: Bool = false
    public var alignParentLeft: Bool = false
    public var alignParentRight: Bool = false
    public var alignParentLeading: Bool = false
    public var alignParentTrailng: Bool = false
    
    public var alignTop: String? = nil
    public var alignBottom: String? = nil
    public var alignLeft: String? = nil
    public var alignRight: String? = nil
    public var alignLeading: String? = nil
    public var alignTrailng: String? = nil
    public var alignBaseline: String? = nil
    
    public var above: String? = nil
    public var below: String? = nil
    public var toLeftOf: String? = nil
    public var toRightOf: String? = nil
    public var toLeadingOf: String? = nil
    public var toTrailingOf: String? = nil
    
    public var centerInParent: Bool = false
    public var centerVertical: Bool = false
    public var centerHorizontal: Bool = false
    
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