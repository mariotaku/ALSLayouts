//
//  ALSLayoutParams.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/1.
//
//

import UIKit

public class ALSLayoutParams {
    
    public var widthMode: SizeMode = .StaticSize
    public var heightMode: SizeMode = .StaticSize
    public var width: CGFloat
    public var height: CGFloat
    
    public var hidden: Bool = false
    
    public var gravity: Int = ALSGravity.NO_GRAVITY
    
    public var weight: CGFloat = 0
    
    public var marginTop: CGFloat = 0
    public var marginBottom: CGFloat = 0
    
    public var marginLeft: CGFloat = 0 {
        didSet { self.marginsChanged = true }
    }
    public var marginRight: CGFloat = 0 {
        didSet { self.marginsChanged = true }
    }
    public var marginLeading: CGFloat = 0 {
        didSet { self.marginsChanged = true }
    }
    public var marginTrailng: CGFloat = 0 {
        didSet { self.marginsChanged = true }
    }
    
    public var alignParentTop: Bool {
        get { return self.getBoolRule(ALSRelativeLayout.ALIGN_PARENT_TOP) }
        set { self.setBoolRule(ALSRelativeLayout.ALIGN_PARENT_TOP, subjectBool: newValue) }
    }
    public var alignParentBottom: Bool {
        get { return self.getBoolRule(ALSRelativeLayout.ALIGN_PARENT_BOTTOM) }
        set { self.setBoolRule(ALSRelativeLayout.ALIGN_PARENT_BOTTOM, subjectBool: newValue) }
    }
    public var alignParentLeft: Bool {
        get { return self.getBoolRule(ALSRelativeLayout.ALIGN_PARENT_LEFT) }
        set { self.setBoolRule(ALSRelativeLayout.ALIGN_PARENT_LEFT, subjectBool: newValue) }
    }
    public var alignParentRight: Bool {
        get { return self.getBoolRule(ALSRelativeLayout.ALIGN_PARENT_RIGHT) }
        set { self.setBoolRule(ALSRelativeLayout.ALIGN_PARENT_RIGHT, subjectBool: newValue) }
    }
    public var alignParentLeading: Bool {
        get { return self.getBoolRule(ALSRelativeLayout.ALIGN_PARENT_LEADING) }
        set { self.setBoolRule(ALSRelativeLayout.ALIGN_PARENT_LEADING, subjectBool: newValue) }
    }
    public var alignParentTrailing: Bool {
        get { return self.getBoolRule(ALSRelativeLayout.ALIGN_PARENT_TRAILING) }
        set { self.setBoolRule(ALSRelativeLayout.ALIGN_PARENT_TRAILING, subjectBool: newValue) }
    }
    
    public var alignTopTag: String? = nil
    public var alignBottomTag: String? = nil
    public var alignLeftTag: String? = nil
    public var alignRightTag: String? = nil
    public var alignLeadingTag: String? = nil
    public var alignTrailngTag: String? = nil
    public var alignBaselineTag: String? = nil
    public var aboveTag: String? = nil
    public var belowTag: String? = nil
    public var toLeftOfTag: String? = nil
    public var toRightOfTag: String? = nil
    public var toLeadingOfTag: String? = nil
    public var toTrailingOfTag: String? = nil
    
    public var alignWithParentIfMissing: Bool = false
    
    public var centerInParent: Bool {
        get { return self.getBoolRule(ALSRelativeLayout.CENTER_IN_PARENT) }
        set { self.setBoolRule(ALSRelativeLayout.CENTER_IN_PARENT, subjectBool: newValue) }
    }
    public var centerVertical: Bool {
        get { return self.getBoolRule(ALSRelativeLayout.CENTER_VERTICAL) }
        set { self.setBoolRule(ALSRelativeLayout.CENTER_VERTICAL, subjectBool: newValue) }
    }
    public var centerHorizontal: Bool {
        get { return self.getBoolRule(ALSRelativeLayout.CENTER_HORIZONTAL) }
        set { self.setBoolRule(ALSRelativeLayout.CENTER_HORIZONTAL, subjectBool: newValue) }
    }
    
