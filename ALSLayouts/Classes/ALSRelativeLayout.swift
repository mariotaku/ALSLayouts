//
//  ALSRelativeLayout.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/2.
//
//

import UIKit

public class ALSRelativeLayout: ALSBaseLayout {
    
    static let TRUE = -1
    
    /**
     * Rule that aligns a child's right edge with another child's left edge.
     */
    static let LEFT_OF = 0
    /**
     * Rule that aligns a child's left edge with another child's right edge.
     */
    static let RIGHT_OF = 1
    /**
     * Rule that aligns a child's bottom edge with another child's top edge.
     */
    static let ABOVE = 2
    /**
     * Rule that aligns a child's top edge with another child's bottom edge.
     */
    static let BELOW = 3
    
    /**
     * Rule that aligns a child's baseline with another child's baseline.
     */
    static let ALIGN_BASELINE = 4
    /**
     * Rule that aligns a child's left edge with another child's left edge.
     */
    static let ALIGN_LEFT = 5
    /**
     * Rule that aligns a child's top edge with another child's top edge.
     */
    static let ALIGN_TOP = 6
    /**
     * Rule that aligns a child's right edge with another child's right edge.
     */
    static let ALIGN_RIGHT = 7
    /**
     * Rule that aligns a child's bottom edge with another child's bottom edge.
     */
    static let ALIGN_BOTTOM = 8
    
    /**
     * Rule that aligns the child's left edge with its RelativeLayout
     * parent's left edge.
     */
    static let ALIGN_PARENT_LEFT = 9
    /**
     * Rule that aligns the child's top edge with its RelativeLayout
     * parent's top edge.
     */
    static let ALIGN_PARENT_TOP = 10
    /**
     * Rule that aligns the child's right edge with its RelativeLayout
     * parent's right edge.
     */
    static let ALIGN_PARENT_RIGHT = 11
    /**
     * Rule that aligns the child's bottom edge with its RelativeLayout
     * parent's bottom edge.
     */
    static let ALIGN_PARENT_BOTTOM = 12
    
    /**
     * Rule that centers the child with respect to the bounds of its
     * RelativeLayout parent.
     */
    static let CENTER_IN_PARENT = 13
    /**
     * Rule that centers the child horizontally with respect to the
     * bounds of its RelativeLayout parent.
     */
    static let CENTER_HORIZONTAL = 14
    /**
     * Rule that centers the child vertically with respect to the
     * bounds of its RelativeLayout parent.
     */
    static let CENTER_VERTICAL = 15
    /**
     * Rule that aligns a child's end edge with another child's start edge.
     */
    static let LEADING_OF = 16
    /**
     * Rule that aligns a child's start edge with another child's end edge.
     */
    static let TRAILING_OF = 17
    /**
     * Rule that aligns a child's start edge with another child's start edge.
     */
    static let ALIGN_LEADING = 18
    /**
     * Rule that aligns a child's end edge with another child's end edge.
     */
    static let ALIGN_TRAILING = 19
    /**
     * Rule that aligns the child's start edge with its RelativeLayout
     * parent's start edge.
     */
    static let ALIGN_PARENT_LEADING = 20
    /**
     * Rule that aligns the child's end edge with its RelativeLayout
     * parent's end edge.
     */
    static let ALIGN_PARENT_TRAILING = 21
    
    static let VERB_COUNT = 22
    
    static let RULES_VERTICAL: [Int] = [ABOVE, BELOW, ALIGN_BASELINE, ALIGN_TOP, ALIGN_BOTTOM]
    
    static let RULES_HORIZONTAL: [Int] = [LEFT_OF, RIGHT_OF, ALIGN_LEFT, ALIGN_RIGHT, LEADING_OF, TRAILING_OF, ALIGN_LEADING, ALIGN_TRAILING]
    
    private var baselineView: UIView? = nil
    
    private var gravity: Int = ALSGravity.LEADING | ALSGravity.TOP {
        didSet {
            var fixedValue = gravity
            if (oldValue != fixedValue) {
                if (fixedValue & ALSGravity.RELATIVE_HORIZONTAL_GRAVITY_MASK == 0) {
                    fixedValue = fixedValue | ALSGravity.LEADING
                }
                
                if (fixedValue & ALSGravity.VERTICAL_GRAVITY_MASK == 0) {
                    fixedValue = fixedValue | ALSGravity.TOP
                }
                
                gravity = fixedValue
                setNeedsLayout()
            }
        }
    }
    
