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
    
    public var layoutWidthMode: ALSLayoutParams.SizeMode {
        get { return self.layoutParams?.widthMode ?? .StaticSize }
        set { obtainLayoutParams().widthMode = newValue }
    }
    
    internal var layoutHeightMode: ALSLayoutParams.SizeMode {
        get { return self.layoutParams?.heightMode ?? .StaticSize }
        set { obtainLayoutParams().heightMode = newValue }
    }
    
    @IBInspectable internal var layoutWidthModeString: String {
        get { return layoutWidthMode.rawValue }
        set { self.layoutWidthMode = ALSLayoutParams.SizeMode(rawValue: newValue)! }
    }
    
    @IBInspectable internal var layoutHeightModeString: String {
        get { return layoutHeightMode.rawValue }
        set { self.layoutHeightMode = ALSLayoutParams.SizeMode(rawValue: newValue)! }
    }
    
    // Layout visibility
    
    @IBInspectable var layoutHidden: Bool {
        get { return self.layoutParams?.hidden ?? false }
        set { obtainLayoutParams().hidden = newValue }
    }
    
    // Layout gravity
    
    public var layoutGravity: Int {
        get { return self.layoutParams?.gravity ?? 0 }
        set { obtainLayoutParams().gravity = newValue }
    }
    
    @IBInspectable internal var layoutGravityString: String {
        get {
            return ALSGravity.format(layoutGravity)
        }
        set {
            self.layoutGravity = ALSGravity.parse(newValue)
        }
    }
    
    // Layout Margins
    
    @IBInspectable public var layoutMarginTop: CGFloat {
        get { return self.layoutParams?.marginTop ?? 0 }
        set { obtainLayoutParams().marginTop = newValue }
    }
    
    @IBInspectable public var layoutMarginBottom: CGFloat {
        get { return self.layoutParams?.marginBottom ?? 0 }
        set { obtainLayoutParams().marginBottom = newValue }
    }
    
    @IBInspectable public var layoutMarginLeft: CGFloat {
        get { return self.layoutParams?.marginLeft ?? 0 }
        set { obtainLayoutParams().marginLeft = newValue }
    }
    
    @IBInspectable public var layoutMarginRight: CGFloat {
        get { return self.layoutParams?.marginRight ?? 0 }
        set { obtainLayoutParams().marginRight = newValue }
    }
    
    @IBInspectable public var layoutMarginLeading: CGFloat {
        get { return self.layoutParams?.marginLeading ?? 0 }
        set { obtainLayoutParams().marginLeading = newValue }
    }
    
    @IBInspectable public var layoutMarginTrailing: CGFloat {
        get { return self.layoutParams?.marginTrailng ?? 0 }
        set { obtainLayoutParams().marginTrailng = newValue }
    }
    
    // Relative Layout params
    
    @IBInspectable public var layoutAlignParentTop: Bool {
        get { return self.layoutParams?.alignParentTop ?? false }
        set { obtainLayoutParams().alignParentTop = newValue }
    }
    
    @IBInspectable public var layoutAlignParentBottom: Bool {
        get { return self.layoutParams?.alignParentBottom ?? false }
        set { obtainLayoutParams().alignParentBottom = newValue }
    }
    
    @IBInspectable public var layoutAlignParentLeft: Bool {
        get { return self.layoutParams?.alignParentLeft ?? false }
        set { obtainLayoutParams().alignParentRight = newValue }
    }
    
    @IBInspectable public var layoutAlignParentRight: Bool {
        get { return self.layoutParams?.alignParentRight ?? false }
        set { obtainLayoutParams().alignParentRight = newValue }
    }
    
    @IBInspectable public var layoutAlignParentLeading: Bool {
        get { return self.layoutParams?.alignParentLeading ?? false }
        set { obtainLayoutParams().alignParentLeading = newValue }
    }
    
    @IBInspectable public var layoutAlignParentTrailing: Bool {
        get { return self.layoutParams?.alignParentTrailing ?? false }
        set { obtainLayoutParams().alignParentTrailing = newValue }
    }
    
    // Relative alignment
    
    @IBInspectable public var layoutAlignTop: String? {
        get { return self.layoutParams?.alignTopTag }
        set { obtainLayoutParams().alignTopTag = newValue }
    }
    
    @IBInspectable public var layoutAlignBottom: String? {
        get { return self.layoutParams?.alignBottomTag }
        set { obtainLayoutParams().alignBottomTag = newValue }
    }
    
    @IBInspectable public var layoutAlignLeft: String? {
        get { return self.layoutParams?.alignLeftTag }
        set { obtainLayoutParams().alignRightTag = newValue }
    }
    
    @IBInspectable public var layoutAlignRight: String? {
        get { return self.layoutParams?.alignRightTag }
        set { obtainLayoutParams().alignRightTag = newValue }
    }
    
    @IBInspectable public var layoutAlignLeading: String? {
        get { return self.layoutParams?.alignLeadingTag }
        set { obtainLayoutParams().alignLeadingTag = newValue }
    }
    
    @IBInspectable public var layoutAlignTrailing: String? {
        get { return self.layoutParams?.alignTrailngTag }
        set { obtainLayoutParams().alignTrailngTag = newValue }
    }
    
    @IBInspectable public var layoutAlignBaseline: String? {
        get { return self.layoutParams?.alignBaselineTag }
        set { obtainLayoutParams().alignBaselineTag = newValue }
    }
    
    // Relative position
    
    @IBInspectable public var layoutAbove: String? {
        get { return self.layoutParams?.aboveTag }
        set { obtainLayoutParams().aboveTag = newValue }
    }
    
    @IBInspectable public var layoutBelow: String? {
        get { return self.layoutParams?.belowTag }
        set { obtainLayoutParams().belowTag = newValue }
    }
    
    @IBInspectable public var layoutToLeftOf: String? {
        get { return self.layoutParams?.toLeftOfTag }
        set { obtainLayoutParams().toLeftOfTag = newValue }
    }
    
    @IBInspectable public var layoutToRightOf: String? {
        get { return self.layoutParams?.toRightOfTag }
        set { obtainLayoutParams().toRightOfTag = newValue }
    }
    
    @IBInspectable public var layoutToLeadingOf: String? {
        get { return self.layoutParams?.toLeadingOfTag }
        set { obtainLayoutParams().toLeadingOfTag = newValue }
    }
    
    @IBInspectable public var layoutToTrailingOf: String? {
        get { return self.layoutParams?.toTrailingOfTag }
        set { obtainLayoutParams().toTrailingOfTag = newValue }
    }
    
    @IBInspectable public var layoutAlignWithParentIfMissing: Bool {
        get { return self.layoutParams?.alignWithParentIfMissing ?? false }
        set { obtainLayoutParams().alignWithParentIfMissing = newValue }
    }
    
    // Centering
    
    @IBInspectable public var layoutCenterInParent: Bool {
        get { return self.layoutParams?.centerInParent ?? false }
        set { obtainLayoutParams().centerInParent = newValue }
    }
    
    @IBInspectable public var layoutCenterVertical: Bool {
        get { return self.layoutParams?.centerVertical ?? false }
        set { obtainLayoutParams().centerVertical = newValue }
    }
    
    @IBInspectable public var layoutCenterHorizontal: Bool {
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