//
//  ASLFrameLayout.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/1.
//
//

import UIKit

public class ALSFrameLayout: ALSBaseLayout {

    @IBInspectable internal var measureAllChildren: Bool = false
    
    private static let DEFAULT_CHILD_GRAVITY = ALSGravity.TOP | ALSGravity.LEADING
    
    private var matchParentChildren: [UIView] = [UIView]()
    
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
            let lp = child.layoutParams!
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
            }
        }
    }
    
    override func measureSubviews(size: CGSize) -> CGSize {
        
        let measureMatchParentChildren = widthMode == .WrapContent || heightMode == .WrapContent
        matchParentChildren.removeAll()
        
        let widthSpec: ALSLayoutParams.MeasureSpecMode = layoutParamsOrNull?.measuredWidthSpec ?? .Exactly
        let heightSpec: ALSLayoutParams.MeasureSpecMode = layoutParamsOrNull?.measuredHeightSpec ?? .Exactly
        
        var widthMeasureSpec: ALSLayoutParams.MeasureSpec = (size.width, widthSpec)
        var heightMeasureSpec: ALSLayoutParams.MeasureSpec = (size.height, heightSpec)
        
        var maxHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        var childState: ALSLayoutParams.MeasureStates = (.Unspecified, .Unspecified)
        
        let layoutDirection = self.layoutDirection
        
        for child in subviews {
            let lp = child.layoutParams!
            lp.resolveLayoutDirection(layoutDirection)
            if (measureAllChildren || !lp.hidden) {
                measureChildWithMargins(child, parentWidthMeasureSpec: widthMeasureSpec, widthUsed: 0, parentHeightMeasureSpec: heightMeasureSpec, heightUsed: 0)
                maxWidth = max(maxWidth, lp.measuredWidth + lp.marginAbsLeft + lp.marginAbsRight)
                maxHeight = max(maxHeight, lp.measuredHeight + lp.marginTop + lp.marginBottom)
                childState = ALSBaseLayout.combineMeasuredStates(childState, widthMode: lp.measuredWidthSpec, heightMode: lp.measuredHeightSpec)
                if (measureMatchParentChildren) {
                    if (lp.widthMode == .MatchParent || lp.heightMode == .MatchParent) {
                        matchParentChildren.append(child)
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
        
        widthMeasureSpec = ALSBaseLayout.resolveSizeAndState(maxWidth, measureSpec: widthMeasureSpec, childMeasuredState: childState.0)
        heightMeasureSpec = ALSBaseLayout.resolveSizeAndState(maxHeight, measureSpec: heightMeasureSpec, childMeasuredState: childState.1)
        
        if (matchParentChildren.count > 1) {
            for child in matchParentChildren {
                let lp = child.layoutParams!
                
                let childWidthMeasureSpec: ALSLayoutParams.MeasureSpec
                if (lp.widthMode == .MatchParent) {
                    let width = max(0, widthMeasureSpec.0 - actualLayoutMargins.left - actualLayoutMargins.right - lp.marginAbsLeft - lp.marginAbsRight)
                    childWidthMeasureSpec = (width, .Exactly)
                } else {
                    childWidthMeasureSpec = ALSBaseLayout.getChildMeasureSpec(widthMeasureSpec, padding: actualLayoutMargins.left + actualLayoutMargins.right + lp.marginAbsLeft + lp.marginAbsRight, childDimension: lp.width, childDimensionMode: lp.widthMode)
                }
                
                let childHeightMeasureSpec: ALSLayoutParams.MeasureSpec
                if (lp.heightMode == .MatchParent) {
                    let height = max(0, heightMeasureSpec.0 - actualLayoutMargins.top - actualLayoutMargins.bottom - lp.marginTop - lp.marginBottom)
                    childHeightMeasureSpec = (height, .Exactly)
                } else {
                    childHeightMeasureSpec = ALSBaseLayout.getChildMeasureSpec(heightMeasureSpec, padding: actualLayoutMargins.top + actualLayoutMargins.bottom + lp.marginTop + lp.marginBottom, childDimension: lp.height, childDimensionMode: lp.heightMode)
                }
                
                lp.measure(child, widthSpec: childWidthMeasureSpec, heightSpec: childHeightMeasureSpec)
            }
        }
        return CGSizeMake(widthMeasureSpec.0, heightMeasureSpec.0)
    }

}
