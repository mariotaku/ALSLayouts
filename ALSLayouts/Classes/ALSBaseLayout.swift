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
    
    func getLayoutParams(view: UIView) -> ALSLayoutParams? {
        return layoutParamsMap[view.hash]
    }
    
    // Get layout params, create a new one if not exists
    func obtainLayoutParams(view: UIView) -> ALSLayoutParams {
        if let params = layoutParamsMap[view.hash] {
            return params
        }
        let newParams = ALSLayoutParams()
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
    
}