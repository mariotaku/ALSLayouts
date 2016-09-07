//
//  ALSBaseLayout.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/1.
//
//

import UIKit

public class ALSBaseLayout: UIView {
    
    internal var layoutParamsMap = [Int: ALSLayoutParams]()
    
    private static let useZeroUnspecifiedMeasureSpec = false
    
    public var widthMode: ALSLayoutParams.SizeMode = .StaticSize
    public var heightMode: ALSLayoutParams.SizeMode = .StaticSize
    
    @IBInspectable public var ignoreLayoutMargins: Bool = false
    
    @IBInspectable internal var widthModeString: String {
        get { return widthMode.rawValue }
        set { self.widthMode = ALSLayoutParams.SizeMode(rawValue: newValue)! }
    }
    
    @IBInspectable internal var heightModeString: String {
        get { return heightMode.rawValue }
        set { self.heightMode = ALSLayoutParams.SizeMode(rawValue: newValue)! }
    }
    
    @IBInspectable internal var gravityString: String {
        get { return ALSGravity.format(self.gravity ?? 0) }
        set { self.gravity = ALSGravity.parse(newValue) }
    }
    
    internal var actualLayoutMargins: UIEdgeInsets {
        return ignoreLayoutMargins ? UIEdgeInsetsZero : self.layoutMargins
    }
    
    private var gravityValue: Int = ALSGravity.LEADING | ALSGravity.TOP
    
    /**
     
     ALSLinearLayout:
     
     Describes how the child views are positioned. Defaults to GRAVITY_TOP. If
     this layout has a VERTICAL orientation, this controls where all the child
     views are placed if there is extra vertical space. If this layout has a
     HORIZONTAL orientation, this controls the alignment of the children.
     
     - parameter gravity: See `ALSGravity`
     */
    public var gravity: Int {
        get { return self.gravityValue }
        set {
            var fixedValue = newValue
            if (self.gravityValue != fixedValue) {
                if (fixedValue & ALSGravity.RELATIVE_HORIZONTAL_GRAVITY_MASK == 0) {
                    fixedValue = fixedValue | ALSGravity.LEADING
                }
                
                if (fixedValue & ALSGravity.VERTICAL_GRAVITY_MASK == 0) {
                    fixedValue = fixedValue | ALSGravity.TOP
                }
                
                self.gravityValue = fixedValue
                self.setNeedsLayout()
            }
        }
    }
    
    public var horizontalGravity: Int {
        get {
            return self.gravity & ALSGravity.RELATIVE_HORIZONTAL_GRAVITY_MASK
        }
        set {
            let newHorizontalValue = newValue & ALSGravity.RELATIVE_HORIZONTAL_GRAVITY_MASK
            self.gravity = (self.gravity & ~ALSGravity.RELATIVE_HORIZONTAL_GRAVITY_MASK) | newHorizontalValue
        }
    }
    
    public var verticalGravity: Int {
        get {
            return self.gravity & ALSGravity.VERTICAL_GRAVITY_MASK
        }
        set {
            let newVerticalValue = newValue & ALSGravity.VERTICAL_GRAVITY_MASK
            self.gravity = (self.gravity & ~ALSGravity.VERTICAL_GRAVITY_MASK) | newVerticalValue
        }
    }
    
    public func addSubview(view: UIView, tagString: String? = nil, configure: (ALSLayoutParams) -> Void) {
        view.stringTag = tagString
        let lp = obtainLayoutParams(view)
        configure(lp)
        addSubview(view)
    }
    
    public func getLayoutParams(view: UIView) -> ALSLayoutParams? {
        return layoutParamsMap[view.hash]
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        return measureSubviews(size)
    }
    
    public override func didAddSubview(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.removeConstraints(self.constraints)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.removeConstraints(self.constraints)
    }
    
    internal func measureSubviews(size: CGSize) -> CGSize {
        return size
    }
    
    // Get layout params, create a new one if not exists
    internal func obtainLayoutParams(view: UIView) -> ALSLayoutParams {
        if let params = layoutParamsMap[view.hash] {
            return params
        }
        let newParams = ALSLayoutParams(view: view)
        initLayoutParams(view, newParams: newParams)
        layoutParamsMap[view.hash] = newParams
        return newParams
    }
    
    internal func initLayoutParams(view: UIView, newParams: ALSLayoutParams) {
        
    }
    
    internal func resolveSize(sizeMode: ALSLayoutParams.SizeMode, contentSize: CGFloat, frameSize: CGFloat, parentSize: CGFloat, margin: CGFloat) -> CGFloat {
        switch sizeMode {
        case .StaticSize:
            return frameSize
        case .WrapContent:
            return contentSize
        case .MatchParent:
            return parentSize - margin
        }
    }
    
