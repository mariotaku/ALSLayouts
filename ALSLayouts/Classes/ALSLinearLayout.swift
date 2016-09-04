//
//  ALSLinearLayout.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/4.
//
//

import Foundation

public class ALSLinearLayout: ALSBaseLayout {
    
    /**
     * Don't show any dividers.
     */
    static let SHOW_DIVIDER_NONE = 0
    /**
     * Show a divider at the beginning of the group.
     */
    static let SHOW_DIVIDER_BEGINNING = 1
    /**
     * Show dividers between each item in the group.
     */
    static let SHOW_DIVIDER_MIDDLE = 2
    /**
     * Show a divider at the end of the group.
     */
    static let SHOW_DIVIDER_END = 4
    
    private static let VERTICAL_GRAVITY_COUNT = 4
    
    private static let INDEX_CENTER_VERTICAL = 0
    private static let INDEX_TOP = 1
    private static let INDEX_BOTTOM = 2
    private static let INDEX_FILL = 3
    
    public enum Orientation: String {
        case Horizontal, Vertical
    }
    
    @IBInspectable public var baselineAligned = true
    
    /**
     * If this layout is part of another layout that is baseline aligned,
     * use the child at this index as the baseline.
     *
     *
     * Note: this is orthogonal to [.baselineAligned], which is concerned
     * with whether the children of this layout are baseline aligned.
     */
    @IBInspectable public var baselineAlignedChildIndex = -1
    
    @IBInspectable public var weightSum: CGFloat = 0
    
    /**
     * When set to true, all children with a weight will be considered having
     * the minimum size of the largest child. If false, all children are
     * measured normally.
     *
     * Disabled by default.
     */
    @IBInspectable public var measureWithLargestChild: Bool = false
    
    
    @IBInspectable internal var orientationString: String {
        get { return self.orientation.rawValue }
        set { self.orientation = Orientation(rawValue: newValue)! }
    }
    
    /**
     * Should the layout be a column or a row.
     * Default value is .Horizontal
     */
    public var orientation: ALSLinearLayout.Orientation = .Horizontal
    
    /**
     * The additional offset to the child's baseline.
     * We'll calculate the baseline of this layout as we measure vertically; for
     * horizontal linear layouts, the offset of 0 is appropriate.
     */
    private var baselineChildTop: CGFloat = 0
    
    private var totalLength: CGFloat = 0
    
    private var maxAscent: [CGFloat]!
    private var maxDescent: [CGFloat]!
    
    public var divider: UIImage! = nil {
        didSet {
            if (divider === oldValue) {
                return
            }
            if (divider != nil) {
                dividerSize = self.divider!.size
            } else {
                dividerSize = CGSizeZero
            }
            setNeedsLayout()
        }
    }
    
    public var showDividers: Int = 0
    
    @IBInspectable public var dividerPadding: CGFloat = 0
    
    /**
     * Get the size of the current divider size.
     */
    private(set) var dividerSize: CGSize = CGSizeZero
    
    override func calculateBaselineBottomValue() -> CGFloat {
        if (baselineAlignedChildIndex < 0) {
            return CGFloat.NaN
        }
        
        if (subviews.count <= baselineAlignedChildIndex) {
            fatalError("baselineAlignedChildIndex of LinearLayout set to an index that is out of bounds.")
        }
        
        let child = subviews[baselineAlignedChildIndex]
        let childBaseline = child.baselineBottomValue
        
        if (childBaseline.isNaN) {
            if (baselineAlignedChildIndex == 0) {
                // this is just the default case, safe to return -1
                return CGFloat.NaN
            }
            // the user picked an index that points to something that doesn't
            // know how to calculate its baseline.
            fatalError("baselineAlignedChildIndex of LinearLayout points to a View that doesn't know how to get its baseline.")
        }
        
        // TODO: This should try to take into account the virtual offsets
        // (See getNextLocationOffset and getLocationOffset)
        // We should add to childTop:
        // sum([getNextLocationOffset(getChildAt(i)) / i < mBaselineAlignedChildIndex])
        // and also add:
        // getLocationOffset(child)
        var childTop = baselineChildTop
        
        if (orientation == .Vertical) {
            let majorGravity = gravity & ALSGravity.VERTICAL_GRAVITY_MASK
            if (majorGravity != ALSGravity.TOP) {
                switch (majorGravity) {
                case ALSGravity.BOTTOM:
                    childTop = frame.bottom - frame.top - actualLayoutMargins.bottom - totalLength
                case ALSGravity.CENTER_VERTICAL:
                    childTop += (frame.bottom - frame.top - actualLayoutMargins.top - actualLayoutMargins.bottom - totalLength) / 2
                default: break
                }
            }
        }
        
        let lp = child.layoutParams
        return childTop + lp.marginTop + childBaseline
    }
    
    override func measureSubviews(size: CGSize) -> CGSize {
        let widthSpec: ALSLayoutParams.MeasureSpecMode = layoutParamsOrNull?.measuredWidthSpec ?? .Exactly
        let heightSpec: ALSLayoutParams.MeasureSpecMode = layoutParamsOrNull?.measuredHeightSpec ?? .Exactly
        
        var widthMeasureSpec: ALSLayoutParams.MeasureSpec = (size.width, widthSpec)
        var heightMeasureSpec: ALSLayoutParams.MeasureSpec = (size.height, heightSpec)
        if (orientation == .Vertical) {
            return measureVertical(widthMeasureSpec, heightMeasureSpec)
        } else {
            return measureHorizontal(widthMeasureSpec, heightMeasureSpec)
        }
    }
    
    public override func layoutSubviews() {
        self.frame.size = measureSubviews(self.bounds.size)
        
        if (orientation == .Vertical) {
            return layoutVertical(self.frame)
        } else {
            return layoutHorizontal(self.frame)
        }
    }
    
