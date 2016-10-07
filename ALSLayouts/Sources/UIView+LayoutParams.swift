//
//  UIView+LayoutParams.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/1.
//
//

import UIKit

public extension UIView {
    
    // Size modes
    
    @IBInspectable internal var layoutWidthMode: String {
        get { return self.layoutParams.widthMode.rawValue }
        set { self.layoutParams.widthMode = ALSLayoutParams.SizeMode(rawValue: newValue)! }
    }
    
    @IBInspectable internal var layoutHeightMode: String {
        get { return self.layoutParams.heightMode.rawValue }
        set { self.layoutParams.heightMode = ALSLayoutParams.SizeMode(rawValue: newValue)! }
    }
    
    // Layout visibility
    
    @IBInspectable internal var layoutHidden: Bool {
        get { return self.layoutParams.hidden }
        set { self.layoutParams.hidden = newValue }
    }
    
    // Layout gravity
    
    @IBInspectable internal var layoutGravity: String {
        get { return ALSGravity.format(self.layoutParams.gravity) }
        set { self.layoutParams.gravity = ALSGravity.parse(newValue) }
    }
    
    // Layout gravity
    
    @IBInspectable internal var layoutWeight: CGFloat {
        get { return self.layoutParams.weight }
        set { self.layoutParams.weight = newValue }
    }
    
    // Layout Margins
    
    @IBInspectable internal var layoutMarginTop: CGFloat {
        get { return self.layoutParams.marginTop }
        set { self.layoutParams.marginTop = newValue }
    }
    
    @IBInspectable internal var layoutMarginBottom: CGFloat {
        get { return self.layoutParams.marginBottom }
        set { self.layoutParams.marginBottom = newValue }
    }
    
    @IBInspectable internal var layoutMarginLeft: CGFloat {
        get { return self.layoutParams.marginLeft }
        set { self.layoutParams.marginLeft = newValue }
    }
    
    @IBInspectable internal var layoutMarginRight: CGFloat {
        get { return self.layoutParams.marginRight }
        set { self.layoutParams.marginRight = newValue }
    }
    
    @IBInspectable internal var layoutMarginLeading: CGFloat {
        get { return self.layoutParams.marginLeading }
        set { self.layoutParams.marginLeading = newValue }
    }
    
    @IBInspectable internal var layoutMarginTrailing: CGFloat {
        get { return self.layoutParams.marginTrailing }
        set { self.layoutParams.marginTrailing = newValue }
    }
    
    // Relative Layout params
    
    @IBInspectable internal var layoutAlignParentTop: Bool {
        get { return self.layoutParams.alignParentTop }
        set { self.layoutParams.alignParentTop = newValue }
    }
    
    @IBInspectable internal var layoutAlignParentBottom: Bool {
        get { return self.layoutParams.alignParentBottom }
        set { self.layoutParams.alignParentBottom = newValue }
    }
    
    @IBInspectable internal var layoutAlignParentLeft: Bool {
        get { return self.layoutParams.alignParentLeft }
        set { self.layoutParams.alignParentRight = newValue }
    }
    
    @IBInspectable internal var layoutAlignParentRight: Bool {
        get { return self.layoutParams.alignParentRight }
        set { self.layoutParams.alignParentRight = newValue }
    }
    
    @IBInspectable internal var layoutAlignParentLeading: Bool {
        get { return self.layoutParams.alignParentLeading }
        set { self.layoutParams.alignParentLeading = newValue }
    }
    
    @IBInspectable internal var layoutAlignParentTrailing: Bool {
        get { return self.layoutParams.alignParentTrailing }
        set { self.layoutParams.alignParentTrailing = newValue }
    }
    
    // Relative alignment
    
    @IBInspectable internal var layoutAlignTop: String? {
        get { return self.layoutParams.alignTopTag }
        set { self.layoutParams.alignTopTag = newValue }
    }
    
    @IBInspectable internal var layoutAlignBottom: String? {
        get { return self.layoutParams.alignBottomTag }
        set { self.layoutParams.alignBottomTag = newValue }
    }
    
    @IBInspectable internal var layoutAlignLeft: String? {
        get { return self.layoutParams.alignLeftTag }
        set { self.layoutParams.alignRightTag = newValue }
    }
    
    @IBInspectable internal var layoutAlignRight: String? {
        get { return self.layoutParams.alignRightTag }
        set { self.layoutParams.alignRightTag = newValue }
    }
    
    @IBInspectable internal var layoutAlignLeading: String? {
        get { return self.layoutParams.alignLeadingTag }
        set { self.layoutParams.alignLeadingTag = newValue }
    }
    
    @IBInspectable internal var layoutAlignTrailing: String? {
        get { return self.layoutParams.alignTrailingTag }
        set { self.layoutParams.alignTrailingTag = newValue }
    }
    
    @IBInspectable internal var layoutAlignBaseline: String? {
        get { return self.layoutParams.alignBaselineTag }
        set { self.layoutParams.alignBaselineTag = newValue }
    }
    
    // Relative position
    
    @IBInspectable internal var layoutAbove: String? {
        get { return self.layoutParams.aboveTag }
        set { self.layoutParams.aboveTag = newValue }
    }
    
    @IBInspectable internal var layoutBelow: String? {
        get { return self.layoutParams.belowTag }
        set { self.layoutParams.belowTag = newValue }
    }
    
    @IBInspectable internal var layoutToLeftOf: String? {
        get { return self.layoutParams.toLeftOfTag }
        set { self.layoutParams.toLeftOfTag = newValue }
    }
    
    @IBInspectable internal var layoutToRightOf: String? {
        get { return self.layoutParams.toRightOfTag }
        set { self.layoutParams.toRightOfTag = newValue }
    }
    
    @IBInspectable internal var layoutToLeadingOf: String? {
        get { return self.layoutParams.toLeadingOfTag }
        set { self.layoutParams.toLeadingOfTag = newValue }
    }
    
    @IBInspectable internal var layoutToTrailingOf: String? {
        get { return self.layoutParams.toTrailingOfTag }
        set { self.layoutParams.toTrailingOfTag = newValue }
    }
    
    @IBInspectable internal var layoutAlignWithParentIfMissing: Bool {
        get { return self.layoutParams.alignWithParentIfMissing }
        set { self.layoutParams.alignWithParentIfMissing = newValue }
    }
    
    // Centering
    
    @IBInspectable internal var layoutCenterInParent: Bool {
        get { return self.layoutParams.centerInParent }
        set { self.layoutParams.centerInParent = newValue }
    }
    
    @IBInspectable internal var layoutCenterVertical: Bool {
        get { return self.layoutParams.centerVertical }
        set { self.layoutParams.centerVertical = newValue }
    }
    
    @IBInspectable internal var layoutCenterHorizontal: Bool {
        get { return self.layoutParams.centerHorizontal }
        set { self.layoutParams.centerHorizontal = newValue }
    }
    
    /**
     Returns layout parameters of this view, if no parameter set, obtain a new one. 
     */
    public var layoutParams: ALSLayoutParams {
        return (superview as! ALSBaseLayout).obtainLayoutParams(self)
    }
    
    internal var layoutParamsOrNull: ALSLayoutParams? {
        return (superview as? ALSBaseLayout)?.getLayoutParams(self)
    }
    
}