    internal var alignTop: Int {
        get { return self.getRule(ALSRelativeLayout.ALIGN_TOP) }
        set { self.setRule(ALSRelativeLayout.ALIGN_TOP, subject: newValue) }
    }
    internal var alignBottom: Int {
        get { return self.getRule(ALSRelativeLayout.ALIGN_BOTTOM) }
        set { self.setRule(ALSRelativeLayout.ALIGN_BOTTOM, subject: newValue) }
    }
    internal var alignLeft: Int {
        get { return self.getRule(ALSRelativeLayout.ALIGN_LEFT) }
        set { self.setRule(ALSRelativeLayout.ALIGN_LEFT, subject: newValue) }
    }
    internal var alignRight: Int {
        get { return self.getRule(ALSRelativeLayout.ALIGN_RIGHT) }
        set { self.setRule(ALSRelativeLayout.ALIGN_RIGHT, subject: newValue) }
    }
    internal var alignLeading: Int {
        get { return self.getRule(ALSRelativeLayout.ALIGN_LEADING) }
        set { self.setRule(ALSRelativeLayout.ALIGN_LEADING, subject: newValue) }
    }
    internal var alignTrailng: Int {
        get { return self.getRule(ALSRelativeLayout.ALIGN_TRAILING) }
        set { self.setRule(ALSRelativeLayout.ALIGN_TRAILING, subject: newValue) }
    }
    internal var alignBaseline: Int {
        get { return self.getRule(ALSRelativeLayout.ALIGN_BASELINE) }
        set { self.setRule(ALSRelativeLayout.ALIGN_BASELINE, subject: newValue) }
    }
    
    internal var above: Int {
        get { return self.getRule(ALSRelativeLayout.ABOVE) }
        set { self.setRule(ALSRelativeLayout.ABOVE, subject: newValue) }
    }
    internal var below: Int {
        get { return self.getRule(ALSRelativeLayout.BELOW) }
        set { self.setRule(ALSRelativeLayout.BELOW, subject: newValue) }
    }
    internal var toLeftOf: Int {
        get { return self.getRule(ALSRelativeLayout.LEFT_OF) }
        set { self.setRule(ALSRelativeLayout.LEFT_OF, subject: newValue) }
    }
    internal var toRightOf: Int {
        get { return self.getRule(ALSRelativeLayout.RIGHT_OF) }
        set { self.setRule(ALSRelativeLayout.RIGHT_OF, subject: newValue) }
    }
    internal var toLeadingOf: Int {
        get { return self.getRule(ALSRelativeLayout.LEADING_OF) }
        set { self.setRule(ALSRelativeLayout.LEADING_OF, subject: newValue) }
    }
    internal var toTrailingOf: Int {
        get { return self.getRule(ALSRelativeLayout.TRAILING_OF) }
        set { self.setRule(ALSRelativeLayout.TRAILING_OF, subject: newValue) }
    }
    
    internal private(set) var marginAbsLeft: CGFloat = 0
    internal private(set) var marginAbsRight: CGFloat = 0
    
    internal var left: CGFloat = 0
    internal var top: CGFloat = 0
    internal var right: CGFloat = 0
    internal var bottom: CGFloat = 0
    
    internal private(set) var measuredWidth: CGFloat = 0
    internal private(set) var measuredHeight: CGFloat = 0
    
    internal var measuredWidthSpec: MeasureSpecMode = .Unspecified
    internal var measuredHeightSpec: MeasureSpecMode = .Unspecified
    
    private var initialRules: [Int] = [Int](count: ALSRelativeLayout.VERB_COUNT, repeatedValue: 0)
    private var rules: [Int] = [Int](count: ALSRelativeLayout.VERB_COUNT, repeatedValue: 0)
    
    /**
     * Whether this view had any relative rules modified following the most
     * recent resolution of layout direction.
     */
    private var needsLayoutResolution: Bool = false
    
    private var rulesChanged: Bool = false
    private var marginsChanged: Bool = false
    
    private var layoutDirection: UIUserInterfaceLayoutDirection = .LeftToRight
    
