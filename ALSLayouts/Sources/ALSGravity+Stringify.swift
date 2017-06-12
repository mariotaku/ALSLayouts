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
        if (value != 0) {
            return "Invalid \(gravity)"
        }
        return strings.joined(separator: "|")
    }

    enum GravityString: String {
        case top
        case bottom
        case left
        case right
        case centerVertical
        case fillVertical
        case centerHorizontal
        case fillHorizontal
        case center
        case fill
        case clipVertical
        case clipHorizontal
        case leading
        case trailing

        var intValue: Int {
            get {
                switch self {
                case .top: return ALSGravity.TOP
                case .bottom: return ALSGravity.BOTTOM
                case .left: return ALSGravity.LEFT
                case .right: return ALSGravity.RIGHT
                case .centerVertical: return ALSGravity.CENTER_VERTICAL
                case .fillVertical: return ALSGravity.FILL_VERTICAL
                case .centerHorizontal: return ALSGravity.CENTER_HORIZONTAL
                case .fillHorizontal: return ALSGravity.FILL_HORIZONTAL
                case .center: return ALSGravity.CENTER
                case .fill: return ALSGravity.FILL
                case .clipVertical: return ALSGravity.CLIP_VERTICAL
                case .clipHorizontal: return ALSGravity.CLIP_HORIZONTAL
                case .leading: return ALSGravity.LEADING
                case .trailing: return ALSGravity.TRAILING
                }
            }
        }

        static let allValues: [GravityString] = [.fill, .fillVertical, .fillHorizontal, .center, .centerVertical,
                                                 .centerHorizontal, .leading, .trailing, .top, .bottom, .left, .right,
                                                 .clipVertical, .clipHorizontal]
    }

}