    func setHorizontalGravity(horizontalGravity: Int) {
        let gravity = horizontalGravity & ALSGravity.RELATIVE_HORIZONTAL_GRAVITY_MASK
        if (self.gravity & ALSGravity.RELATIVE_HORIZONTAL_GRAVITY_MASK != gravity) {
            self.gravity = self.gravity & ~ALSGravity.RELATIVE_HORIZONTAL_GRAVITY_MASK | gravity
            setNeedsLayout()
        }
    }
    
    func setVerticalGravity(verticalGravity: Int) {
        let gravity = verticalGravity & ALSGravity.VERTICAL_GRAVITY_MASK
        if (self.gravity & ALSGravity.VERTICAL_GRAVITY_MASK != gravity) {
            self.gravity = self.gravity & ~ALSGravity.VERTICAL_GRAVITY_MASK | gravity
            setNeedsLayout()
        }
    }
    
    private var contentBounds = CGRect()
    private var selfBounds = CGRect()
    private var ignoreGravity: Int = 0
    
    private var dirtyHierarchy: Bool = false
    private var sortedHorizontalSubviews: [UIView!]! = nil
    private var sortedVerticalSubviews: [UIView!]! = nil
    private let graph = DependencyGraph()

    public override func setNeedsLayout() {
        super.setNeedsLayout()
        dirtyHierarchy = true
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        dirtyHierarchy = true
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        // Resolve int view tags
        for (k, lp) in layoutParamsMap {
            lp.resolveViewTags()
        }
        measureSubviews(size)
        return self.bounds.size
    }
    
    public override func layoutSubviews() {
        // Resolve int view tags
        for (k, lp) in layoutParamsMap {
            lp.resolveViewTags()
        }
        
        measureSubviews(self.bounds.size)
        
        // Final step, do actual layout
        for subview in subviews {
            let st = subview.layoutParams!
            if (!st.hidden) {
                subview.frame = CGRectMake(st.left, st.top, st.right - st.left, st.bottom - st.top)
            } else {
                subview.frame = CGRectZero
            }
        }
    }
    
