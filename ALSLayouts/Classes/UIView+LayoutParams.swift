//
//  UIView+LayoutParams.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/1.
//
//

import Foundation

public extension UIView {
    
    // Size modes
    
    @IBInspectable internal var layoutWidthMode: String {
        get { return self.layoutParams?.widthMode.rawValue ?? ALSLayoutParams.SizeMode.StaticSize.rawValue }
        set { obtainLayoutParams().heightMode = ALSLayoutParams.SizeMode(rawValue: newValue)! }
    }
    
    @IBInspectable internal var layoutHeightMode: String {
        get { return self.layoutParams?.heightMode.rawValue ?? ALSLayoutParams.SizeMode.StaticSize.rawValue }
        set { obtainLayoutParams().heightMode = ALSLayoutParams.SizeMode(rawValue: newValue)! }
    }
    
    // Layout visibility
    
    @IBInspectable internal var layoutHidden: Bool {
        get { return self.layoutParams?.hidden ?? false }
        set { obtainLayoutParams().hidden = newValue }
    }
    
    // Layout gravity
    
    @IBInspectable internal var layoutGravity: String {
        get {
            return ALSGravity.format(self.layoutParams?.gravity ?? 0)
        }
        set {
            obtainLayoutParams().gravity = ALSGravity.parse(newValue)
        }
    }
    
    // Layout Margins
    
    @IBInspectable internal var layoutMarginTop: CGFloat {
        get { return self.layoutParams?.marginTop ?? 0 }
        set { obtainLayoutParams().marginTop = newValue }
    }
    
    @IBInspectable internal var layoutMarginBottom: CGFloat {
        get { return self.layoutParams?.marginBottom ?? 0 }
        set { obtainLayoutParams().marginBottom = newValue }
    }
    
    @IBInspectable internal var layoutMarginLeft: CGFloat {
        get { return self.layoutParams?.marginLeft ?? 0 }
        set { obtainLayoutParams().marginLeft = newValue }
    }
    
    @IBInspectable internal var layoutMarginRight: CGFloat {
        get { return self.layoutParams?.marginRight ?? 0 }
        set { obtainLayoutParams().marginRight = newValue }
    }
    
    @IBInspectable internal var layoutMarginLeading: CGFloat {
        get { return self.layoutParams?.marginLeading ?? 0 }
        set { obtainLayoutParams().marginLeading = newValue }
    }
    
    @IBInspectable internal var layoutMarginTrailing: CGFloat {
        get { return self.layoutParams?.marginTrailng ?? 0 }
        set { obtainLayoutParams().marginTrailng = newValue }
    }
    
    // Relative Layout params
    
    @IBInspectable internal var layoutAlignParentTop: Bool {
        get { return self.layoutParams?.alignParentTop ?? false }
        set { obtainLayoutParams().alignParentTop = newValue }
    }
    
    @IBInspectable internal var layoutAlignParentBottom: Bool {
        get { return self.layoutParams?.alignParentBottom ?? false }
        set { obtainLayoutParams().alignParentBottom = newValue }
    }
    
    @IBInspectable internal var layoutAlignParentLeft: Bool {
        get { return self.layoutParams?.alignParentLeft ?? false }
        set { obtainLayoutParams().alignParentRight = newValue }
    }
    
    @IBInspectable internal var layoutAlignParentRight: Bool {
        get { return self.layoutParams?.alignParentRight ?? false }
        set { obtainLayoutParams().alignParentRight = newValue }
    }
    
    @IBInspectable internal var layoutAlignParentLeading: Bool {
        get { return self.layoutParams?.alignParentLeading ?? false }
        set { obtainLayoutParams().alignParentLeading = newValue }
    }
    
    @IBInspectable internal var layoutAlignParentTrailing: Bool {
        get { return self.layoutParams?.alignParentTrailing ?? false }
        set { obtainLayoutParams().alignParentTrailing = newValue }
    }
    
