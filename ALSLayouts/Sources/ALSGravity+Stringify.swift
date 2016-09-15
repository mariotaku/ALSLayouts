//
//  ALSGravity+Stringify.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/2.
//
//

import Foundation

extension ALSGravity {
    
    static func parse(_ str: String) -> Int {
        return str.components(separatedBy: "|").reduce(ALSGravity.NO_GRAVITY) { combined, gravityString -> Int in
            return combined | GravityString(rawValue: gravityString)!.intValue
        }
    }
    
    static func format(_ gravity: Int) -> String {
        var strings = [String]()
        var value = gravity
        GravityString.allValues.forEach { gs in
            if (gs.intValue & value == gs.intValue) {
                strings.append(gs.rawValue)
                value = value & ~gs.intValue
            }
        }
        return strings.joined(separator: "|")
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
        
        static let allValues: [GravityString] = [.Fill, .FillVertical, .FillHorizontal, .Center, .CenterVertical, .CenterHorizontal, .Leading, .Trailing, .Top, .Bottom, .Left, .Right, .ClipVertical, .ClipHorizontal]
    }
    
}
