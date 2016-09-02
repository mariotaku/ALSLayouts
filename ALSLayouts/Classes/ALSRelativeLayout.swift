//
//  ALSRelativeLayout.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/2.
//
//

import UIKit

public class ALSRelativeLayout: ALSBaseLayout {
    
    static let TRUE = -1
    
    /**
     * Rule that aligns a child's right edge with another child's left edge.
     */
    static let LEFT_OF = 0
    /**
     * Rule that aligns a child's left edge with another child's right edge.
     */
    static let RIGHT_OF = 1
    /**
     * Rule that aligns a child's bottom edge with another child's top edge.
     */
    static let ABOVE = 2
    /**
     * Rule that aligns a child's top edge with another child's bottom edge.
     */
    static let BELOW = 3
    
    /**
     * Rule that aligns a child's baseline with another child's baseline.
     */
    static let ALIGN_BASELINE = 4
    /**
     * Rule that aligns a child's left edge with another child's left edge.
     */
    static let ALIGN_LEFT = 5
    /**
     * Rule that aligns a child's top edge with another child's top edge.
     */
    static let ALIGN_TOP = 6
    /**
     * Rule that aligns a child's right edge with another child's right edge.
     */
    static let ALIGN_RIGHT = 7
    /**
     * Rule that aligns a child's bottom edge with another child's bottom edge.
     */
    static let ALIGN_BOTTOM = 8
    
    /**
     * Rule that aligns the child's left edge with its RelativeLayout
     * parent's left edge.
     */
    static let ALIGN_PARENT_LEFT = 9
    /**
     * Rule that aligns the child's top edge with its RelativeLayout
     * parent's top edge.
     */
    static let ALIGN_PARENT_TOP = 10
    /**
     * Rule that aligns the child's right edge with its RelativeLayout
     * parent's right edge.
     */
    static let ALIGN_PARENT_RIGHT = 11
    /**
     * Rule that aligns the child's bottom edge with its RelativeLayout
     * parent's bottom edge.
     */
    static let ALIGN_PARENT_BOTTOM = 12
    
    /**
     * Rule that centers the child with respect to the bounds of its
     * RelativeLayout parent.
     */
    static let CENTER_IN_PARENT = 13
    /**
     * Rule that centers the child horizontally with respect to the
     * bounds of its RelativeLayout parent.
     */
    static let CENTER_HORIZONTAL = 14
    /**
     * Rule that centers the child vertically with respect to the
     * bounds of its RelativeLayout parent.
     */
    static let CENTER_VERTICAL = 15
    /**
     * Rule that aligns a child's end edge with another child's start edge.
     */
    static let LEADING_OF = 16
    /**
     * Rule that aligns a child's start edge with another child's end edge.
     */
    static let TRAILING_OF = 17
    /**
     * Rule that aligns a child's start edge with another child's start edge.
     */
    static let ALIGN_LEADING = 18
    /**
     * Rule that aligns a child's end edge with another child's end edge.
     */
    static let ALIGN_TRAILING = 19
    /**
     * Rule that aligns the child's start edge with its RelativeLayout
     * parent's start edge.
     */
    static let ALIGN_PARENT_LEADING = 20
    /**
     * Rule that aligns the child's end edge with its RelativeLayout
     * parent's end edge.
     */
    static let ALIGN_PARENT_TRAILING = 21
    
    static let VERB_COUNT = 22
    
    static let RULES_VERTICAL: [Int] = [ABOVE, BELOW, ALIGN_BASELINE, ALIGN_TOP, ALIGN_BOTTOM]
    
    static let RULES_HORIZONTAL: [Int] = [LEFT_OF, RIGHT_OF, ALIGN_LEFT, ALIGN_RIGHT, LEADING_OF, TRAILING_OF, ALIGN_LEADING, ALIGN_TRAILING]
    
    var nodesNeedsRebuild: Bool = true
    
    public override func didAddSubview(subview: UIView) {
        nodesNeedsRebuild = true
    }
    
    public override func willRemoveSubview(subview: UIView) {
        nodesNeedsRebuild = true
    }
    
    public override func layoutSubviews() {
        for (k, lp) in layoutParamsMap {
            lp.resolveViewTags()
        }
        debugPrint(layoutParamsMap)
    }
    
    
    
}