    override func initLayoutParams(view: UIView, newParams: ALSLayoutParams) {
        // LinarLayout.LayoutParams' default gravity is -1
        newParams.gravity = -1
    }
    
    /**
     * Measures the children when the orientation of this LinearLayout is set
     * to [Orientation.VERTICAL].
     
     * @param widthMeasureSpec  Horizontal space requirements as imposed by the parent.
     * *
     * @param heightMeasureSpec Vertical space requirements as imposed by the parent.
     * *
     * @see .orientation
     
     * @see .onMeasure
     */
    internal func measureVertical(widthMeasureSpec: ALSLayoutParams.MeasureSpec, _ heightMeasureSpec: ALSLayoutParams.MeasureSpec) -> CGSize {
        self.totalLength = 0
        
        var maxWidth: CGFloat = 0
        var childState: ALSLayoutParams.MeasureStates = (.Unspecified, .Unspecified)
        var alternativeMaxWidth: CGFloat = 0
        var weightedMaxWidth: CGFloat = 0
        var allFillParent = true
        var totalWeight: CGFloat = 0
        
        let count = virtualChildCount
        
        let widthSpec: ALSLayoutParams.MeasureSpecMode = layoutParamsOrNull?.measuredWidthSpec ?? .Exactly
        let heightSpec: ALSLayoutParams.MeasureSpecMode = layoutParamsOrNull?.measuredHeightSpec ?? .Exactly
        
        var matchWidth = false
        var skippedMeasure = false
        
        let baselineChildIndex = baselineAlignedChildIndex
        let useLargestChild = self.measureWithLargestChild
        
        var largestChildHeight: CGFloat = CGFloat.min
        var consumedExcessSpace: CGFloat = 0
        
        let layoutDirection = self.layoutDirection
        
        for var i = 0; i < count; i++ {
            guard let child = getVirtualChildAt(i) else {
                totalLength += measureNullChild(i)
                continue
            }
            
            let lp = child.layoutParams
            
            lp.resolveLayoutDirection(layoutDirection)
            
            if (lp.hidden) {
                i += getChildrenSkipCount(child, index: i)
                continue
            }
            
            if (hasDividerBeforeChildAt(i)) {
                self.totalLength += dividerSize.height
            }
            
            totalWeight += lp.weight
            
            let useExcessSpace = lp.height == 0 && lp.weight > 0
            if (heightSpec == .Exactly && useExcessSpace) {
                // Optimization: don't bother measuring children who are only
                // laid out using excess space. These views will get measured
                // later if we have space to distribute.
                let totalLength = self.totalLength
                self.totalLength = max(totalLength, totalLength + lp.marginTop + lp.marginBottom)
                skippedMeasure = true
            } else {
                if (useExcessSpace) {
                    // The heightMode is either UNSPECIFIED or AT_MOST, and
                    // this child is only laid out using excess space. Measure
                    // using WRAP_CONTENT so that we can find out the view's
                    // optimal height. We'll restore the original height of 0
                    // after measurement.
                    lp.heightMode = .WrapContent
                }
                
                // Determine how big this child would like to be. If this or
                // previous children have given a weight, then we allow it to
                // use all available space (and we will shrink things later
                // if needed).
                let usedHeight = totalWeight.isZero ? self.totalLength : 0
                measureChildBeforeLayout(child, childIndex: i, widthMeasureSpec: widthMeasureSpec, totalWidth: 0, heightMeasureSpec: heightMeasureSpec, totalHeight: usedHeight)
                
                let childHeight = lp.measuredHeight
                if (useExcessSpace) {
                    // Restore the original height and record how much space
                    // we've allocated to excess-only children so that we can
                    // match the behavior of EXACTLY measurement.
                    lp.height = 0
                    consumedExcessSpace += childHeight
                }
                
                let total = self.totalLength
                self.totalLength = max(total, total + childHeight + lp.marginTop + lp.marginBottom + getNextLocationOffset(child))
                
                if (useLargestChild) {
                    largestChildHeight = max(childHeight, largestChildHeight)
                }
            }
            
            /**
             * If applicable, compute the additional offset to the child's baseline
             * we'll need later when asked [.getBaseline].
             */
            if (baselineChildIndex >= 0 && baselineChildIndex == i + 1) {
                baselineChildTop = totalLength
            }
            
            // if we are trying to use a child index for our baseline, the above
            // book keeping only works if there are no children above it with
            // weight.  fail fast to aid the developer.
            if (i < baselineChildIndex && lp.weight > 0) {
                fatalError("A child of LinearLayout with index "
                    + "less than mBaselineAlignedChildIndex has weight > 0, which "
                    + "won't work.  Either remove the weight, or don't set "
                    + "mBaselineAlignedChildIndex.")
            }
            
            var matchWidthLocally = false
            if (widthSpec != .Exactly && lp.widthMode == .MatchParent) {
                // The width of the linear layout will scale, and at least one
                // child said it wanted to match our width. Set a flag
                // indicating that we need to remeasure at least that view when
                // we know our width.
                matchWidth = true
                matchWidthLocally = true
            }
            
            let margin = lp.marginAbsLeft + lp.marginAbsRight
            let measuredWidth = lp.measuredWidth + margin
            maxWidth = max(maxWidth, measuredWidth)
            childState = ALSBaseLayout.combineMeasuredStates(childState, widthMode: lp.measuredWidthSpec, heightMode: lp.measuredHeightSpec)
            
            allFillParent = allFillParent && lp.widthMode == .MatchParent
            if (lp.weight > 0) {
                /*
                 * Widths of weighted Views are bogus if we end up
                 * remeasuring, so keep them separate.
                 */
                weightedMaxWidth = max(weightedMaxWidth, matchWidthLocally ? margin : measuredWidth)
            } else {
                alternativeMaxWidth = max(alternativeMaxWidth, matchWidthLocally ? margin : measuredWidth)
            }
            
            i += getChildrenSkipCount(child, index: i)
        }
        
        if (totalLength > 0 && hasDividerBeforeChildAt(count)) {
            totalLength += dividerSize.height
        }
        
        if (useLargestChild && (heightSpec == .AtMost || heightSpec == .Unspecified)) {
            totalLength = 0
            
            for var i = 0; i < count; i++ {
                guard let child = getVirtualChildAt(i) else {
                    self.totalLength += measureNullChild(i)
                    continue
                }
                
                let lp = child.layoutParams
                
                if (lp.hidden) {
                    i += getChildrenSkipCount(child, index: i)
                    continue
                }
                // Account for negative margins
                let totalLength = self.totalLength
                self.totalLength = max(totalLength, totalLength + largestChildHeight +
                    lp.marginTop + lp.marginBottom + getNextLocationOffset(child))
            }
        }
        
        // Add in our padding
        totalLength += actualLayoutMargins.top + actualLayoutMargins.bottom
        
        var heightSize = totalLength
        
        // Check against our minimum height
        let suggestedMinimumHeight: CGFloat = 0
        heightSize = max(heightSize, suggestedMinimumHeight)
        
        // Reconcile our calculated size with the heightMeasureSpec
        let heightSizeAndState: ALSLayoutParams.MeasureSpec = ALSBaseLayout.resolveSizeAndState(heightSize, measureSpec: heightMeasureSpec, childMeasuredState: .Unspecified)
        heightSize = heightSizeAndState.0
        
        // Either expand children with weight to take up available space or
        // shrink them if they extend beyond our current bounds. If we skipped
        // measurement on any children, we need to measure them now.
        var remainingExcess = heightSize - totalLength + consumedExcessSpace
        if (skippedMeasure || remainingExcess != 0 && totalWeight > 0) {
            var remainingWeightSum = weightSum > 0 ? weightSum : totalWeight
            
            totalLength = 0
            
            for var i = 0; i < count; i++ {
                guard let child = getVirtualChildAt(i) else {
                    continue
                }
                let lp = child.layoutParams
                if (lp.hidden) {
                    continue
                }
                
                let childWeight = lp.weight
                if (childWeight > 0) {
                    let share = (childWeight * remainingExcess / remainingWeightSum)
                    remainingExcess -= share
                    remainingWeightSum -= childWeight
                    
                    let childHeight: CGFloat
                    if (self.measureWithLargestChild && heightSpec != .Exactly) {
                        childHeight = largestChildHeight
                    } else if (lp.height == 0) {
                        // This child needs to be laid out from scratch using
                        // only its share of excess space.
                        childHeight = share
                    } else {
                        // This child had some intrinsic height to which we
                        // need to add its share of excess space.
                        childHeight = lp.measuredHeight + share
                    }
                    
                    let childHeightMeasureSpec: ALSLayoutParams.MeasureSpec = (max(0, childHeight), .Exactly)
                    let childWidthMeasureSpec = ALSBaseLayout.getChildMeasureSpec(widthMeasureSpec, padding: actualLayoutMargins.left + actualLayoutMargins.right + lp.marginAbsLeft + lp.marginAbsRight, childDimension: lp.width, childDimensionMode: lp.widthMode)
                    
                    child.measure(childWidthMeasureSpec, childHeightMeasureSpec)
                    
                    // Child may now not fit in vertical dimension.
                    childState = ALSBaseLayout.combineMeasuredStates(childState, widthMode: .Unspecified, heightMode: lp.measuredHeightSpec)
                }
                
                let margin = lp.marginAbsLeft + lp.marginAbsRight
                let measuredWidth = lp.measuredWidth + margin
                maxWidth = max(maxWidth, measuredWidth)
                
                let matchWidthLocally = widthSpec != .Exactly && lp.widthMode == .MatchParent
                
                alternativeMaxWidth = max(alternativeMaxWidth, matchWidthLocally ? margin : measuredWidth)
                
                allFillParent = allFillParent && lp.widthMode == .MatchParent
                
                let totalLength = self.totalLength
                self.totalLength = max(totalLength, totalLength + lp.measuredHeight + lp.marginTop + lp.marginBottom + getNextLocationOffset(child))
            }
            
            // Add in our padding
            totalLength += actualLayoutMargins.top + actualLayoutMargins.bottom
            // TODO: Should we recompute the heightSpec based on the new total length?
        } else {
            alternativeMaxWidth = max(alternativeMaxWidth, weightedMaxWidth)
            
            
            // We have no limit, so make all weighted views as tall as the largest child.
            // Children will have already been measured once.
            if (useLargestChild && heightSpec != .Exactly) {
                for var i = 0; i < count; i++ {
                    guard let child = getVirtualChildAt(i) where !child.layoutHidden else {
                        continue
                    }
                    let lp = child.layoutParams
                    
                    let childExtra = lp.weight
                    if (childExtra > 0) {
                        lp.measure(child, widthSpec: (lp.measuredWidth, .Exactly), heightSpec: (largestChildHeight, .Exactly))
                    }
                }
            }
        }
        
        if (!allFillParent && widthSpec != .Exactly) {
            maxWidth = alternativeMaxWidth
        }
        
        maxWidth += actualLayoutMargins.left + actualLayoutMargins.right
        
        // Check against our minimum width
        let suggestedMinimumWidth: CGFloat = 0
        maxWidth = max(maxWidth, suggestedMinimumWidth)
        
        let finalSize = ALSBaseLayout.resolveSizeAndState(maxWidth, measureSpec: widthMeasureSpec, childMeasuredState: childState.0)
        
        if (matchWidth) {
            forceUniformWidth(count, heightMeasureSpec: heightMeasureSpec)
        }
        
        if (heightMode == .WrapContent) {
            return CGSizeMake(finalSize.0, self.totalLength)
        } else {
            return CGSizeMake(finalSize.0, heightSizeAndState.0)
        }
    }
    
