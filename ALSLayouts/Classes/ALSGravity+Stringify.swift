//
//  ALSGravity+Stringify.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/2.
//
//

import Foundation

extension ALSGravity {
    
    static func parse(str: String) -> Int {
        return str.componentsSeparatedByString("|").reduce(ALSGravity.NO_GRAVITY) { combined, gravityString -> Int in
            return combined | GravityString(rawValue: gravityString)!.intValue
        }
    }
    
    static func format(gravity: Int) -> String {
        var strings = [GravityString]()
        if (gravity & ALSGravity.CENTER != 0) {
            strings.append(.Center)
        } else if (gravity & ALSGravity.CENTER_HORIZONTAL != 0) {
            strings.append(.CenterHorizontal)
        } else if (gravity & ALSGravity.CENTER_VERTICAL != 0) {
            strings.append(.CenterVertical)
        }
        if (gravity & ALSGravity.FILL != 0) {
            strings.append(.Fill)
        } else if (gravity & ALSGravity.FILL_HORIZONTAL != 0) {
            strings.append(.CenterHorizontal)
        } else if (gravity & ALSGravity.FILL_VERTICAL != 0) {
            strings.append(.CenterVertical)
        } else if (gravity & ALSGravity.LEADING != 0) {
            strings.append(.Leading)
        } else if (gravity & ALSGravity.TRAILING != 0) {
            strings.append(.Trailing)
        } else if (gravity & ALSGravity.LEFT != 0) {
            strings.append(.Left)
        } else if (gravity & ALSGravity.RIGHT != 0) {
            strings.append(.Right)
        } else if (gravity & ALSGravity.TOP != 0) {
            strings.append(.Top)
        } else if (gravity & ALSGravity.BOTTOM != 0) {
            strings.append(.Bottom)
        }
        return strings.map { s -> String in return s.rawValue }.joinWithSeparator("|")
    }
    
    enum GravityString: String {
        case Top
        case Bottom
        case Left
        case Right
        case CenterVertical
        case FillVertical
        case CenterHorizontal
        case FillHorizontal
        case Center
        case Fill
        case ClipVertical
        case ClipHorizontal
        case Leading
        case Trailing

        
        var intValue: Int {
            get {
                switch self {
                case .Top: return ALSGravity.TOP
                case .Bottom: return ALSGravity.BOTTOM
                case .Left: return ALSGravity.LEFT
                case .Right: return ALSGravity.RIGHT
                case .CenterVertical: return ALSGravity.CENTER_VERTICAL
                case .FillVertical: return ALSGravity.FILL_VERTICAL
                case .CenterHorizontal: return ALSGravity.CENTER_HORIZONTAL
                case .FillHorizontal: return ALSGravity.FILL_HORIZONTAL
                case .Center: return ALSGravity.CENTER
                case .Fill: return ALSGravity.FILL
                case .ClipVertical: return ALSGravity.CLIP_VERTICAL
                case .ClipHorizontal: return ALSGravity.CLIP_HORIZONTAL
                case .Leading: return ALSGravity.LEADING
                case .Trailing: return ALSGravity.TRAILING
                }
            }
        }
    }
    
}