    public required init(view: UIView) {
        self.width = view.frame.width
        self.height = view.frame.height
        
        marginsChanged = true
        rulesChanged = true

    }
    
    internal func resolveViewTags() {
        alignTop = UIView.getTag(byStringTag: alignTopTag)
        alignBottom = UIView.getTag(byStringTag: alignBottomTag)
        alignLeft = UIView.getTag(byStringTag: alignLeftTag)
        alignRight = UIView.getTag(byStringTag: alignRightTag)
        alignLeading = UIView.getTag(byStringTag: alignLeadingTag)
        alignTrailng = UIView.getTag(byStringTag: alignTrailngTag)
        alignBaseline = UIView.getTag(byStringTag: alignBaselineTag)
        above = UIView.getTag(byStringTag: aboveTag)
        below = UIView.getTag(byStringTag: belowTag)
        toLeftOf = UIView.getTag(byStringTag: toLeftOfTag)
        toRightOf = UIView.getTag(byStringTag: toRightOfTag)
        toLeadingOf = UIView.getTag(byStringTag: toLeadingOfTag)
        toTrailingOf = UIView.getTag(byStringTag: toTrailingOfTag)
    }
    
    /**
     * This will be called by [android.view.View.requestLayout] to
     * resolve layout parameters that are relative to the layout direction.
     *
     *
     * After this method is called, any rules using layout-relative verbs
     * (ex. [.LEADING_OF]) previously added may only be accessed via their
     * resolved absolute verbs (ex.
     * [.LEFT_OF]).
     */
    internal func resolveLayoutDirection(layoutDirection: UIUserInterfaceLayoutDirection) {
        if (shouldResolveRules(layoutDirection)) {
            resolveRules(layoutDirection)
        }
        
        if (shouldResolveMargins(layoutDirection)) {
            if (marginLeft != 0) {
                marginAbsLeft = marginLeft
            } else if (layoutDirection == .RightToLeft) {
                marginAbsLeft = marginTrailng
            } else {
                marginAbsLeft = marginLeading
            }
            
            if (marginRight != 0) {
                marginAbsRight = marginRight
            } else if (layoutDirection == .RightToLeft) {
                marginAbsRight = marginLeading
            } else {
                marginAbsRight = marginTrailng
            }
            marginsChanged = false
        }
        self.layoutDirection = layoutDirection
    }
    
    internal func measure(view: UIView, widthSpec: MeasureSpec, heightSpec: MeasureSpec) {
        if (widthSpec.1 == .Exactly || heightSpec.1 == .Exactly) {
            if (widthSpec.1 != .Exactly) {
                // Exact height
                let sizeThatFits = view.sizeThatFits(CGSizeMake(widthSpec.0, heightSpec.0))
                self.measuredWidth = sizeThatFits.width
                self.measuredHeight = heightSpec.0
            } else if (heightSpec.1 != .Exactly) {
                // Exact width
                let sizeThatFits = view.sizeThatFits(CGSizeMake(widthSpec.0, heightSpec.0))
                self.measuredWidth = widthSpec.0
                self.measuredHeight = sizeThatFits.height
            } else {
                // Exact both
                self.measuredWidth = widthSpec.0
                self.measuredHeight = heightSpec.0
            }
        } else if (widthSpec.1 == .AtMost || heightSpec.1 == .AtMost) {
            let sizeThatFits = view.sizeThatFits(CGSizeMake(widthSpec.0, heightSpec.0))
            self.measuredWidth = sizeThatFits.width
            self.measuredHeight = sizeThatFits.height
        } else {
            self.measuredWidth = widthSpec.0
            self.measuredHeight = heightSpec.0
        }
        self.measuredWidthSpec = widthSpec.1
        self.measuredHeightSpec = heightSpec.1
    }
    
    internal func getRules(layoutDirection: UIUserInterfaceLayoutDirection) -> [Int] {
        resolveLayoutDirection(layoutDirection)
        return rules
    }
    
    internal func getRules() -> [Int] {
        return rules
    }
    