    internal func measureHorizontal(widthMeasureSpec: ALSLayoutParams.MeasureSpec, _ heightMeasureSpec: ALSLayoutParams.MeasureSpec) -> CGSize {
        totalLength = 0
        var maxHeight: CGFloat = 0
        var childState: ALSLayoutParams.MeasureStates = (.Unspecified, .Unspecified)
        var alternativeMaxHeight: CGFloat = 0
        var weightedMaxHeight: CGFloat = 0
        var allFillParent = true
        var totalWeight: CGFloat = 0
        
        let count = virtualChildCount
        
        let widthSpec = widthMeasureSpec.1
        let heightSpec = heightMeasureSpec.1
        
        var matchHeight = false
        var skippedMeasure = false
        
        if (self.maxAscent == nil || self.maxDescent == nil) {
            self.maxAscent = [CGFloat](count: ALSLinearLayout.VERTICAL_GRAVITY_COUNT, repeatedValue: CGFloat.NaN)
            self.maxDescent = [CGFloat](count: ALSLinearLayout.VERTICAL_GRAVITY_COUNT, repeatedValue: CGFloat.NaN)
        }
        
        var maxAscent = self.maxAscent!
        var maxDescent = self.maxDescent!
        
        for i in 0..<ALSLinearLayout.VERTICAL_GRAVITY_COUNT {
            maxAscent[i] = CGFloat.NaN
            maxDescent[i] = CGFloat.NaN
        }
        
        let baselineAligned = self.baselineAligned
        let useLargestChild = self.measureWithLargestChild
        
        let isExactly = widthSpec == .Exactly
        
        var largestChildWidth: CGFloat = CGFloat.min
        var usedExcessSpace: CGFloat = 0
        
        let layoutDirection = self.layoutDirection
        
        // See how wide everyone is. Also remember max height.
        
        for var i = 0; i < count; i++ {
            guard let child = getVirtualChildAt(i) else {
                totalLength += measureNullChild(i)
                continue
            }
            let lp = child.layoutParams
            
            lp.resolveLayoutDirection(layoutDirection)
            
            if (lp.hidden) {
                i += getChildrenSkipCount(child, index: i)
                continue
            }
            
            if (hasDividerBeforeChildAt(i)) {
                totalLength += dividerSize.width
            }
            
            
            totalWeight += lp.weight
            
            let useExcessSpace = lp.width == 0 && lp.weight > 0
            if (widthSpec == .Exactly && useExcessSpace) {
                // Optimization: don't bother measuring children who are only
                // laid out using excess space. These views will get measured
                // later if we have space to distribute.
                if (isExactly) {
                    self.totalLength += lp.marginAbsLeft + lp.marginAbsRight
                } else {
                    let total = self.totalLength
                    self.totalLength = max(total, total + lp.marginAbsLeft + lp.marginAbsRight)
                }
                
                // Baseline alignment requires to measure widgets to obtain the
                // baseline offset (in particular for TextViews). The following
                // defeats the optimization mentioned above. Allow the child to
                // use as much space as it wants because we can shrink things
                // later (and re-measure).
                if (baselineAligned) {
                    let freeWidthSpec: ALSLayoutParams.MeasureSpec = (widthMeasureSpec.0, .Unspecified)
                    let freeHeightSpec: ALSLayoutParams.MeasureSpec = (heightMeasureSpec.0, .Unspecified)
                    child.measure(freeWidthSpec, freeHeightSpec)
                } else {
                    skippedMeasure = true
                }
            } else {
                if (useExcessSpace) {
                    // The widthMode is either UNSPECIFIED or AT_MOST, and
                    // this child is only laid out using excess space. Measure
                    // using WRAP_CONTENT so that we can find out the view's
                    // optimal width. We'll restore the original width of 0
                    // after measurement.
                    lp.widthMode = .WrapContent
                }
                
                // Determine how big this child would like to be. If this or
                // previous children have given a weight, then we allow it to
                // use all available space (and we will shrink things later
                // if needed).
                let usedWidth = totalWeight.isZero ? totalLength : 0
                measureChildBeforeLayout(child, childIndex: i, widthMeasureSpec: widthMeasureSpec, totalWidth: usedWidth, heightMeasureSpec: heightMeasureSpec, totalHeight: 0)
                
                let childWidth = lp.measuredWidth
                if (useExcessSpace) {
                    // Restore the original width and record how much space
                    // we've allocated to excess-only children so that we can
                    // match the behavior of EXACTLY measurement.
                    lp.width = 0
                    usedExcessSpace += childWidth
                }
                
                if (isExactly) {
                    totalLength += childWidth + lp.marginAbsLeft + lp.marginAbsRight
                    +getNextLocationOffset(child)
                } else {
                    let total = self.totalLength
                    self.totalLength = max(total, total + childWidth + lp.marginAbsLeft + lp.marginAbsRight + getNextLocationOffset(child))
                }
                
                if (useLargestChild) {
                    largestChildWidth = max(childWidth, largestChildWidth)
                }
            }
            
            var matchHeightLocally = false
            if (heightSpec != .Exactly && lp.heightMode == .MatchParent) {
                // The height of the linear layout will scale, and at least one
                // child said it wanted to match our height. Set a flag indicating that
                // we need to remeasure at least that view when we know our height.
                matchHeight = true
                matchHeightLocally = true
            }
            
            let margin = lp.marginTop + lp.marginBottom
            let childHeight = lp.measuredHeight + margin
            childState = ALSBaseLayout.combineMeasuredStates(childState, widthMode: lp.measuredWidthSpec, heightMode: lp.measuredHeightSpec)
            
            if (baselineAligned) {
                let childBaseline = child.baselineBottomValue
                if (childBaseline != -1) {
                    // Translates the child's vertical gravity into an index
                    // in the range 0..VERTICAL_GRAVITY_COUNT
                    let gravity = (lp.gravity < 0 ? self.gravity : lp.gravity) & ALSGravity.VERTICAL_GRAVITY_MASK
                    let index = gravity >> ALSGravity.AXIS_Y_SHIFT & ~ALSGravity.AXIS_SPECIFIED >> 1
                    
                    maxAscent[index] = max(maxAscent[index], childBaseline)
                    maxDescent[index] = max(maxDescent[index], childHeight - childBaseline)
                }
            }
            
            maxHeight = max(maxHeight, childHeight)
            
            allFillParent = allFillParent && lp.heightMode == .MatchParent
            if (lp.weight > 0) {
                /*
                 * Heights of weighted Views are bogus if we end up
                 * remeasuring, so keep them separate.
                 */
                weightedMaxHeight = max(weightedMaxHeight, matchHeightLocally ? margin : childHeight)
            } else {
                alternativeMaxHeight = max(alternativeMaxHeight, matchHeightLocally ? margin : childHeight)
            }
            
            i += getChildrenSkipCount(child, index: i)
        }
        
        if (totalLength > 0 && hasDividerBeforeChildAt(count)) {
            totalLength += dividerSize.width
        }
        
        // Check mMaxAscent[INDEX_TOP] first because it maps to Gravity.TOP,
        // the most common case
        if (maxAscent[ALSLinearLayout.INDEX_TOP] != -1 || maxAscent[ALSLinearLayout.INDEX_CENTER_VERTICAL] != -1 || maxAscent[ALSLinearLayout.INDEX_BOTTOM] != -1 || maxAscent[ALSLinearLayout.INDEX_FILL] != -1) {
            let ascent = max(maxAscent[ALSLinearLayout.INDEX_FILL], max(maxAscent[ALSLinearLayout.INDEX_CENTER_VERTICAL], max(maxAscent[ALSLinearLayout.INDEX_TOP], maxAscent[ALSLinearLayout.INDEX_BOTTOM])))
            let descent = max(maxDescent[ALSLinearLayout.INDEX_FILL], max(maxDescent[ALSLinearLayout.INDEX_CENTER_VERTICAL], max(maxDescent[ALSLinearLayout.INDEX_TOP], maxDescent[ALSLinearLayout.INDEX_BOTTOM])))
            maxHeight = max(maxHeight, ascent + descent)
        }
        
        if (useLargestChild && (widthSpec == .AtMost || widthSpec == .Unspecified)) {
            totalLength = 0
            
            for var i = 0; i < count; i++ {
                guard let child = getVirtualChildAt(i) else {
                    totalLength += measureNullChild(i)
                    continue
                }
                
                let lp = child.layoutParams
                
                if (lp.hidden) {
                    i += getChildrenSkipCount(child, index: i)
                    continue
                }
                
                if (isExactly) {
                    self.totalLength += largestChildWidth + lp.marginAbsLeft + lp.marginAbsRight + getNextLocationOffset(child)
                } else {
                    let total = self.totalLength
                    self.totalLength = max(total, total + largestChildWidth + lp.marginAbsLeft + lp.marginAbsRight + getNextLocationOffset(child))
                }
            }
        }
        
        // Add in our padding
        totalLength += actualLayoutMargins.left + actualLayoutMargins.right
        
        var widthSize = totalLength
        
        // Check against our minimum width
        let suggestedMinimumWidth: CGFloat = 0
        widthSize = max(widthSize, suggestedMinimumWidth)
        
        // Reconcile our calculated size with the widthMeasureSpec
        let widthSizeAndState = ALSBaseLayout.resolveSizeAndState(widthSize, measureSpec: widthMeasureSpec, childMeasuredState: .Unspecified)
        widthSize = widthSizeAndState.0
        
        // Either expand children with weight to take up available space or
        // shrink them if they extend beyond our current bounds. If we skipped
        // measurement on any children, we need to measure them now.
        var remainingExcess = widthSize - totalLength + usedExcessSpace
        if (skippedMeasure || !remainingExcess.isZero && totalWeight > 0) {
            var remainingWeightSum = weightSum > 0 ? weightSum : totalWeight

            for i in 0..<ALSLinearLayout.VERTICAL_GRAVITY_COUNT {
                maxAscent[i] = CGFloat.NaN
                maxDescent[i] = CGFloat.NaN
            }
            
            maxHeight = -1
            
            totalLength = 0
            
            for var i = 0; i < count; i++ {
                guard let child = getVirtualChildAt(i) where !child.layoutHidden else {
                    continue
                }
                
                let lp = child.layoutParams
                let childWeight = lp.weight
                if (childWeight > 0) {
                    let share = childWeight * remainingExcess / remainingWeightSum
                    remainingExcess -= share
                    remainingWeightSum -= childWeight
                    
                    let childWidth: CGFloat
                    if (self.measureWithLargestChild && widthSpec != .Exactly) {
                        childWidth = largestChildWidth
                    } else if (lp.width == 0) {
                        // This child needs to be laid out from scratch using
                        // only its share of excess space.
                        childWidth = share
                    } else {
                        // This child had some intrinsic width to which we
                        // need to add its share of excess space.
                        childWidth = lp.measuredWidth + share
                    }
                    
                    let childWidthMeasureSpec: ALSLayoutParams.MeasureSpec = (max(0, childWidth), .Exactly)
                    let childHeightMeasureSpec = ALSBaseLayout.getChildMeasureSpec(heightMeasureSpec, padding: actualLayoutMargins.top + actualLayoutMargins.bottom + lp.marginTop + lp.marginBottom, childDimension: lp.height, childDimensionMode: lp.heightMode)
                    child.measure(childWidthMeasureSpec, childHeightMeasureSpec)
                    
                    // Child may now not fit in horizontal dimension.
                    childState = ALSBaseLayout.combineMeasuredStates(childState, widthMode: lp.measuredWidthSpec, heightMode: .Unspecified)
                }
                
                if (isExactly) {
                    totalLength += lp.measuredWidth + lp.marginAbsLeft + lp.marginAbsRight +
                        getNextLocationOffset(child)
                } else {
                    let total = self.totalLength
                    self.totalLength = max(total, total + lp.measuredWidth + lp.marginAbsLeft + lp.marginAbsRight + getNextLocationOffset(child))
                }
                
                let matchHeightLocally = heightSpec != .Exactly && lp.heightMode == .MatchParent
                
                let margin = lp.marginTop + lp.marginBottom
                let childHeight = lp.measuredHeight + margin
                maxHeight = max(maxHeight, childHeight)
                alternativeMaxHeight = max(alternativeMaxHeight, matchHeightLocally ? margin : childHeight)
                
                allFillParent = allFillParent && lp.heightMode == .MatchParent
                
                if (baselineAligned) {
                    let childBaseline = child.baselineBottomValue
                    if (childBaseline != -1) {
                        // Translates the child's vertical gravity into an index in the range 0..2
                        let gravity = (lp.gravity < 0 ? self.gravity : lp.gravity) & ALSGravity.VERTICAL_GRAVITY_MASK
                        let index = gravity >> ALSGravity.AXIS_Y_SHIFT & ~ALSGravity.AXIS_SPECIFIED >> 1
                        
                        maxAscent[index] = max(maxAscent[index], childBaseline)
                        maxDescent[index] = max(maxDescent[index], childHeight - childBaseline)
                    }
                }
            }
            
            // Add in our padding
            totalLength += actualLayoutMargins.left + actualLayoutMargins.right
            // TODO: Should we update widthSize with the new total length?
            
            // Check mMaxAscent[INDEX_TOP] first because it maps to Gravity.TOP,
            // the most common case
            if (maxAscent[ALSLinearLayout.INDEX_TOP] != -1 || maxAscent[ALSLinearLayout.INDEX_CENTER_VERTICAL] != -1 || maxAscent[ALSLinearLayout.INDEX_BOTTOM] != -1 || maxAscent[ALSLinearLayout.INDEX_FILL] != -1) {
                let ascent = max(maxAscent[ALSLinearLayout.INDEX_FILL], max(maxAscent[ALSLinearLayout.INDEX_CENTER_VERTICAL], max(maxAscent[ALSLinearLayout.INDEX_TOP], maxAscent[ALSLinearLayout.INDEX_BOTTOM])))
                let descent = max(maxDescent[ALSLinearLayout.INDEX_FILL], max(maxDescent[ALSLinearLayout.INDEX_CENTER_VERTICAL], max(maxDescent[ALSLinearLayout.INDEX_TOP], maxDescent[ALSLinearLayout.INDEX_BOTTOM])))
                maxHeight = max(maxHeight, ascent + descent)
            }
        } else {
            alternativeMaxHeight = max(alternativeMaxHeight, weightedMaxHeight)
            
            // We have no limit, so make all weighted views as wide as the largest child.
            // Children will have already been measured once.
            if (useLargestChild && widthSpec != .Exactly) {
                for var i = 0; i < count; i++ {
                    guard let child = getVirtualChildAt(i) where !child.layoutHidden else {
                        continue
                    }
                    
                    let lp = child.layoutParams
                    
                    let childExtra = lp.weight
                    if (childExtra > 0) {
                        child.measure((largestChildWidth, .Exactly), (lp.measuredHeight, .Exactly))
                    }
                }
            }
        }
        
        if (!allFillParent && heightSpec != .Exactly) {
            maxHeight = alternativeMaxHeight
        }
        
        maxHeight += actualLayoutMargins.top + actualLayoutMargins.bottom
        
        // Check against our minimum height
        let suggestedMinimumHeight: CGFloat = 0
        maxHeight = max(maxHeight, suggestedMinimumHeight)
        
        let finalSize = ALSBaseLayout.resolveSizeAndState(maxHeight, measureSpec: heightMeasureSpec, childMeasuredState: childState.1)
        if (matchHeight) {
            forceUniformHeight(count, widthMeasureSpec: widthMeasureSpec)
        }
        
        if (widthMode == .WrapContent) {
            return CGSizeMake(self.totalLength, finalSize.0)
        } else {
            return CGSizeMake(widthSizeAndState.0, finalSize.0)
        }
    }
    
    
    
