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
        get { return self.getLayoutParams()?.widthMode ?? .StaticSize }
        set { obtainLayoutParams().widthMode = newValue }
    }
    
    internal var layoutHeightMode: ALSLayoutParams.SizeMode {
        get { return self.getLayoutParams()?.heightMode ?? .StaticSize }
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
        get { return self.getLayoutParams()?.hidden ?? false }
        set { obtainLayoutParams().hidden = newValue }
    }
    
    // Layout gravity
    
    public var layoutGravity: Int {
        get { return self.getLayoutParams()?.gravity ?? 0 }
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
        get { return self.getLayoutParams()?.marginTop ?? 0 }
        set { obtainLayoutParams().marginTop = newValue }
    }
    
    @IBInspectable public var layoutMarginBottom: CGFloat {
        get { return self.getLayoutParams()?.marginBottom ?? 0 }
        set { obtainLayoutParams().marginBottom = newValue }
    }
    
    @IBInspectable public var layoutMarginLeft: CGFloat {
        get { return self.getLayoutParams()?.marginLeft ?? 0 }
        set { obtainLayoutParams().marginLeft = newValue }
    }
    
    @IBInspectable public var layoutMarginRight: CGFloat {
        get { return self.getLayoutParams()?.marginRight ?? 0 }
        set { obtainLayoutParams().marginRight = newValue }
    }
    
    @IBInspectable public var layoutMarginLeading: CGFloat {
        get { return self.getLayoutParams()?.marginLeading ?? 0 }
        set { obtainLayoutParams().marginLeading = newValue }
    }
    
    @IBInspectable public var layoutMarginTrailing: CGFloat {
        get { return self.getLayoutParams()?.marginTrailng ?? 0 }
        set { obtainLayoutParams().marginTrailng = newValue }
    }
    
    // Relative Layout params
    
    @IBInspectable public var layoutAlignParentTop: Bool {
        get { return self.getLayoutParams()?.alignParentTop ?? false }
        set { obtainLayoutParams().alignParentTop = newValue }
    }
    
    @IBInspectable public var layoutAlignParentBottom: Bool {
        get { return self.getLayoutParams()?.alignParentBottom ?? false }
        set { obtainLayoutParams().alignParentBottom = newValue }
    }
    
    @IBInspectable public var layoutAlignParentLeft: Bool {
        get { return self.getLayoutParams()?.alignParentLeft ?? false }
        set { obtainLayoutParams().alignParentRight = newValue }
    }
    
    @IBInspectable public var layoutAlignParentRight: Bool {
        get { return self.getLayoutParams()?.alignParentRight ?? false }
        set { obtainLayoutParams().alignParentRight = newValue }
    }
    
    @IBInspectable public var layoutAlignParentLeading: Bool {
        get { return self.getLayoutParams()?.alignParentLeading ?? false }
        set { obtainLayoutParams().alignParentLeading = newValue }
    }
    
    // Relative alignment
    
    @IBInspectable public var layoutAlignTop: String? {
        get { return self.getLayoutParams()?.alignTop }
        set { obtainLayoutParams().alignTop = newValue }
    }
    
    @IBInspectable public var layoutAlignBottom: String? {
        get { return self.getLayoutParams()?.alignBottom }
        set { obtainLayoutParams().alignBottom = newValue }
    }
    
    @IBInspectable public var layoutAlignLeft: String? {
        get { return self.getLayoutParams()?.alignLeft }
        set { obtainLayoutParams().alignRight = newValue }
    }
    
    @IBInspectable public var layoutAlignRight: String? {
        get { return self.getLayoutParams()?.alignRight }
        set { obtainLayoutParams().alignRight = newValue }
    }
    
    @IBInspectable public var layoutAlignLeading: String? {
        get { return self.getLayoutParams()?.alignLeading }
        set { obtainLayoutParams().alignLeading = newValue }
    }
    
    @IBInspectable public var layoutAlignTrailing: String? {
        get { return self.getLayoutParams()?.alignTrailng }
        set { obtainLayoutParams().alignTrailng = newValue }
    }
    
    @IBInspectable public var layoutAlignBaseline: String? {
        get { return self.getLayoutParams()?.alignBaseline }
        set { obtainLayoutParams().alignBaseline = newValue }
    }
    
    // Relative position
    
    @IBInspectable public var layoutAbove: String? {
        get { return self.getLayoutParams()?.above }
        set { obtainLayoutParams().above = newValue }
    }
    
    @IBInspectable public var layoutBelow: String? {
        get { return self.getLayoutParams()?.below }
        set { obtainLayoutParams().below = newValue }
    }
    
    @IBInspectable public var layoutToLeftOf: String? {
        get { return self.getLayoutParams()?.toLeftOf }
        set { obtainLayoutParams().toLeftOf = newValue }
    }
    
    @IBInspectable public var layoutToRightOf: String? {
        get { return self.getLayoutParams()?.toRightOf }
        set { obtainLayoutParams().toRightOf = newValue }
    }
    
    @IBInspectable public var layoutToLeadingOf: String? {
        get { return self.getLayoutParams()?.toLeadingOf }
        set { obtainLayoutParams().toLeadingOf = newValue }
    }
    
    @IBInspectable public var layoutToTrailingOf: String? {
        get { return self.getLayoutParams()?.toTrailingOf }
        set { obtainLayoutParams().toTrailingOf = newValue }
    }
    
    // Centering
    
    @IBInspectable public var layoutCenterInParent: Bool {
        get { return self.getLayoutParams()?.centerInParent ?? false }
        set { obtainLayoutParams().centerInParent = newValue }
    }
    
    @IBInspectable public var layoutCenterVertical: Bool {
        get { return self.getLayoutParams()?.centerVertical ?? false }
        set { obtainLayoutParams().centerVertical = newValue }
    }
    
    @IBInspectable public var layoutCenterHorizontal: Bool {
        get { return self.getLayoutParams()?.centerHorizontal ?? false }
        set { obtainLayoutParams().centerHorizontal = newValue }
    }
    
    
    private func getLayoutParams() -> ALSLayoutParams? {
        return (superview as! ALSBaseLayout).getLayoutParams(self)
    }
    
    private func obtainLayoutParams() -> ALSLayoutParams {
        return (superview as! ALSBaseLayout).obtainLayoutParams(self)
    }
    
    
}