    // The way we are resolving rules depends on the layout direction and if we are pre JB MR1
    // or not.
    //
    // If we are pre JB MR1 (said as "RTL compatibility mode"), "left"/"right" rules are having
    // predominance over any "start/end" rules that could have been defined. A special case:
    // if no "left"/"right" rule has been defined and "start"/"end" rules are defined then we
    // resolve those "start"/"end" rules to "left"/"right" respectively.
    //
    // If we are JB MR1+, then "start"/"end" rules are having predominance over "left"/"right"
    // rules. If no "start"/"end" rule is defined then we use "left"/"right" rules.
    //
    // In all cases, the result of the resolution should clear the "start"/"end" rules to leave
    // only the "left"/"right" rules at the end.
    private func resolveRules(layoutDirection: UIUserInterfaceLayoutDirection) {
        let isLayoutRtl = layoutDirection == .RightToLeft
        
        // Reset to initial state
        for (idx, value) in initialRules.enumerate() {
            rules[idx] = value
        }
        
        // Apply rules depending on direction and if we are in RTL compatibility mode
        // JB MR1+ case
        if ((rules[ALSRelativeLayout.ALIGN_LEADING] != 0 || rules[ALSRelativeLayout.ALIGN_TRAILING] != 0) && (rules[ALSRelativeLayout.ALIGN_LEFT] != 0 || rules[ALSRelativeLayout.ALIGN_RIGHT] != 0)) {
            // "start"/"end" rules take precedence over "left"/"right" rules
            rules[ALSRelativeLayout.ALIGN_LEFT] = 0
            rules[ALSRelativeLayout.ALIGN_RIGHT] = 0
        }
        if (rules[ALSRelativeLayout.ALIGN_LEADING] != 0) {
            // "start" rule resolved to "left" or "right" depending on the direction
            rules[isLayoutRtl ? ALSRelativeLayout.ALIGN_RIGHT : ALSRelativeLayout.ALIGN_LEFT] = rules[ALSRelativeLayout.ALIGN_LEADING]
            rules[ALSRelativeLayout.ALIGN_LEADING] = 0
        }
        if (rules[ALSRelativeLayout.ALIGN_TRAILING] != 0) {
            // "end" rule resolved to "left" or "right" depending on the direction
            rules[isLayoutRtl ? ALSRelativeLayout.ALIGN_LEFT : ALSRelativeLayout.ALIGN_RIGHT] = rules[ALSRelativeLayout.ALIGN_TRAILING]
            rules[ALSRelativeLayout.ALIGN_TRAILING] = 0
        }
        
        if ((rules[ALSRelativeLayout.LEADING_OF] != 0 || rules[ALSRelativeLayout.TRAILING_OF] != 0) && (rules[ALSRelativeLayout.LEFT_OF] != 0 || rules[ALSRelativeLayout.RIGHT_OF] != 0)) {
            // "start"/"end" rules take precedence over "left"/"right" rules
            rules[ALSRelativeLayout.LEFT_OF] = 0
            rules[ALSRelativeLayout.RIGHT_OF] = 0
        }
        if (rules[ALSRelativeLayout.LEADING_OF] != 0) {
            // "start" rule resolved to "left" or "right" depending on the direction
            rules[isLayoutRtl ? ALSRelativeLayout.RIGHT_OF : ALSRelativeLayout.LEFT_OF] = rules[ALSRelativeLayout.LEADING_OF]
            rules[ALSRelativeLayout.LEADING_OF] = 0
        }
        if (rules[ALSRelativeLayout.TRAILING_OF] != 0) {
            // "end" rule resolved to "left" or "right" depending on the direction
            rules[isLayoutRtl ? ALSRelativeLayout.LEFT_OF : ALSRelativeLayout.RIGHT_OF] = rules[ALSRelativeLayout.TRAILING_OF]
            rules[ALSRelativeLayout.TRAILING_OF] = 0
        }
        
        if ((rules[ALSRelativeLayout.ALIGN_PARENT_LEADING] != 0 || rules[ALSRelativeLayout.ALIGN_PARENT_TRAILING] != 0) && (rules[ALSRelativeLayout.ALIGN_PARENT_LEFT] != 0 || rules[ALSRelativeLayout.ALIGN_PARENT_RIGHT] != 0)) {
            // "start"/"end" rules take precedence over "left"/"right" rules
            rules[ALSRelativeLayout.ALIGN_PARENT_LEFT] = 0
            rules[ALSRelativeLayout.ALIGN_PARENT_RIGHT] = 0
        }
        if (rules[ALSRelativeLayout.ALIGN_PARENT_LEADING] != 0) {
            // "start" rule resolved to "left" or "right" depending on the direction
            rules[isLayoutRtl ? ALSRelativeLayout.ALIGN_PARENT_RIGHT : ALSRelativeLayout.ALIGN_PARENT_LEFT] = rules[ALSRelativeLayout.ALIGN_PARENT_LEADING]
            rules[ALSRelativeLayout.ALIGN_PARENT_LEADING] = 0
        }
        if (rules[ALSRelativeLayout.ALIGN_PARENT_TRAILING] != 0) {
            // "end" rule resolved to "left" or "right" depending on the direction
            rules[isLayoutRtl ? ALSRelativeLayout.ALIGN_PARENT_LEFT : ALSRelativeLayout.ALIGN_PARENT_RIGHT] = rules[ALSRelativeLayout.ALIGN_PARENT_TRAILING]
            rules[ALSRelativeLayout.ALIGN_PARENT_TRAILING] = 0
        }
        
        rulesChanged = false
        needsLayoutResolution = false
    }
    
    
    private func shouldResolveRules(layoutDirection: UIUserInterfaceLayoutDirection) -> Bool {
        return (needsLayoutResolution || hasRelativeRules()) && (rulesChanged || layoutDirection != self.layoutDirection)
    }
    
