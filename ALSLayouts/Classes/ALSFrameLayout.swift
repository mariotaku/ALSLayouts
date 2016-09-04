//
//  ASLFrameLayout.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/1.
//
//

import UIKit

public class ALSFrameLayout: ALSBaseLayout {

    @IBInspectable internal var measureAllSubviews: Bool = false
    
    private static let DEFAULT_CHILD_GRAVITY = ALSGravity.TOP | ALSGravity.LEADING
    
    private var matchParentSubviews: [UIView] = [UIView]()
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        return measureSubviews(size)
    }
    
    override public func layoutSubviews() {
        
        self.frame.size = measureSubviews(self.bounds.size)
        
        let parentLeft = actualLayoutMargins.left
        let parentRight = self.frame.right - self.frame.left - actualLayoutMargins.right
        
        let parentTop = actualLayoutMargins.top
        let parentBottom = self.frame.bottom - self.frame.top - actualLayoutMargins.bottom
        
        let layoutDirection = self.layoutDirection
        
        for child in subviews {
            let lp = child.layoutParams
            if (!lp.hidden) {
                let width = lp.measuredWidth
                let height = lp.measuredHeight
                
                let childLeft: CGFloat
                let childTop: CGFloat
                
                var gravity = lp.gravity
                if (gravity == -1) {
                    gravity = ALSFrameLayout.DEFAULT_CHILD_GRAVITY
                }
                
                let absoluteGravity = ALSGravity.getAbsoluteGravity(gravity, layoutDirection: layoutDirection)
                let verticalGravity = gravity & ALSGravity.VERTICAL_GRAVITY_MASK
                
                switch (absoluteGravity & ALSGravity.HORIZONTAL_GRAVITY_MASK) {
                case ALSGravity.CENTER_HORIZONTAL :
                    childLeft = parentLeft + (parentRight - parentLeft - width) / 2 + lp.marginAbsLeft - lp.marginAbsRight
                case ALSGravity.RIGHT :
                    childLeft = parentRight - width - lp.marginAbsRight
                default:
                    childLeft = parentLeft + lp.marginAbsLeft
                }
                
                switch (verticalGravity) {
                case ALSGravity.TOP:
                    childTop = parentTop + lp.marginTop
                case ALSGravity.CENTER_VERTICAL:
                    childTop = parentTop + (parentBottom - parentTop - height) / 2 + lp.marginTop - lp.marginBottom
                case ALSGravity.BOTTOM:
                    childTop = parentBottom - height - lp.marginBottom
                default:
                    childTop = parentTop + lp.marginTop
                }
                
                child.frame = CGRectMake(childLeft, childTop, width, height)
            } else {
                child.frame = CGRectZero
            }
        }
    }
    
    override func measureSubviews(size: CGSize) -> CGSize {
        
        let measureMatchParentSubview = widthMode == .WrapContent || heightMode == .WrapContent
        matchParentSubviews.removeAll()
        
        let widthSpec: ALSLayoutParams.MeasureSpecMode = layoutParamsOrNull?.measuredWidthSpec ?? .Exactly
        let heightSpec: ALSLayoutParams.MeasureSpecMode = layoutParamsOrNull?.measuredHeightSpec ?? .Exactly
        
        var widthMeasureSpec: ALSLayoutParams.MeasureSpec = (size.width, widthSpec)
        var heightMeasureSpec: ALSLayoutParams.MeasureSpec = (size.height, heightSpec)
        
        var maxHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        var subviewState: ALSLayoutParams.MeasureStates = (.Unspecified, .Unspecified)
        
        let layoutDirection = self.layoutDirection
        
        for subview in subviews {
            let lp = subview.layoutParams
            lp.resolveLayoutDirection(layoutDirection)
            if (measureAllSubviews || !lp.hidden) {
                measureChildWithMargins(subview, parentWidthMeasureSpec: widthMeasureSpec, widthUsed: 0, parentHeightMeasureSpec: heightMeasureSpec, heightUsed: 0)
                maxWidth = max(maxWidth, lp.measuredWidth + lp.marginAbsLeft + lp.marginAbsRight)
                maxHeight = max(maxHeight, lp.measuredHeight + lp.marginTop + lp.marginBottom)
                subviewState = ALSBaseLayout.combineMeasuredStates(subviewState, widthMode: lp.measuredWidthSpec, heightMode: lp.measuredHeightSpec)
                if (measureMatchParentSubview) {
                    if (lp.widthMode == .MatchParent || lp.heightMode == .MatchParent) {
                        matchParentSubviews.append(subview)
                    }
                }
            }
        }
        
        // Account for padding too
        maxWidth += actualLayoutMargins.left + actualLayoutMargins.right
        maxHeight += actualLayoutMargins.top + actualLayoutMargins.bottom
        
        // Check against our minimum height and width
        let suggestedMinimumHeight: CGFloat = 0
        let suggestedMinimumWidth: CGFloat = 0
        maxHeight = max(maxHeight, suggestedMinimumHeight)
        maxWidth = max(maxWidth, suggestedMinimumWidth)
        
        widthMeasureSpec = ALSBaseLayout.resolveSizeAndState(maxWidth, measureSpec: widthMeasureSpec, childMeasuredState: subviewState.0)
        heightMeasureSpec = ALSBaseLayout.resolveSizeAndState(maxHeight, measureSpec: heightMeasureSpec, childMeasuredState: subviewState.1)
        
        if (matchParentSubviews.count > 1) {
            for subview in matchParentSubviews {
                let lp = subview.layoutParams
                
                let subviewWidthMeasureSpec: ALSLayoutParams.MeasureSpec
                if (lp.widthMode == .MatchParent) {
                    let width = max(0, widthMeasureSpec.0 - actualLayoutMargins.left - actualLayoutMargins.right - lp.marginAbsLeft - lp.marginAbsRight)
                    subviewWidthMeasureSpec = (width, .Exactly)
                } else {
                    subviewWidthMeasureSpec = ALSBaseLayout.getChildMeasureSpec(widthMeasureSpec, padding: actualLayoutMargins.left + actualLayoutMargins.right + lp.marginAbsLeft + lp.marginAbsRight, childDimension: lp.width, childDimensionMode: lp.widthMode)
                }
                
                let subviewHeightMeasureSpec: ALSLayoutParams.MeasureSpec
                if (lp.heightMode == .MatchParent) {
                    let height = max(0, heightMeasureSpec.0 - actualLayoutMargins.top - actualLayoutMargins.bottom - lp.marginTop - lp.marginBottom)
                    subviewHeightMeasureSpec = (height, .Exactly)
                } else {
                    subviewHeightMeasureSpec = ALSBaseLayout.getChildMeasureSpec(heightMeasureSpec, padding: actualLayoutMargins.top + actualLayoutMargins.bottom + lp.marginTop + lp.marginBottom, childDimension: lp.height, childDimensionMode: lp.heightMode)
                }
                
                lp.measure(subview, widthSpec: subviewWidthMeasureSpec, heightSpec: subviewHeightMeasureSpec)
            }
        }
        
        var measuredSize = CGSize()
        if (widthMode == .WrapContent) {
            measuredSize.width = maxWidth
        } else {
            measuredSize.width = widthMeasureSpec.0
        }
        if (heightMode == .WrapContent) {
            measuredSize.height = maxHeight
        } else {
            measuredSize.height = heightMeasureSpec.0
        }
        return measuredSize
    }

}
