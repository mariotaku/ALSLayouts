//
//  UIView+LayoutParams.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/1.
//
//

import Foundation

public extension UIView {
    
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
    
    @IBInspectable public var layoutMarginTop: CGFloat {
        get { return self.getLayoutParams()?.marginTop ?? 0 }
        set { obtainLayoutParams().marginTop = newValue }
    }
    
    @IBInspectable public var layoutMarginBottom: CGFloat {
        get { return self.getLayoutParams()?.marginBottom ?? 0 }
        set { obtainLayoutParams().marginBottom = newValue }
    }
    
    @IBInspectable public var layoutMarginLeading: CGFloat {
        get { return self.getLayoutParams()?.marginLeading ?? 0 }
        set { obtainLayoutParams().marginLeading = newValue }
    }
    
    @IBInspectable public var layoutMarginTrailing: CGFloat {
        get { return self.getLayoutParams()?.marginTrailng ?? 0 }
        set { obtainLayoutParams().marginTrailng = newValue }
    }
    
    @IBInspectable public var layoutAlignParentTop: Bool {
        get { return self.getLayoutParams()?.alignParentTop ?? false }
        set { obtainLayoutParams().alignParentTop = newValue }
    }
    
    @IBInspectable public var layoutAlignParentBottom: Bool {
        get { return self.getLayoutParams()?.alignParentBottom ?? false }
        set { obtainLayoutParams().alignParentBottom = newValue }
    }
    
    @IBInspectable public var layoutAlignParentLeading: Bool {
        get { return self.getLayoutParams()?.alignParentLeading ?? false }
        set { obtainLayoutParams().alignParentLeading = newValue }
    }
    
    @IBInspectable public var layoutAlignParentTrailing: Bool {
        get { return self.getLayoutParams()?.alignParentTrailng ?? false }
        set { obtainLayoutParams().alignParentTrailng = newValue }
    }
    
    @IBInspectable var visibility: Int {
        get {
            return 0
        }
        set {
            
        }
    }
    
    private func getLayoutParams() -> ALSLayoutParams? {
        return (superview as! ALSBaseLayout).getLayoutParams(self)
    }
    
    private func obtainLayoutParams() -> ALSLayoutParams {
        return (superview as! ALSBaseLayout).obtainLayoutParams(self)
    }
    
    
}