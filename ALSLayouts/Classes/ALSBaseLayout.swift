//
//  ALSBaseLayout.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/1.
//
//

import Foundation

class ALSBaseLayout: UIView {
    
    private var layoutParamsMap = [Int: ALSLayoutParams]()
    
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
    
}