    func measureSubviews(size: CGSize) {
        if (dirtyHierarchy) {
            dirtyHierarchy = false
            sortChildren()
        }
        
        var myWidth: CGFloat = -1
        var myHeight: CGFloat = -1
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        let widthSpec: ALSLayoutParams.MeasureSpecMode = layoutParamsOrNull?.measuredWidthSpec ?? .Exactly
        let heightSpec: ALSLayoutParams.MeasureSpecMode = layoutParamsOrNull?.measuredHeightSpec ?? .Exactly
        
        let widthSize = size.width
        let heightSize = size.height
        
        // Record our dimensions if they are known;
        if (widthSpec != .Unspecified) {
            myWidth = widthSize
        }
        
        if (heightSpec != .Unspecified) {
            myHeight = heightSize
        }
        
        if (widthMode == .StaticSize) {
            width = myWidth
        } else if (widthMode == .MatchParent) {
            if let parent = superview where !(parent is ALSBaseLayout) {
                width = parent.frame.width - parent.compatLayoutMargins.left - parent.compatLayoutMargins.right
            } else {
                width = myWidth
            }
        }
        
        if (heightMode == .StaticSize) {
            height = myHeight
        } else if (heightMode == .MatchParent) {
            if let parent = superview where !(parent is ALSBaseLayout) {
                height = parent.frame.height - parent.compatLayoutMargins.top - parent.compatLayoutMargins.bottom
            } else {
                height = myHeight
            }
        }
        
        var ignore: UIView? = nil
        var gravity = self.gravity & ALSGravity.RELATIVE_HORIZONTAL_GRAVITY_MASK
        let horizontalGravity = gravity != ALSGravity.LEADING && gravity != 0
        gravity = self.gravity & ALSGravity.VERTICAL_GRAVITY_MASK
        let verticalGravity = gravity != ALSGravity.TOP && gravity != 0
        
        var left = CGFloat.max
        var top = CGFloat.max
        var right = CGFloat.min
        var bottom = CGFloat.min
        
        var offsetHorizontalAxis = false
        var offsetVerticalAxis = false
        
        if ((horizontalGravity || verticalGravity) && ignoreGravity != 0) {
            ignore = viewWithTag(ignoreGravity)
        }
        
        let isWrapContentWidth = widthMode == .WrapContent
        let isWrapContentHeight = heightMode == .WrapContent
        
        // We need to know our size for doing the correct computation of children positioning in RTL
        // mode but there is no practical way to get it instead of running the code below.
        // So, instead of running the code twice, we just set the width to a "default display width"
        // before the computation and then, as a last pass, we will update their real position with
        // an offset equals to "DEFAULT_WIDTH - width".
        let isLayoutRtl = layoutDirection == .RightToLeft
        if (isLayoutRtl && myWidth == -1) {
            myWidth = CGFloat.NaN
        }
        
        
        for subview in sortedHorizontalSubviews {
            let params = subview.layoutParams!
            if (!params.hidden) {
                let rules = params.getRules(layoutDirection)
                
                applyHorizontalSizeRules(params, myWidth: myWidth, rules: rules)
                measureChildHorizontal(subview, params: params, myWidth: myWidth, myHeight: myHeight)
                
                if (positionChildHorizontal(subview, params: params, myWidth: myWidth, wrapContent: isWrapContentWidth)) {
                    offsetHorizontalAxis = true
                }
            }
        }
        
        
        for subview in sortedVerticalSubviews {
            let params = subview.layoutParams!
            if (!params.hidden) {
                // TODO use child.baseline calculation
                applyVerticalSizeRules(params, myHeight: myHeight, myBaseline: -1)
                measureChild(subview, params: params, myWidth: myWidth, myHeight: myHeight)
                if (positionChildVertical(subview, params: params, myHeight: myHeight, wrapContent: isWrapContentHeight)) {
                    offsetVerticalAxis = true
                }
                
                if (isWrapContentWidth) {
                    if (isLayoutRtl) {
                        width = max(width, myWidth - params.left - params.marginAbsLeft)
                    } else {
                        width = max(width, params.right + params.marginAbsRight)
                    }
                }
                
                if (isWrapContentHeight) {
                    height = max(height, params.bottom + params.marginBottom)
                }
                
                if (subview !== ignore || verticalGravity) {
                    left = min(left, params.left - params.marginAbsLeft)
                    top = min(top, params.top - params.marginTop)
                }
                
                if (subview !== ignore || horizontalGravity) {
                    right = max(right, params.right + params.marginAbsRight)
                    bottom = max(bottom, params.bottom + params.marginBottom)
                }
            }
        }
        
        // Use the top-start-most laid out view as the baseline. RTL offsets are
        // applied later, so we can use the left-most edge as the starting edge.
        var baselineView: UIView? = nil
        var baselineParams: ALSLayoutParams? = nil
        for subview in sortedVerticalSubviews {
            let childParams = subview.layoutParams!
            if (!childParams.hidden) {
                if (baselineView == nil || baselineParams == nil || compareLayoutPosition(childParams, baselineParams!) < 0) {
                    baselineView = subview
                    baselineParams = childParams
                }
            }
        }
        self.baselineView = baselineView
        
        if (isWrapContentWidth) {
            // Width already has left padding in it since it was calculated by looking at
            // the right of each child view
            width += actualLayoutMargins.right
            
            if (widthSize >= 0) {
                width = max(width, widthSize)
            }
            
            let suggestedMinimumWidth: CGFloat = 0
            width = max(width, suggestedMinimumWidth)
            width = ALSRelativeLayout.resolveSize(width, specSize: widthSize, specMode: widthSpec)
            
            if (offsetHorizontalAxis) {
                for subview in sortedVerticalSubviews {
                    let params = subview.layoutParams!
                    if (!params.hidden) {
                        let rules = params.getRules(layoutDirection)
                        if (rules[ALSRelativeLayout.CENTER_IN_PARENT] != 0 || rules[ALSRelativeLayout.CENTER_HORIZONTAL] != 0) {
                            ALSRelativeLayout.centerHorizontal(subview, params: params, myWidth: width)
                        } else if (rules[ALSRelativeLayout.ALIGN_PARENT_RIGHT] != 0) {
                            let childWidth = params.measuredWidth
                            params.left = width - actualLayoutMargins.right - childWidth
                            params.right = params.left + childWidth
                        }
                    }
                }
            }
        }
        
        if (isWrapContentHeight) {
            // Height already has top padding in it since it was calculated by looking at
            // the bottom of each child view
            height += actualLayoutMargins.bottom
            
            if (heightSize >= 0) {
                height = max(height, heightSize)
            }
            
            let suggestedMinimumHeight: CGFloat = 0
            height = max(height, suggestedMinimumHeight)
            height = ALSRelativeLayout.resolveSize(height, specSize: heightSize, specMode: heightSpec)
            
            if (offsetVerticalAxis) {
                for subview in sortedVerticalSubviews {
                    let params = subview.layoutParams!
                    if (!params.hidden) {
                        let rules = params.getRules(layoutDirection)
                        if (rules[ALSRelativeLayout.CENTER_IN_PARENT] != 0 || rules[ALSRelativeLayout.CENTER_VERTICAL] != 0) {
                            ALSRelativeLayout.centerVertical(subview, params: params, myHeight: height)
                        } else if (rules[ALSRelativeLayout.ALIGN_PARENT_BOTTOM] != 0) {
                            let childHeight = params.measuredHeight
                            params.top = height - actualLayoutMargins.bottom - childHeight
                            params.bottom = params.top + childHeight
                        }
                    }
                }
            }
        }
        
        if (horizontalGravity || verticalGravity) {
            
            self.selfBounds.set(actualLayoutMargins.left, top: actualLayoutMargins.top, right: width - actualLayoutMargins.right,
                                bottom: height - actualLayoutMargins.bottom)
            
            ALSGravity.apply(self.gravity, w: right - left, h: bottom - top, container: selfBounds, outRect: &self.contentBounds,
                             layoutDirection: layoutDirection)
            
            let horizontalOffset = contentBounds.left - left
            let verticalOffset = contentBounds.top - top
            if (horizontalOffset != 0 || verticalOffset != 0) {
                for subview in sortedVerticalSubviews {
                    let params = subview.layoutParams!
                    if (!params.hidden && subview !== ignore) {
                        
                        if (horizontalGravity) {
                            params.left += horizontalOffset
                            params.right += horizontalOffset
                        }
                        if (verticalGravity) {
                            params.top += verticalOffset
                            params.bottom += verticalOffset
                        }
                    }
                }
            }
        }
        
        if (isLayoutRtl) {
            let offsetWidth = myWidth - width
            for subview in sortedVerticalSubviews {
                let params = subview.layoutParams!
                if (!params.hidden) {
                    params.left -= offsetWidth
                    params.right -= offsetWidth
                }
            }
        }
        
        if (isWrapContentWidth) {
            frame.size.width = right - left + actualLayoutMargins.left + actualLayoutMargins.right
        } else {
            frame.size.width = width
        }
        if (isWrapContentHeight) {
            frame.size.height = bottom - top + actualLayoutMargins.top + actualLayoutMargins.bottom
        } else {
            frame.size.height = height
        }
    }
    