    internal func calculateBaselineBottomValue() -> CGFloat {
        return CGFloat.NaN
    }
    
    func measureChildWithMargins(subview: UIView, parentWidthMeasureSpec: ALSLayoutParams.MeasureSpec, widthUsed: CGFloat,parentHeightMeasureSpec: ALSLayoutParams.MeasureSpec, heightUsed: CGFloat) {
        let lp = subview.layoutParams
        
        let childWidthMeasureSpec = ALSBaseLayout.getChildMeasureSpec(parentWidthMeasureSpec, padding: actualLayoutMargins.left + actualLayoutMargins.right + lp.marginAbsLeft + lp.marginAbsRight + widthUsed, childDimension: lp.width, childDimensionMode: lp.widthMode)
        let childHeightMeasureSpec = ALSBaseLayout.getChildMeasureSpec(parentHeightMeasureSpec, padding: actualLayoutMargins.top + actualLayoutMargins.bottom + lp.marginTop + lp.marginBottom + heightUsed, childDimension: lp.height, childDimensionMode: lp.heightMode)
        
        lp.measure(subview, widthSpec: childWidthMeasureSpec, heightSpec: childHeightMeasureSpec)
    }
    
    static func combineMeasuredStates(states: ALSLayoutParams.MeasureStates, widthMode: ALSLayoutParams.MeasureSpecMode, heightMode: ALSLayoutParams.MeasureSpecMode) -> ALSLayoutParams.MeasureStates {
        var newStates = states
        if (newStates.0 == .Unspecified) {
            newStates.0 = widthMode
        }
        if (newStates.1 == .Unspecified) {
            newStates.1 = heightMode
        }
        return newStates
    }
    
    static func getChildMeasureSpec(spec: ALSLayoutParams.MeasureSpec, padding: CGFloat, childDimension: CGFloat, childDimensionMode: ALSLayoutParams.SizeMode) -> ALSLayoutParams.MeasureSpec {
        let specMode: ALSLayoutParams.MeasureSpecMode = spec.1
        let specSize: CGFloat = spec.0
        
        let size = max(0, specSize - padding)
        
        var resultSize: CGFloat = 0
        var resultMode: ALSLayoutParams.MeasureSpecMode = .Unspecified
        
        switch (specMode) {
        // Parent has imposed an exact size on us
        case .Exactly:
            switch childDimensionMode {
            case .StaticSize:
                resultSize = childDimension
                resultMode = .Exactly
            case .MatchParent:
                // Child wants to be our size. So be it.
                resultSize = size
                resultMode = .Exactly
            case .WrapContent:
                // Child wants to determine its own size. It can't be
                // bigger than us.
                resultSize = size
                resultMode = .AtMost
            }
        // Parent has imposed a maximum size on us
        case .AtMost:
            switch childDimensionMode {
            case .StaticSize:
                // Child wants a specific size... so be it
                resultSize = childDimension
                resultMode = .Exactly
            case .MatchParent:
                // Child wants to be our size, but our size is not fixed.
                // Constrain child to not be bigger than us.
                resultSize = size
                resultMode = .AtMost
            case .WrapContent:
                // Child wants to determine its own size. It can't be
                // bigger than us.
                resultSize = size
                resultMode = .AtMost
            }
        // Parent asked to see how big we want to be
        case .Unspecified:
            switch childDimensionMode {
            case .StaticSize:
                // Child wants a specific size... let him have it
                resultSize = childDimension
                resultMode = .Exactly
            case .MatchParent:
                // Child wants to be our size... find out how big it should
                // be
                resultSize = useZeroUnspecifiedMeasureSpec ? 0 : size
                resultMode = .Unspecified
            case .WrapContent:
                // Child wants to determine its own size.... find out how
                // big it should be
                resultSize = useZeroUnspecifiedMeasureSpec ? 0 : size
                resultMode = .Unspecified
            }
        }
        return (resultSize, resultMode)
    }
    
    static func resolveSizeAndState(size: CGFloat, measureSpec: ALSLayoutParams.MeasureSpec, childMeasuredState: ALSLayoutParams.MeasureSpecMode) -> ALSLayoutParams.MeasureSpec {
        let specMode = measureSpec.1
        let specSize = measureSpec.0
        let resultSize: CGFloat
        switch (specMode) {
        case .AtMost:
            if (specSize < size) {
                resultSize = specSize // or MEASURED_STATE_TOO_SMALL
            } else {
                resultSize = size
            }
        case .Exactly:
            resultSize = specSize
        default:
            resultSize = size
        }
        return (resultSize, childMeasuredState)
    }
    
}