    /**
     * Position the children during a layout pass if the orientation of this
     * LinearLayout is set to [Orientation.VERTICAL].
     
     * @param left
     * *
     * @param top
     * *
     * @param right
     * *
     * @param bottom
     * *
     * @see .orientation
     
     * @see .onLayout
     */
    internal func layoutVertical(frame: CGRect) {
        
        let layoutDirection = self.layoutDirection
        let paddingLeft = actualLayoutMargins.left
        
        var childTop: CGFloat
        var childLeft: CGFloat
        
        // Where right end of child should go
        let width = frame.right - frame.left
        let childRight = width - actualLayoutMargins.right
        
        // Space available for child
        let childSpace = width - paddingLeft - actualLayoutMargins.right
        
        let count = virtualChildCount
        
        let majorGravity = gravity & ALSGravity.VERTICAL_GRAVITY_MASK
        let minorGravity = gravity & ALSGravity.RELATIVE_HORIZONTAL_GRAVITY_MASK
        
        switch (majorGravity) {
        case ALSGravity.BOTTOM:
            // mTotalLength contains the padding already
            childTop = actualLayoutMargins.top + frame.bottom - frame.top - totalLength
            // mTotalLength contains the padding already
        case ALSGravity.CENTER_VERTICAL:
            childTop = actualLayoutMargins.top + (frame.bottom - frame.top - totalLength) / 2
        default:
            childTop = actualLayoutMargins.top
        }
        
        for var i = 0; i < count; i++ {
            guard let child = getVirtualChildAt(i) else {
                childTop += measureNullChild(i)
                continue
            }
            
            let lp = child.layoutParams
            
            if (!lp.hidden) {
                let childWidth = lp.measuredWidth
                let childHeight = lp.measuredHeight

                var gravity = lp.gravity
                if (gravity < 0) {
                    gravity = minorGravity
                }
                let absoluteGravity = ALSGravity.getAbsoluteGravity(gravity, layoutDirection: layoutDirection)
                switch (absoluteGravity & ALSGravity.HORIZONTAL_GRAVITY_MASK) {
                case ALSGravity.CENTER_HORIZONTAL:
                    childLeft = paddingLeft + (childSpace - childWidth) / 2 + lp.marginAbsLeft - lp.marginAbsRight
                case ALSGravity.RIGHT:
                    childLeft = childRight - childWidth - lp.marginAbsRight
                default:
                    childLeft = paddingLeft + lp.marginAbsLeft
                }
                
                if (hasDividerBeforeChildAt(i)) {
                    childTop += dividerSize.height
                }
                
                childTop += lp.marginTop
                child.frame = CGRectMake(childLeft, childTop + getLocationOffset(child), childWidth, childHeight)
                childTop += childHeight + lp.marginBottom + getNextLocationOffset(child)
                
                i += getChildrenSkipCount(child, index: i)
            } else {
                child.frame = CGRectZero
            }
        }
    }
    
