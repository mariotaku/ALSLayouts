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

    override public func layoutSubviews() {
        let layoutDirection = UIView.userInterfaceLayoutDirectionForSemanticContentAttribute(self.semanticContentAttribute)
        
        var parentFrame = self.bounds

        for subview in subviews {
            guard let lp = getLayoutParams(subview) else {
                continue
            }
            let subContentSize = subview.intrinsicContentSize()
            let subFrame = subview.frame
            
            let subWidth = resolveSize(lp.widthMode, contentSize: subContentSize.width, frameSize: subFrame.width, parentSize: parentFrame.width, margin: lp.marginLeading + lp.marginTrailng)
            let subHeight = resolveSize(lp.heightMode, contentSize: subContentSize.height, frameSize: subFrame.height, parentSize: parentFrame.height, margin: lp.marginTop + lp.marginBottom)
            
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
                xAdj = 0
            case ALSGravity.RIGHT:
                xAdj = lp.marginTrailng
            default:
                xAdj = lp.marginLeading
            }
            
            switch (verticalGravity) {
            case ALSGravity.CENTER_VERTICAL:
                yAdj = 0
            case ALSGravity.BOTTOM:
                yAdj = lp.marginBottom
            default:
                yAdj = lp.marginTop
            }
            
            subview.frame = ALSGravity.apply(lp.gravity, w: subWidth, h: subHeight, container: parentFrame, xAdj: xAdj, yAdj: yAdj, layoutDirection: layoutDirection)
        }
    }

}