    // Relative alignment
    
    @IBInspectable internal var layoutAlignTop: String? {
        get { return self.layoutParams?.alignTopTag }
        set { obtainLayoutParams().alignTopTag = newValue }
    }
    
    @IBInspectable internal var layoutAlignBottom: String? {
        get { return self.layoutParams?.alignBottomTag }
        set { obtainLayoutParams().alignBottomTag = newValue }
    }
    
    @IBInspectable internal var layoutAlignLeft: String? {
        get { return self.layoutParams?.alignLeftTag }
        set { obtainLayoutParams().alignRightTag = newValue }
    }
    
    @IBInspectable internal var layoutAlignRight: String? {
        get { return self.layoutParams?.alignRightTag }
        set { obtainLayoutParams().alignRightTag = newValue }
    }
    
    @IBInspectable internal var layoutAlignLeading: String? {
        get { return self.layoutParams?.alignLeadingTag }
        set { obtainLayoutParams().alignLeadingTag = newValue }
    }
    
    @IBInspectable internal var layoutAlignTrailing: String? {
        get { return self.layoutParams?.alignTrailngTag }
        set { obtainLayoutParams().alignTrailngTag = newValue }
    }
    
    @IBInspectable internal var layoutAlignBaseline: String? {
        get { return self.layoutParams?.alignBaselineTag }
        set { obtainLayoutParams().alignBaselineTag = newValue }
    }
    
    // Relative position
    
    @IBInspectable internal var layoutAbove: String? {
        get { return self.layoutParams?.aboveTag }
        set { obtainLayoutParams().aboveTag = newValue }
    }
    
    @IBInspectable internal var layoutBelow: String? {
        get { return self.layoutParams?.belowTag }
        set { obtainLayoutParams().belowTag = newValue }
    }
    
    @IBInspectable internal var layoutToLeftOf: String? {
        get { return self.layoutParams?.toLeftOfTag }
        set { obtainLayoutParams().toLeftOfTag = newValue }
    }
    
    @IBInspectable internal var layoutToRightOf: String? {
        get { return self.layoutParams?.toRightOfTag }
        set { obtainLayoutParams().toRightOfTag = newValue }
    }
    
    @IBInspectable internal var layoutToLeadingOf: String? {
        get { return self.layoutParams?.toLeadingOfTag }
        set { obtainLayoutParams().toLeadingOfTag = newValue }
    }
    
    @IBInspectable internal var layoutToTrailingOf: String? {
        get { return self.layoutParams?.toTrailingOfTag }
        set { obtainLayoutParams().toTrailingOfTag = newValue }
    }
    
    @IBInspectable internal var layoutAlignWithParentIfMissing: Bool {
        get { return self.layoutParams?.alignWithParentIfMissing ?? false }
        set { obtainLayoutParams().alignWithParentIfMissing = newValue }
    }
    
    // Centering
    
    @IBInspectable internal var layoutCenterInParent: Bool {
        get { return self.layoutParams?.centerInParent ?? false }
        set { obtainLayoutParams().centerInParent = newValue }
    }
    
    @IBInspectable internal var layoutCenterVertical: Bool {
        get { return self.layoutParams?.centerVertical ?? false }
        set { obtainLayoutParams().centerVertical = newValue }
    }
    
    @IBInspectable internal var layoutCenterHorizontal: Bool {
        get { return self.layoutParams?.centerHorizontal ?? false }
        set { obtainLayoutParams().centerHorizontal = newValue }
    }
    
    
    public var layoutParams: ALSLayoutParams? {
        return (superview as! ALSBaseLayout).getLayoutParams(self)
    }
    
    internal var layoutParamsOrNull: ALSLayoutParams? {
        return (superview as? ALSBaseLayout)?.getLayoutParams(self)
    }
    
    internal func obtainLayoutParams() -> ALSLayoutParams {
        return (superview as! ALSBaseLayout).obtainLayoutParams(self)
    }
    
    
}