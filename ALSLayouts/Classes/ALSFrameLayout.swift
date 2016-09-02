//
//  ASLFrameLayout.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/1.
//
//

import UIKit

@IBDesignable
public class ALSFrameLayout: ALSBaseLayout {

    public override func sizeThatFits(size: CGSize) -> CGSize {
        print("sizeThatFits")
        return super.sizeThatFits(size)
    }
    
    override public func layoutSubviews() {
        print("layoutSubviews")
        let layoutDirection = UIView.userInterfaceLayoutDirectionForSemanticContentAttribute(self.semanticContentAttribute)
        
        var parentFrame = self.bounds

        for subview in subviews {
            guard let lp = getLayoutParams(subview) else {
                continue
            }
            let subContentSize = subview.intrinsicContentSize()
            let subFrame = subview.frame
            
            let leftMargin = lp.resolveMarginLeftAbsolute(layoutDirection)
            let rightMargin = lp.resolveMarginRightAbsolute(layoutDirection)
            
            
            let subWidth = lp.hidden ? 0 : resolveSize(lp.widthMode, contentSize: subContentSize.width, frameSize: subFrame.width, parentSize: parentFrame.width, margin: leftMargin + rightMargin)
            let subHeight = lp.hidden ? 0 : resolveSize(lp.heightMode, contentSize: subContentSize.height, frameSize: subFrame.height, parentSize: parentFrame.height, margin: lp.marginTop + lp.marginBottom)
            
            var gravity = lp.gravity
            if (gravity == -1) {
                gravity = ALSGravity.LEFT | ALSGravity.TOP
            }
            
            let absoluteGravity = ALSGravity.getAbsoluteGravity(gravity, layoutDirection: layoutDirection)
            let verticalGravity = gravity & ALSGravity.VERTICAL_GRAVITY_MASK
            
            var xAdj: CGFloat = 0
            var yAdj: CGFloat = 0
            
            switch (absoluteGravity & ALSGravity.HORIZONTAL_GRAVITY_MASK) {
            case ALSGravity.CENTER_HORIZONTAL:
                xAdj = leftMargin - rightMargin
            case ALSGravity.RIGHT:
                xAdj = rightMargin
            default:
                xAdj = leftMargin
            }
            
            switch (verticalGravity) {
            case ALSGravity.CENTER_VERTICAL:
                yAdj = lp.marginTop - lp.marginBottom
            case ALSGravity.BOTTOM:
                yAdj = lp.marginBottom
            default:
                yAdj = lp.marginTop
            }
            
            subview.frame = ALSGravity.apply(lp.gravity, w: subWidth, h: subHeight, container: parentFrame, xAdj: xAdj, yAdj: yAdj, layoutDirection: layoutDirection)
        }
    }

}
