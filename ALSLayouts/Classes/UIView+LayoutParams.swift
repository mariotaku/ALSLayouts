//
//  UIView+LayoutParams.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/1.
//
//

import Foundation

extension UIView {
    
    @IBInspectable var layoutGravity: Int {
        get {
            return 0
        }
        set {
            
        }
    }
    
    @IBInspectable var layoutMarginTop: CGFloat {
        get { return self.getLayoutParams()?.marginTop ?? 0 }
        set { obtainLayoutParams().marginTop = newValue }
    }
    
    @IBInspectable var layoutMarginBottom: CGFloat {
        get { return self.getLayoutParams()?.marginBottom ?? 0 }
        set { obtainLayoutParams().marginBottom = newValue }
    }
    
    @IBInspectable var layoutMarginLeading: CGFloat {
        get { return self.getLayoutParams()?.marginLeading ?? 0 }
        set { obtainLayoutParams().marginLeading = newValue }
    }
    
    @IBInspectable var layoutMarginTrailing: CGFloat {
        get { return self.getLayoutParams()?.marginTrailng ?? 0 }
        set { obtainLayoutParams().marginTrailng = newValue }
    }
    
    @IBInspectable var layoutAlignParentTop: Bool {
        get { return self.getLayoutParams()?.alignParentTop ?? false }
        set { obtainLayoutParams().alignParentTop = newValue }
    }
    
    @IBInspectable var layoutAlignParentBottom: Bool {
        get { return self.getLayoutParams()?.alignParentBottom ?? false }
        set { obtainLayoutParams().alignParentBottom = newValue }
    }
    
    @IBInspectable var layoutAlignParentLeading: Bool {
        get { return self.getLayoutParams()?.alignParentLeading ?? false }
        set { obtainLayoutParams().alignParentLeading = newValue }
    }
    
    @IBInspectable var layoutAlignParentTrailing: Bool {
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