    /**
     * @return a negative number if the top of `p1` is above the top of
     * * `p2` or if they have identical top values and the left of
     * * `p1` is to the left of `p2`, or a positive number
     * * otherwise
     */
    private func compareLayoutPosition(_ p1: ALSLayoutParams, _ p2: ALSLayoutParams) -> CGFloat {
        let topDiff = p1.top - p2.top
        if (topDiff != 0) {
            return topDiff
        }
        return p1.left - p2.left
    }
    
    
    private func sortChildren() {
        let subViewsCount = subviews.count
        
        self.graph.clear()
        
        for subview in subviews {
            self.graph.add(subview)
        }
        
        
        if (sortedVerticalSubviews?.count != subViewsCount) {
            sortedVerticalSubviews = [UIView!](count: subViewsCount, repeatedValue: nil)
        }
        
        if (sortedHorizontalSubviews?.count != subViewsCount) {
            sortedHorizontalSubviews = [UIView!](count: subViewsCount, repeatedValue: nil)
        }
        
        self.graph.getSortedViews(&sortedVerticalSubviews!, rules: ALSRelativeLayout.RULES_VERTICAL)
        self.graph.getSortedViews(&sortedHorizontalSubviews!, rules: ALSRelativeLayout.RULES_HORIZONTAL)
    }
    
