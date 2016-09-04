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
    
    internal var actualLayoutMargins: UIEdgeInsets {
        return ignoreLayoutMargins ? UIEdgeInsetsZero : self.layoutMargins
    }
    
    public func addSubview(view: UIView, configure: (ALSLayoutParams) -> Void) {
        let lp = obtainLayoutParams(view)
        configure(lp)
        addSubview(view)
    }
    
    public func getLayoutParams(view: UIView) -> ALSLayoutParams? {
        return layoutParamsMap[view.hash]
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
        layoutParamsMap[view.hash] = newParams
        return newParams
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
    
    func measureChildWithMargins(child: UIView, parentWidthMeasureSpec: ALSLayoutParams.MeasureSpec, widthUsed: CGFloat,parentHeightMeasureSpec: ALSLayoutParams.MeasureSpec, heightUsed: CGFloat) {
        let lp = child.layoutParams!
    
        let childWidthMeasureSpec = ALSBaseLayout.getChildMeasureSpec(parentWidthMeasureSpec, padding: actualLayoutMargins.left + actualLayoutMargins.right + lp.marginAbsLeft + lp.marginAbsRight + widthUsed, childDimension: lp.width, childDimensionMode: lp.widthMode)
        let childHeightMeasureSpec = ALSBaseLayout.getChildMeasureSpec(parentHeightMeasureSpec, padding: actualLayoutMargins.top + actualLayoutMargins.bottom + lp.marginTop + lp.marginBottom + heightUsed, childDimension: lp.height, childDimensionMode: lp.heightMode)
    
        lp.measure(child, widthSpec: childWidthMeasureSpec, heightSpec: childHeightMeasureSpec)
    }
    
    static func combineMeasuredStates(states: ALSLayoutParams.MeasureStates, widthMode: ALSLayoutParams.MeasureSpecMode, heightMode: ALSLayoutParams.MeasureSpecMode) -> ALSLayoutParams.MeasureStates{
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