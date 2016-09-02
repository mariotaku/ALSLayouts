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
    
    public var rules: [Int] = [Int](count: ALSRelativeLayout.VERB_COUNT, repeatedValue: 0)
    internal var absoluteRules: [Int] = [Int](count: ALSRelativeLayout.VERB_COUNT, repeatedValue: 0)
    
    public var marginTop: CGFloat = 0
    public var marginBottom: CGFloat = 0
    public var marginLeft: CGFloat = 0
    public var marginRight: CGFloat = 0
    public var marginLeading: CGFloat = 0
    public var marginTrailng: CGFloat = 0
    
    public var alignParentTop: Bool {
        get { return rules[ALSRelativeLayout.ALIGN_PARENT_TOP] == ALSRelativeLayout.TRUE }
        set { rules[ALSRelativeLayout.ALIGN_PARENT_TOP] = newValue ? ALSRelativeLayout.TRUE : 0 }
    }
    public var alignParentBottom: Bool {
        get { return rules[ALSRelativeLayout.ALIGN_PARENT_BOTTOM] == ALSRelativeLayout.TRUE }
        set { rules[ALSRelativeLayout.ALIGN_PARENT_BOTTOM] = newValue ? ALSRelativeLayout.TRUE : 0 }
    }
    public var alignParentLeft: Bool {
        get { return rules[ALSRelativeLayout.ALIGN_PARENT_LEFT] == ALSRelativeLayout.TRUE }
        set { rules[ALSRelativeLayout.ALIGN_PARENT_LEFT] = newValue ? ALSRelativeLayout.TRUE : 0 }
    }
    public var alignParentRight: Bool {
        get { return rules[ALSRelativeLayout.ALIGN_PARENT_RIGHT] == ALSRelativeLayout.TRUE }
        set { rules[ALSRelativeLayout.ALIGN_PARENT_RIGHT] = newValue ? ALSRelativeLayout.TRUE : 0 }
    }
    public var alignParentLeading: Bool {
        get { return rules[ALSRelativeLayout.ALIGN_PARENT_LEADING] == ALSRelativeLayout.TRUE }
        set { rules[ALSRelativeLayout.ALIGN_PARENT_LEADING] = newValue ? ALSRelativeLayout.TRUE : 0 }
    }
    public var alignParentTrailing: Bool {
        get { return rules[ALSRelativeLayout.ALIGN_PARENT_TRAILING] == ALSRelativeLayout.TRUE }
        set { rules[ALSRelativeLayout.ALIGN_PARENT_TRAILING] = newValue ? ALSRelativeLayout.TRUE : 0 }
    }
    
    public var alignTopTag: String? = nil
    public var alignBottomTag: String? = nil
    public var alignLeftTag: String? = nil
    public var alignRightTag: String? = nil
    public var alignLeadingTag: String? = nil
    public var alignTrailngTag: String? = nil
    public var alignBaselineTag: String? = nil
    public var aboveTag: String? = nil
    public var belowTag: String? = nil
    public var toLeftOfTag: String? = nil
    public var toRightOfTag: String? = nil
    public var toLeadingOfTag: String? = nil
    public var toTrailingOfTag: String? = nil
    
    public var alignTop: Int {
        get { return rules[ALSRelativeLayout.ALIGN_TOP] }
        set { rules[ALSRelativeLayout.ALIGN_TOP] = newValue }
    }
    public var alignBottom: Int {
        get { return rules[ALSRelativeLayout.ALIGN_BOTTOM] }
        set { rules[ALSRelativeLayout.ALIGN_BOTTOM] = newValue }
    }
    public var alignLeft: Int {
        get { return rules[ALSRelativeLayout.ALIGN_LEFT] }
        set { rules[ALSRelativeLayout.ALIGN_LEFT] = newValue }
    }
    public var alignRight: Int {
        get { return rules[ALSRelativeLayout.ALIGN_RIGHT] }
        set { rules[ALSRelativeLayout.ALIGN_RIGHT] = newValue }
    }
    public var alignLeading: Int {
        get { return rules[ALSRelativeLayout.ALIGN_LEADING] }
        set { rules[ALSRelativeLayout.ALIGN_LEADING] = newValue }
    }
    public var alignTrailng: Int {
        get { return rules[ALSRelativeLayout.ALIGN_TRAILING] }
        set { rules[ALSRelativeLayout.ALIGN_TRAILING] = newValue }
    }
    public var alignBaseline: Int {
        get { return rules[ALSRelativeLayout.ALIGN_BASELINE] }
        set { rules[ALSRelativeLayout.ALIGN_BASELINE] = newValue }
    }
    
    public var above: Int {
        get { return rules[ALSRelativeLayout.ABOVE] }
        set { rules[ALSRelativeLayout.ABOVE] = newValue }
    }
    public var below: Int {
        get { return rules[ALSRelativeLayout.BELOW] }
        set { rules[ALSRelativeLayout.BELOW] = newValue }
    }
    public var toLeftOf: Int {
        get { return rules[ALSRelativeLayout.LEFT_OF] }
        set { rules[ALSRelativeLayout.LEFT_OF] = newValue }
    }
    public var toRightOf: Int {
        get { return rules[ALSRelativeLayout.RIGHT_OF] }
        set { rules[ALSRelativeLayout.RIGHT_OF] = newValue }
    }
    public var toLeadingOf: Int {
        get { return rules[ALSRelativeLayout.LEADING_OF] }
        set { rules[ALSRelativeLayout.LEADING_OF] = newValue }
    }
    public var toTrailingOf: Int {
        get { return rules[ALSRelativeLayout.TRAILING_OF] }
        set { rules[ALSRelativeLayout.TRAILING_OF] = newValue }
    }
    
    public var alignWithParentIfMissing: Bool = false
    
    public var centerInParent: Bool {
        get { return rules[ALSRelativeLayout.CENTER_IN_PARENT] == ALSRelativeLayout.TRUE }
        set { rules[ALSRelativeLayout.CENTER_IN_PARENT] = newValue ? ALSRelativeLayout.TRUE : 0 }
    }
    public var centerVertical: Bool {
        get { return rules[ALSRelativeLayout.CENTER_VERTICAL] == ALSRelativeLayout.TRUE }
        set { rules[ALSRelativeLayout.CENTER_VERTICAL] = newValue ? ALSRelativeLayout.TRUE : 0 }
    }
    public var centerHorizontal: Bool {
        get { return rules[ALSRelativeLayout.CENTER_HORIZONTAL] == ALSRelativeLayout.TRUE }
        set { rules[ALSRelativeLayout.CENTER_HORIZONTAL] = newValue ? ALSRelativeLayout.TRUE : 0 }
    }
    
    internal var left: CGFloat = 0
    internal var top: CGFloat = 0
    internal var right: CGFloat = 0
    internal var bottom: CGFloat = 0
    
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
    
    func resolveViewTags() {
        alignTop = UIView.getTag(byStringTag: alignTopTag)
        alignBottom = UIView.getTag(byStringTag: alignBottomTag)
        alignLeft = UIView.getTag(byStringTag: alignLeftTag)
        alignRight = UIView.getTag(byStringTag: alignRightTag)
        alignLeading = UIView.getTag(byStringTag: alignLeadingTag)
        alignTrailng = UIView.getTag(byStringTag: alignTrailngTag)
        alignBaseline = UIView.getTag(byStringTag: alignBaselineTag)
        above = UIView.getTag(byStringTag: aboveTag)
        below = UIView.getTag(byStringTag: belowTag)
        toLeftOf = UIView.getTag(byStringTag: toLeftOfTag)
        toRightOf = UIView.getTag(byStringTag: toRightOfTag)
        toLeftOf = UIView.getTag(byStringTag: toLeftOfTag)
        toLeadingOf = UIView.getTag(byStringTag: toLeadingOfTag)
    }
    
    public enum SizeMode: String {
        case StaticSize, WrapContent, MatchParent
    }
}