    /**
     * Measure a child. The child should have left, top, right and bottom information
     * stored in its LayoutParams. If any of these values is VALUE_NOT_SET it means
     * that the view can extend up to the corresponding edge.
     
     * @param child    Child to measure
     * *
     * @param params   LayoutParams associated with child
     * *
     * @param myWidth  Width of the the RelativeLayout
     * *
     * @param myHeight Height of the RelativeLayout
     */
    private func measureChild(child: UIView, params: ALSLayoutParams, myWidth: CGFloat, myHeight: CGFloat) {
        let childWidthMeasureSpec = getChildMeasureSpec(params.left, childEnd: params.right, childSize: params.width, childSizeMode: params.widthMode, startMargin: params.marginAbsLeft, endMargin: params.marginAbsRight, startPadding: actualLayoutMargins.left, endPadding: actualLayoutMargins.right, mySize: myWidth)
        
        let childHeightMeasureSpec = getChildMeasureSpec(params.top, childEnd: params.bottom, childSize: params.height, childSizeMode: params.heightMode, startMargin: params.marginTop, endMargin: params.marginBottom, startPadding: actualLayoutMargins.top, endPadding: actualLayoutMargins.bottom, mySize: myHeight)

        params.measure(child, widthSpec: childWidthMeasureSpec, heightSpec: childHeightMeasureSpec)
    }
    
    private func measureChildHorizontal(child: UIView, params: ALSLayoutParams, myWidth: CGFloat, myHeight: CGFloat) {
        let childWidthMeasureSpec = getChildMeasureSpec(params.left, childEnd: params.right, childSize: params.width, childSizeMode: params.widthMode, startMargin: params.marginAbsLeft, endMargin: params.marginAbsRight, startPadding: actualLayoutMargins.left, endPadding: actualLayoutMargins.right, mySize: myWidth)
        
        var measuredHeight: CGFloat = 0
        var measuredHeightSpec: ALSLayoutParams.MeasureSpecMode = .Unspecified
        if (myHeight < 0) {
            if (params.height >= 0) {
                // Height mode is EXACTLY in Android source
                measuredHeight = params.height
                measuredHeightSpec = .Exactly
            } else {
                // Negative values in a mySize/myWidth/myWidth value in
                // RelativeLayout measurement is code for, "we got an
                // unspecified mode in the RelativeLayout's measure spec."
                // Carry it forward.
                measuredHeight = 0
                measuredHeightSpec = .Unspecified
            }
        } else {
            let maxHeight = max(0, myHeight - actualLayoutMargins.top - actualLayoutMargins.bottom - params.marginTop - params.marginBottom)
            
            if (params.heightMode == .MatchParent) {
                measuredHeightSpec = .Exactly
            } else {
                measuredHeightSpec = .AtMost
            }
            measuredHeight = maxHeight
        }
        
        params.measure(child, widthSpec: childWidthMeasureSpec, heightSpec: (measuredHeight, measuredHeightSpec))
    }
    
