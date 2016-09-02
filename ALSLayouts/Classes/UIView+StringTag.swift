//
//  UIView+StringTag.swift
//  Twidere
//
//  Created by Mariotaku Lee on 16/9/1.
//  Copyright © 2016年 Mariotaku Dev. All rights reserved.
//

import UIKit

public extension UIView {
    
    @IBInspectable public var stringTag: String? {
        get {
            if (self.tag == 0 || self.tag < 0 || self.tag >= UIView.tagPoll.count) {
                return nil
            } else {
                return UIView.tagPoll.filter { (k, v) -> Bool in return v == self.tag }.first?.0
            }
        }
        set {
            if (newValue == nil) {
                self.tag = 0
            } else {
                if let intTag = UIView.tagPoll[newValue!] {
                    self.tag = intTag
                } else {
                    let newTag = UIView.tagPoll.count + 1
                    UIView.tagPoll[newValue!] = newTag
                    self.tag = newTag
                }
            }
        }
    }
    
    func viewWithStringTag(stringTag: String) -> UIView? {
        guard let intTag = UIView.tagPoll[stringTag] else {
            return nil
        }
        return viewWithTag(intTag)
    }

    static func getTag(byStringTag tag: String?) -> Int {
        if (tag == nil) {
            return 0
        }
        return tagPoll[tag!] ?? 0
    }
    
    static func getStringTag(byTag tag: Int) -> String? {
        if (tag == 0) {
            return nil
        }
        return tagPoll.filter { (k, v) -> Bool in return v == tag }.first?.0
    }
    
    private static var tagPoll = [String: Int]()
}
