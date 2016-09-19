/*
 * Copyright (C) 2006 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import UIKit

/**
 * FrameLayout is designed to block out an area on the screen to display
 * a single item. Generally, FrameLayout should be used to hold a single child view, because it can
 * be difficult to organize child views in a way that's scalable to different screen sizes without
 * the children overlapping each other. You can, however, add multiple children to a FrameLayout
 * and control their position within the FrameLayout by assigning gravity to each child, using the
 * `layoutParams.gravity` attribute.
 *
 * Child views are drawn in a stack, with the most recently added child on top.
 * The size of the FrameLayout is the size of its largest child (plus padding), visible
 * or not (if the FrameLayout's parent permits). Views that are `layoutParams.hidden` are
 * used for sizing only if `measureAllSubviews` is set to true.
 *
 * - Author: Mariotaku Lee
 * - Date: Sep 1, 2016
 */
open class ALSFrameLayout: ALSBaseLayout {
    
    fileprivate static let DEFAULT_CHILD_GRAVITY = ALSGravity.TOP | ALSGravity.LEADING
    
    fileprivate var matchParentSubviews: [UIView] = [UIView]()
    
    /**
     Sets whether to consider all subviews, or just those in
     the VISIBLE or INVISIBLE state, when measuring. Defaults to false.
     
     true to consider subviews marked GONE, false otherwise.
     Default value is false.
     */
    @IBInspectable open var measureAllSubviews: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// Layout subviews
    open override func layoutSubviews() {
        
        _ = measureSubviews(self.bounds.size)
        
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
                
                child.frame = CGRect(x: childLeft, y: childTop, width: width, height: height)
            } else {
                child.frame = CGRect.zero
            }
        }
    }
    
    /// Measure subviews
    override func measureSubviews(_ size: CGSize) -> CGSize {
        
        let widthMode: ALSLayoutParams.SizeMode = layoutParamsOrNull?.widthMode ?? self.widthMode
        let heightMode: ALSLayoutParams.SizeMode = layoutParamsOrNull?.heightMode ?? self.heightMode
        
        let measureMatchParentSubview = widthMode == .WrapContent || heightMode == .WrapContent
        matchParentSubviews.removeAll()
        
        let widthSpec: ALSLayoutParams.MeasureSpecMode = layoutParamsOrNull?.measuredWidthSpec ?? .exactly
        let heightSpec: ALSLayoutParams.MeasureSpecMode = layoutParamsOrNull?.measuredHeightSpec ?? .exactly
        
        var widthMeasureSpec: ALSLayoutParams.MeasureSpec = (size.width, widthSpec)
        var heightMeasureSpec: ALSLayoutParams.MeasureSpec = (size.height, heightSpec)
        
        var maxHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        var subviewState: ALSLayoutParams.MeasureStates = (.unspecified, .unspecified)
        
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
                    subviewWidthMeasureSpec = (width, .exactly)
                } else {
                    subviewWidthMeasureSpec = ALSBaseLayout.getChildMeasureSpec(widthMeasureSpec, padding: actualLayoutMargins.left + actualLayoutMargins.right + lp.marginAbsLeft + lp.marginAbsRight, childDimension: lp.width, childDimensionMode: lp.widthMode)
                }
                
                let subviewHeightMeasureSpec: ALSLayoutParams.MeasureSpec
                if (lp.heightMode == .MatchParent) {
                    let height = max(0, heightMeasureSpec.0 - actualLayoutMargins.top - actualLayoutMargins.bottom - lp.marginTop - lp.marginBottom)
                    subviewHeightMeasureSpec = (height, .exactly)
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