    private func shouldResolveMargins(layoutDirection: UIUserInterfaceLayoutDirection) -> Bool {
        return marginsChanged || layoutDirection != self.layoutDirection
    }
    
    private func setRule(verb: Int, subject: Int) {
        // If we're removing a relative rule, we'll need to force layout
        // resolution the next time it's requested.
        if (!needsLayoutResolution && isRelativeRule(verb)
            && initialRules[verb] != 0 && subject == 0) {
            needsLayoutResolution = true
        }
        
        rules[verb] = subject
        initialRules[verb] = subject
        rulesChanged = true;
    }
    
    private func getRule(verb: Int) -> Int {
        return rules[verb]
    }
    
    private func setBoolRule(verb: Int, subjectBool: Bool) {
        self.setRule(verb, subject: subjectBool ? ALSRelativeLayout.TRUE : 0)
    }
    
    private func getBoolRule(verbBool: Int) -> Bool {
        return rules[verbBool] == ALSRelativeLayout.TRUE
    }
    
    private func hasRelativeRules() -> Bool {
        return initialRules[ALSRelativeLayout.LEADING_OF] != 0 || initialRules[ALSRelativeLayout.TRAILING_OF] != 0 || initialRules[ALSRelativeLayout.ALIGN_LEADING] != 0 || initialRules[ALSRelativeLayout.ALIGN_TRAILING] != 0 || initialRules[ALSRelativeLayout.ALIGN_PARENT_LEADING] != 0 || initialRules[ALSRelativeLayout.ALIGN_PARENT_TRAILING] != 0
    }
    
    private func isRelativeRule(rule: Int) -> Bool {
        return rule == ALSRelativeLayout.LEADING_OF || rule == ALSRelativeLayout.TRAILING_OF || rule == ALSRelativeLayout.ALIGN_LEADING || rule == ALSRelativeLayout.ALIGN_TRAILING || rule == ALSRelativeLayout.ALIGN_PARENT_LEADING || rule == ALSRelativeLayout.ALIGN_PARENT_TRAILING
    }
    
    public enum SizeMode: String {
        case StaticSize, WrapContent, MatchParent
    }
    
    internal enum MeasureSpecMode {
        case Unspecified, AtMost, Exactly
    }
    
    internal typealias MeasureSpec = (CGFloat, MeasureSpecMode)
    internal typealias MeasureStates = (MeasureSpecMode, MeasureSpecMode)
}