    /**
     * Position the children during a layout pass if the orientation of this
     * LinearLayout is set to [Orientation.HORIZONTAL].
     
     * @param left
     * *
     * @param top
     * *
     * @param right
     * *
     * @param bottom
     * *
     * @see .orientation
     
     * @see .onLayout
     */
    internal func layoutHorizontal(frame: CGRect) {
        let layoutDirection = self.layoutDirection
        let isLayoutRtl = layoutDirection == .RightToLeft
        
        let paddingTop = actualLayoutMargins.top
        
        var childTop: CGFloat
        var childLeft: CGFloat
        
        // Where bottom of child should go
        let height = frame.height
        let childBottom = height - actualLayoutMargins.bottom
        
        // Space available for child
        let childSpace = height - paddingTop - actualLayoutMargins.bottom
        
        let count = virtualChildCount
        
        let majorGravity = gravity & ALSGravity.RELATIVE_HORIZONTAL_GRAVITY_MASK
        let minorGravity = gravity & ALSGravity.VERTICAL_GRAVITY_MASK
        
        let baselineAligned = self.baselineAligned
        
        let maxAscent = self.maxAscent!
        let maxDescent = self.maxDescent!
        
        
        switch (ALSGravity.getAbsoluteGravity(majorGravity, layoutDirection: layoutDirection)) {
        case ALSGravity.RIGHT:
            // mTotalLength contains the padding already
            childLeft = actualLayoutMargins.left + frame.right - frame.left - totalLength
        case ALSGravity.CENTER_HORIZONTAL:
            // mTotalLength contains the padding already
            childLeft = actualLayoutMargins.left + (frame.right - frame.left - totalLength) / 2
        default:
            childLeft = actualLayoutMargins.left
        }
        
        var start = 0
        var dir = 1
        //In case of RTL, start drawing from the last child.
        if (isLayoutRtl) {
            start = count - 1
            dir = -1
        }
        
        for var i = 0; i < count; i++ {
            let childIndex = start + dir * i
            guard let child = getVirtualChildAt(childIndex) else {
                childLeft += measureNullChild(childIndex)
                continue
            }
            
            let lp = child.layoutParams
            
            if (!lp.hidden) {
                let childWidth = lp.measuredWidth
                let childHeight = lp.measuredHeight
                var childBaseline: CGFloat = CGFloat.NaN
                
                if (baselineAligned && lp.heightMode != .MatchParent) {
                    childBaseline = child.baselineBottomValue
                }
                
                var gravity = lp.gravity
                if (gravity < 0) {
                    gravity = minorGravity
                }
                
                switch (gravity & ALSGravity.VERTICAL_GRAVITY_MASK) {
                case ALSGravity.TOP:
                    childTop = paddingTop + lp.marginTop
                    if (!childBaseline.isNaN) {
                        childTop += maxAscent[ALSLinearLayout.INDEX_TOP] - childBaseline
                    }
                case ALSGravity.CENTER_VERTICAL:
                    // Removed support for baseline alignment when layout_gravity or
                    // gravity == center_vertical. See bug #1038483.
                    // Keep the code around if we need to re-enable this feature
                    // if (childBaseline != -1) {
                    //     // Align baselines vertically only if the child is smaller than us
                    //     if (childSpace - childHeight > 0) {
                    //         childTop = paddingTop + (childSpace / 2) - childBaseline;
                    //     } else {
                    //         childTop = paddingTop + (childSpace - childHeight) / 2;
                    //     }
                    // } else {
                    childTop = paddingTop + (childSpace - childHeight) / 2 + lp.marginTop - lp.marginBottom
                case ALSGravity.BOTTOM:
                    childTop = childBottom - childHeight - lp.marginBottom
                    if (childBaseline != -1) {
                        let descent = lp.measuredHeight - childBaseline
                        childTop -= maxDescent[ALSLinearLayout.INDEX_BOTTOM] - descent
                    }
                default:
                    childTop = paddingTop
                }
                
                if (hasDividerBeforeChildAt(childIndex)) {
                    childLeft += dividerSize.width
                }
                
                childLeft += lp.marginAbsLeft
                child.frame = CGRectMake(childLeft + getLocationOffset(child), childTop, childWidth, childHeight)
                childLeft += childWidth + lp.marginAbsRight + getNextLocationOffset(child)
                
                i += getChildrenSkipCount(child, index: childIndex)
            } else {
                child.frame = CGRectZero
            }
        }
    }
    