    /**
     * Get a measure spec that accounts for all of the constraints on this view.
     * This includes size constraints imposed by the RelativeLayout as well as
     * the View's desired dimension.
     
     * @param childStart   The left or top field of the child's layout params
     * *
     * @param childEnd     The right or bottom field of the child's layout params
     * *
     * @param childSize    The child's desired size (the width or height field of
     * *                     the child's layout params)
     * *
     * @param startMargin  The left or top margin
     * *
     * @param endMargin    The right or bottom margin
     * *
     * @param startPadding mPaddingLeft or mPaddingTop
     * *
     * @param endPadding   mPaddingRight or mPaddingBottom
     * *
     * @param mySize       The width or height of this view (the RelativeLayout)
     * *
     * @return MeasureSpecMode for the child
     */
    private func getChildMeasureSpec(childStart: CGFloat, childEnd: CGFloat,
                                     childSize: CGFloat, childSizeMode: ALSLayoutParams.SizeMode,
                                     startMargin: CGFloat, endMargin: CGFloat, startPadding: CGFloat,
                                     endPadding: CGFloat, mySize: CGFloat) -> ALSLayoutParams.MeasureSpec {
        var childSpecMode: ALSLayoutParams.MeasureSpecMode = .Unspecified
        var childSpecSize: CGFloat = 0
        
        // Negative values in a mySize value in RelativeLayout
        // measurement is code for, "we got an unspecified mode in the
        // RelativeLayout's measure spec."
        let isUnspecified = mySize < 0
        if (isUnspecified) {
            if (!childStart.isNaN && !childEnd.isNaN) {
                // Constraints fixed both edges, so child has an exact size.
                childSpecSize = max(0, childEnd - childStart)
                childSpecMode = .Exactly
            } else if (childSizeMode == .StaticSize) {
                // The child specified an exact size.
                childSpecSize = childSize
                childSpecMode = .Exactly
            } else {
                // Allow the child to be whatever size it wants.
                childSpecSize = 0
                childSpecMode = .Unspecified
            }
            
            return (childSpecSize, childSpecMode)
        }
        
        // Figure out start and end bounds.
        var tempStart = childStart
        var tempEnd = childEnd
        
        // If the view did not express a layout constraint for an edge, use
        // view's margins and our padding
        if (tempStart.isNaN) {
            tempStart = startPadding + startMargin
        }
        if (tempEnd.isNaN) {
            tempEnd = mySize - endPadding - endMargin
        }
        
        // Figure out maximum size available to this view
        let maxAvailable = tempEnd - tempStart
        
        if (!childStart.isNaN && !childEnd.isNaN) {
            // Constraints fixed both edges, so child must be an exact size.
            childSpecMode = isUnspecified ? .Unspecified : .Exactly
            childSpecSize = max(0, maxAvailable)
        } else {
            switch (childSizeMode) {
            case .StaticSize:
                // Child wanted an exact size. Give as much as possible.
                childSpecMode = .Exactly
                
                if (maxAvailable >= 0) {
                    // We have a maximum size in this dimension.
                    childSpecSize = min(maxAvailable, childSize)
                } else {
                    // We can grow in this dimension.
                    childSpecSize = childSize
                }
                
            case .MatchParent:
                // Child wanted to be as big as possible. Give all available
                // space.
                childSpecMode = isUnspecified ? .Unspecified : .Exactly
                childSpecSize = max(0, maxAvailable)
            case .WrapContent:
                // Child wants to wrap content. Use AT_MOST to communicate
                // available space if we know our max size.
                if (maxAvailable >= 0) {
                    // We have a maximum size in this dimension.
                    childSpecMode = .AtMost
                    childSpecSize = maxAvailable
                } else {
                    // We can grow in this dimension. Child can be as big as it
                    // wants.
                    childSpecMode = .Unspecified
                    childSpecSize = 0
                }
            }
        }
        
        return (childSpecSize, childSpecMode)
    }
    
    
    private func positionChildHorizontal(child: UIView, params: ALSLayoutParams, myWidth:CGFloat,
                                         wrapContent: Bool) -> Bool {
        
        let rules = params.getRules(self.layoutDirection)
        
        if (params.left.isNaN && !params.right.isNaN) {
            // Right is fixed, but left varies
            params.left = params.right - params.measuredWidth
        } else if (!params.left.isNaN && params.right.isNaN) {
            // Left is fixed, but right varies
            params.right = params.left + params.measuredWidth
        } else if (params.left.isNaN && params.right.isNaN) {
            // Both left and right vary
            if (rules[ALSRelativeLayout.CENTER_IN_PARENT] != 0 || rules[ALSRelativeLayout.CENTER_HORIZONTAL] != 0) {
                if (!wrapContent) {
                    ALSRelativeLayout.centerHorizontal(child, params: params, myWidth: myWidth)
                } else {
                    params.left = actualLayoutMargins.left + params.marginAbsLeft
                    params.right = params.left + params.measuredWidth
                }
                return true
            } else {
                // This is the default case. For RTL we start from the right and for LTR we start
                // from the left. This will give LEFT/TOP for LTR and RIGHT/TOP for RTL.
                if (layoutDirection == .RightToLeft) {
                    
                    params.right = myWidth - actualLayoutMargins.right - params.marginAbsRight
                    params.left = params.right - params.measuredWidth
                } else {
                    params.left = actualLayoutMargins.left + params.marginAbsLeft
                    params.right = params.left + params.measuredWidth
                }
            }
        }
        return rules[ALSRelativeLayout.ALIGN_PARENT_TRAILING] != 0
    }
    
    
    private func positionChildVertical(child: UIView, params: ALSLayoutParams, myHeight: CGFloat,
                                       wrapContent: Bool) -> Bool {
        
        let rules = params.getRules()
        
        if (params.top.isNaN && !params.bottom.isNaN) {
            // Bottom is fixed, but top varies
            params.top = params.bottom - params.measuredHeight
        } else if (!params.top.isNaN && params.bottom.isNaN) {
            // Top is fixed, but bottom varies
            params.bottom = params.top + params.measuredHeight
        } else if (params.top.isNaN && params.bottom.isNaN) {
            // Both top and bottom vary
            if (rules[ALSRelativeLayout.CENTER_IN_PARENT] != 0 || rules[ALSRelativeLayout.CENTER_VERTICAL] != 0) {
                if (!wrapContent) {
                    ALSRelativeLayout.centerVertical(child, params: params, myHeight: myHeight)
                } else {
                    params.top = actualLayoutMargins.top + params.marginTop
                    params.bottom = params.top + params.measuredHeight
                }
                return true
            } else {
                params.top = actualLayoutMargins.top + params.marginTop
                params.bottom = params.top + params.measuredHeight
            }
        }
        return rules[ALSRelativeLayout.ALIGN_PARENT_BOTTOM] != 0
    }
    
    
    private func applyHorizontalSizeRules(childParams: ALSLayoutParams, myWidth: CGFloat, rules: [Int]) {
        var anchorParams: ALSLayoutParams!
        
        // VALUE_NOT_SET indicates a "soft requirement" in that direction. For example:
        // left=10, right=VALUE_NOT_SET means the view must start at 10, but can go as far as it
        // wants to the right
        // left=VALUE_NOT_SET, right=10 means the view must end at 10, but can go as far as it
        // wants to the left
        // left=10, right=20 means the left and right ends are both fixed
        childParams.left = CGFloat.NaN
        childParams.right = CGFloat.NaN
        
        anchorParams = getRelatedViewParams(rules, relation: ALSRelativeLayout.LEFT_OF)
        if (anchorParams != nil) {
            childParams.right = anchorParams.left - (anchorParams.marginAbsLeft + childParams.marginAbsRight)
        } else if (childParams.alignWithParentIfMissing && rules[ALSRelativeLayout.LEFT_OF] != 0) {
            if (myWidth >= 0) {
                childParams.right = myWidth - actualLayoutMargins.right - childParams.marginAbsRight
            }
        }
        
        anchorParams = getRelatedViewParams(rules, relation: ALSRelativeLayout.RIGHT_OF)
        if (anchorParams != nil) {
            childParams.left = anchorParams.right + (anchorParams.marginAbsRight + childParams.marginAbsLeft)
        } else if (childParams.alignWithParentIfMissing && rules[ALSRelativeLayout.RIGHT_OF] != 0) {
            childParams.left = actualLayoutMargins.left + childParams.marginAbsLeft
        }
        
        anchorParams = getRelatedViewParams(rules, relation: ALSRelativeLayout.ALIGN_LEFT)
        if (anchorParams != nil) {
            childParams.left = anchorParams.left + childParams.marginAbsLeft
        } else if (childParams.alignWithParentIfMissing && rules[ALSRelativeLayout.ALIGN_LEFT] != 0) {
            childParams.left = actualLayoutMargins.left + childParams.marginAbsLeft
        }
        
        anchorParams = getRelatedViewParams(rules, relation: ALSRelativeLayout.ALIGN_RIGHT)
        if (anchorParams != nil) {
            childParams.right = anchorParams.right - childParams.marginAbsRight
        } else if (childParams.alignWithParentIfMissing && rules[ALSRelativeLayout.ALIGN_RIGHT] != 0) {
            if (myWidth >= 0) {
                childParams.right = myWidth - actualLayoutMargins.right - childParams.marginAbsRight
            }
        }
        
        if (0 != rules[ALSRelativeLayout.ALIGN_PARENT_LEFT]) {
            childParams.left = actualLayoutMargins.left + childParams.marginAbsLeft
        }
        
        if (0 != rules[ALSRelativeLayout.ALIGN_PARENT_RIGHT]) {
            if (myWidth >= 0) {
                childParams.right = myWidth - actualLayoutMargins.right - childParams.marginAbsRight
            }
        }
    }
    
