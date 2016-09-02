//
//  ALSLayoutParams.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/1.
//
//

import Foundation

public class ALSLayoutParams {
    
    var gravity: Int = ALSGravity.NO_GRAVITY
    
    var marginTop: CGFloat = 0
    var marginBottom: CGFloat = 0
    var marginLeading: CGFloat = 0
    var marginTrailng: CGFloat = 0
    
    var alignParentTop: Bool = false
    var alignParentBottom: Bool = false
    var alignParentLeading: Bool = false
    var alignParentTrailng: Bool = false
    
    var widthMode: SizeMode = .StaticSize
    var heightMode: SizeMode = .StaticSize
    
    public enum SizeMode: String {
        case StaticSize, WrapContent, MatchParent
    }
}