    internal func getVirtualChildAt(index: Int) -> UIView! {
        return subviews[index]
    }
    
    internal var virtualChildCount: Int {
        return subviews.count
    }
    
    /**
     * Determines where to position dividers between children.
     
     * @param childIndex Index of child to check for preceding divider
     * *
     * @return true if there should be a divider before the child at childIndex
     * *
     * @hide Pending API consideration. Currently only used internally by the system.
     */
    internal func hasDividerBeforeChildAt(childIndex: Int) -> Bool {
        if (childIndex == virtualChildCount) {
            // Check whether the end divider should draw.
            return showDividers & ALSLinearLayout.SHOW_DIVIDER_END != 0
        }
        
        if (allViewsAreGoneBefore(childIndex)) {
            // This is the first view that's not gone, check if beginning divider is enabled.
            return showDividers & ALSLinearLayout.SHOW_DIVIDER_BEGINNING != 0
        } else {
            return showDividers & ALSLinearLayout.SHOW_DIVIDER_MIDDLE != 0
        }
    }
    
    /**
     * Checks whether all (virtual) child views before the given index are gone.
     */
    private func allViewsAreGoneBefore(childIndex: Int) -> Bool {
        for  var i = childIndex - 1; i >= 0; i-- {
            if let child = getVirtualChildAt(i) where !child.layoutHidden {
                return false
            }
        }
        return true
    }

    
    /**
     *
     * Returns the size (width or height) that should be occupied by a null
     * child.
     
     * @param childIndex the index of the null child
     * *
     * @return the width or height of the child depending on the orientation
     */
    internal func measureNullChild(childIndex: Int) -> CGFloat {
        return 0
    }
    