    private func applyVerticalSizeRules(childParams: ALSLayoutParams, myHeight: CGFloat, myBaseline: CGFloat) {
        let rules = childParams.getRules()
        
        // Baseline alignment overrides any explicitly specified top or bottom.
        var baselineOffset = getRelatedViewBaselineOffset(rules)
        if (baselineOffset != -1) {
            if (myBaseline != -1) {
                baselineOffset -= myBaseline
            }
            childParams.top = baselineOffset
            childParams.bottom = CGFloat.NaN
            return
        }
        
        var anchorParams: ALSLayoutParams!
        
        childParams.top = CGFloat.NaN
        childParams.bottom = CGFloat.NaN
        
        anchorParams = getRelatedViewParams(rules, relation: ALSRelativeLayout.ABOVE)
        if (anchorParams != nil) {
            childParams.bottom = anchorParams.top - (anchorParams.marginTop + childParams.marginBottom)
        } else if (childParams.alignWithParentIfMissing && rules[ALSRelativeLayout.ABOVE] != 0) {
            if (myHeight >= 0) {
                childParams.bottom = myHeight - actualLayoutMargins.bottom - childParams.marginBottom
            }
        }
        
        anchorParams = getRelatedViewParams(rules, relation: ALSRelativeLayout.BELOW)
        if (anchorParams != nil) {
            childParams.top = anchorParams.bottom + (anchorParams.marginBottom + childParams.marginTop)
        } else if (childParams.alignWithParentIfMissing && rules[ALSRelativeLayout.BELOW] != 0) {
            childParams.top = actualLayoutMargins.top + childParams.marginTop
        }
        
        anchorParams = getRelatedViewParams(rules, relation: ALSRelativeLayout.ALIGN_TOP)
        if (anchorParams != nil) {
            childParams.top = anchorParams.top + childParams.marginTop
        } else if (childParams.alignWithParentIfMissing && rules[ALSRelativeLayout.ALIGN_TOP] != 0) {
            childParams.top = actualLayoutMargins.top + childParams.marginTop
        }
        
        anchorParams = getRelatedViewParams(rules, relation: ALSRelativeLayout.ALIGN_BOTTOM)
        if (anchorParams != nil) {
            childParams.bottom = anchorParams.bottom - childParams.marginBottom
        } else if (childParams.alignWithParentIfMissing && rules[ALSRelativeLayout.ALIGN_BOTTOM] != 0) {
            if (myHeight >= 0) {
                childParams.bottom = myHeight - actualLayoutMargins.bottom - childParams.marginBottom
            }
        }
        
        if (0 != rules[ALSRelativeLayout.ALIGN_PARENT_TOP]) {
            childParams.top = actualLayoutMargins.top + childParams.marginTop
        }
        
        if (0 != rules[ALSRelativeLayout.ALIGN_PARENT_BOTTOM]) {
            if (myHeight >= 0) {
                childParams.bottom = myHeight - actualLayoutMargins.bottom - childParams.marginBottom
            }
        }
    }
    
    
    private func getRelatedView(rules: [Int], relation: Int) -> UIView? {
        var curRules = rules
        let tag = rules[relation]
        if (tag != 0) {
            var node = graph.keyNodes[tag]
            if (node == nil){
                return nil
            }
            var v: UIView = node!.view
            
            // Find the first non-GONE view up the chain
            while (v.layoutParams!.hidden) {
                curRules = v.layoutParams!.getRules(v.layoutDirection)
                node = graph.keyNodes[curRules[relation]]
                if (node == nil) {
                    return nil
                }
                v = node!.view
            }
            
            return v
        }
        
        return nil
    }
    