    /**
     *
     * Measure the child according to the parent's measure specs. This
     * method should be overriden by subclasses to force the sizing of
     * children. This method is called by [.measureVertical] and
     * [.measureHorizontal].
     
     * @param child             the child to measure
     * *
     * @param childIndex        the index of the child in this view
     * *
     * @param widthMeasureSpec  horizontal space requirements as imposed by the parent
     * *
     * @param totalWidth        extra space that has been used up by the parent horizontally
     * *
     * @param heightMeasureSpec vertical space requirements as imposed by the parent
     * *
     * @param totalHeight       extra space that has been used up by the parent vertically
     */
    internal func measureChildBeforeLayout(child: UIView, childIndex: Int, widthMeasureSpec: ALSLayoutParams.MeasureSpec, totalWidth: CGFloat, heightMeasureSpec: ALSLayoutParams.MeasureSpec, totalHeight: CGFloat) {
        measureChildWithMargins(child, parentWidthMeasureSpec: widthMeasureSpec, widthUsed: totalWidth, parentHeightMeasureSpec: heightMeasureSpec, heightUsed: totalHeight)
    }

    
    /**
     *
     * Return the location offset of the specified child. This can be used
     * by subclasses to change the location of a given widget.
     
     * @param child the child for which to obtain the location offset
     * *
     * @return the location offset in points
     */
    internal func getLocationOffset(child: UIView)-> CGFloat {
        return 0
    }
    
    /**
     *
     * Return the size offset of the next sibling of the specified child.
     * This can be used by subclasses to change the location of the widget
     * following `child`.
     
     * @param child the child whose next sibling will be moved
     * *
     * @return the location offset of the next child in points
     */
    internal func getNextLocationOffset(child: UIView)-> CGFloat {
        return 0
    }
    
    /**
     *
     * Returns the number of children to skip after measuring/laying out
     * the specified child.
     
     * @param child the child after which we want to skip children
     * *
     * @param index the index of the child after which we want to skip children
     * *
     * @return the number of children to skip, 0 by default
     */
    internal func getChildrenSkipCount(child: UIView, index: Int) -> Int {
        return 0
    }
    
    private func forceUniformWidth(count: Int, heightMeasureSpec: ALSLayoutParams.MeasureSpec) {
        // Pretend that the linear layout has an exact size.
        let uniformMeasureSpec: ALSLayoutParams.MeasureSpec = (bounds.width, .Exactly)
        for var i = 0; i < count; i++ {
            guard let child = getVirtualChildAt(i) where !child.layoutHidden else {
                continue
            }
            let lp = child.layoutParams
            
            if (lp.widthMode == .MatchParent) {
                // Temporarily force children to reuse their old measured height
                // FIXME: this may not be right for something like wrapping text?
                let oldHeight = lp.height
                lp.height = lp.measuredHeight
                
                // Remeasue with new dimensions
                measureChildWithMargins(child, parentWidthMeasureSpec: uniformMeasureSpec, widthUsed: 0, parentHeightMeasureSpec: heightMeasureSpec, heightUsed: 0)
                lp.height = oldHeight
                
            }
        }
    }
    
    private func forceUniformHeight(count: Int, widthMeasureSpec: ALSLayoutParams.MeasureSpec) {
        // Pretend that the linear layout has an exact size. This is the measured height of
        // ourselves. The measured height should be the max height of the children, changed
        // to accommodate the heightMeasureSpec from the parent
        let uniformMeasureSpec: ALSLayoutParams.MeasureSpec = (bounds.height, .Exactly)
        for var i = 0; i < count; i++ {
            guard let child = getVirtualChildAt(i) where !child.layoutHidden else {
                continue
            }
            let lp = child.layoutParams
            
            if (lp.heightMode == .MatchParent) {
                // Temporarily force children to reuse their old measured width
                // FIXME: this may not be right for something like wrapping text?
                let oldWidth = lp.width
                lp.width = lp.measuredHeight
                
                // Remeasure with new dimensions
                measureChildWithMargins(child, parentWidthMeasureSpec: widthMeasureSpec, widthUsed: 0, parentHeightMeasureSpec: uniformMeasureSpec, heightUsed: 0)
                lp.width = oldWidth
                
            }
        }
    }

    
}