    private func getRelatedViewParams(rules: [Int], relation: Int) -> ALSLayoutParams? {
        guard let v = getRelatedView(rules, relation: relation) else {
            return nil
        }
        return v.layoutParams
    }
    
    private func getRelatedViewBaselineOffset(rules: [Int]) -> CGFloat {
        guard let v = getRelatedView(rules, relation: ALSRelativeLayout.ALIGN_BASELINE) else {
            return -1
        }
        // TODO return actual value
//        let baseline = v.baseline
//        if (baseline != -1) {
//            let params = v.layoutParams
//            let anchorParams = v.layoutParams
//            return anchorParams.top + baseline
//        }
        return -1
    }
    
    private static func centerHorizontal(child: UIView, params: ALSLayoutParams, myWidth: CGFloat) {
        let childWidth = params.measuredWidth
        let left = (myWidth - childWidth) / 2
        
        params.left = left
        params.right = left + childWidth
    }
    
    private static func centerVertical(child: UIView, params: ALSLayoutParams, myHeight: CGFloat) {
        let childHeight = params.measuredHeight
        let top = (myHeight - childHeight) / 2
        
        params.top = top
        params.bottom = top + childHeight
    }
    
    private static func resolveSize(size: CGFloat, specSize: CGFloat, specMode: ALSLayoutParams.MeasureSpecMode) -> CGFloat {
        switch (specMode) {
        case .AtMost:
            if (specSize < size) {
                return specSize
            } else {
                return size
            }
        case .Exactly:
            return specSize
        case .Unspecified:
            return size
        }
    }
}