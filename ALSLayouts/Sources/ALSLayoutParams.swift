//
//  ALSLayoutParams.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/1.
//
//

import UIKit

/**
 Layout parameters
 
 Combined all required fields for LinearLayout, FrameLayout and RelativeLayout
 */
public class ALSLayoutParams {

    /**
     Defines how view measured, including real size dimensions
     */
    public enum Size {
        /** Static size defined in code */
        case staticSize(size: CGFloat)
        /** Determines its size during measurement */
        case wrapContent
        /** Fills super view size as possible */
        case matchParent
    }

    /**
     Defines how view measured
     */
    public enum SizeMode: String {
        /** Static size defined in Interface Builder */
        case staticSize
        /** Determines its size during measurement */
        case wrapContent
        /** Fills super view size as possible */
        case matchParent
    }

    /**
     Value for `gravity` indicating that a gravity has not been
     explicitly specified.
     */
    public static let UNSPECIFIED_GRAVITY = -1;

    /**
     How width measured
     */
    public var widthMode: SizeMode = .staticSize
    /**
     How height measured
     */
    public var heightMode: SizeMode = .staticSize
    /**
     Static width, overrides size dimension set in Interface Builder
     */
    public var widthDimension: CGFloat
    /**
     Static height, overrides size dimension set in Interface Builder
     */
    public var heightDimension: CGFloat

    public var width: Size {
        get {
            switch widthMode {
            case SizeMode.matchParent: return Size.matchParent
            case SizeMode.wrapContent: return Size.wrapContent
            case SizeMode.staticSize: return Size.staticSize(size: widthDimension)
            }
        }
        set {
            switch newValue {
            case Size.matchParent:
                widthMode = SizeMode.matchParent
                widthDimension = 0
            case Size.wrapContent:
                widthMode = SizeMode.wrapContent
                widthDimension = 0
            case Size.staticSize(let size):
                widthMode = SizeMode.staticSize
                widthDimension = size
            }
        }
    }

    public var height: Size {
        get {
            switch heightMode {
            case SizeMode.matchParent: return Size.matchParent
            case SizeMode.wrapContent: return Size.wrapContent
            case SizeMode.staticSize: return Size.staticSize(size: heightDimension)
            }
        }
        set {
            switch newValue {
            case Size.matchParent:
                heightMode = SizeMode.matchParent
                heightDimension = 0
            case Size.wrapContent:
                heightMode = SizeMode.wrapContent
                heightDimension = 0
            case Size.staticSize(let size):
                heightMode = SizeMode.staticSize
                heightDimension = size
            }
        }
    }

    /**
     When set to true, view will be hidden during layout, like set `visibility = View.GONE` in Android
     */
    public var hidden: Bool = false

    /**
     The gravity to apply with the View to which these layout parameters
     are associated.
     
     The default value is `UNSPECIFIED_GRAVITY`, which is treated
     by FrameLayout as `ALSGravity.TOP | ALSGravity.LEADING`.
     
     - SeeAlso: `ALSGravity`
     */
    public var gravity: Int = ALSLayoutParams.UNSPECIFIED_GRAVITY

    /**
     Indicates how much of the extra space in the LinearLayout will be
     allocated to the view associated with these LayoutParams. Specify
     0 if the view should not be stretched. Otherwise the extra pixels
     will be pro-rated among all views whose weight is greater than 0.
     */
    public var weight: CGFloat = 0
    /**
     The top margin in points of the subview. Margin values should be positive.
     Call `setNeedsLayout()` after reassigning a new value to this field.
     */
    public var marginTop: CGFloat = 0
    /**
     The bottom margin in points of the subview. Margin values should be positive.
     Call `setNeedsLayout()` after reassigning a new value to this field.
     */
    public var marginBottom: CGFloat = 0

    /**
     The left margin in points of the subview. Margin values should be positive.
     Call `setNeedsLayout()` after reassigning a new value to this field.
     */
    public var marginLeft: CGFloat = 0 {
        didSet {
            self.marginsChanged = true
        }
    }
    /**
     The right margin in points of the subview. Margin values should be positive.
     Call `setNeedsLayout()` after reassigning a new value to this field.
     */
    public var marginRight: CGFloat = 0 {
        didSet {
            self.marginsChanged = true
        }
    }
    /**
     The leading margin in points of the subview. Margin values should be positive.
     Call `setNeedsLayout()` after reassigning a new value to this field.
     */
    public var marginLeading: CGFloat = 0 {
        didSet {
            self.marginsChanged = true
        }
    }
    /**
     The trailing margin in points of the subview. Margin values should be positive.
     Call `setNeedsLayout()` after reassigning a new value to this field.
     */
    public var marginTrailing: CGFloat = 0 {
        didSet {
            self.marginsChanged = true
        }
    }

    /**
     If true, makes the top edge of this view match the top edge of the parent.
     */
    public var alignParentTop: Bool {
        get {
            return self.getBoolRule(ALSRelativeLayout.ALIGN_PARENT_TOP)
        }
        set {
            self.setBoolRule(ALSRelativeLayout.ALIGN_PARENT_TOP, subjectBool: newValue)
        }
    }
    /**
     If true, makes the bottom edge of this view match the bottom edge of the parent.
     */
    public var alignParentBottom: Bool {
        get {
            return self.getBoolRule(ALSRelativeLayout.ALIGN_PARENT_BOTTOM)
        }
        set {
            self.setBoolRule(ALSRelativeLayout.ALIGN_PARENT_BOTTOM, subjectBool: newValue)
        }
    }
    /**
     If true, makes the left edge of this view match the left edge of the parent.
     */
    public var alignParentLeft: Bool {
        get {
            return self.getBoolRule(ALSRelativeLayout.ALIGN_PARENT_LEFT)
        }
        set {
            self.setBoolRule(ALSRelativeLayout.ALIGN_PARENT_LEFT, subjectBool: newValue)
        }
    }
    /**
     If true, makes the right edge of this view match the right edge of the parent.
     */
    public var alignParentRight: Bool {
        get {
            return self.getBoolRule(ALSRelativeLayout.ALIGN_PARENT_RIGHT)
        }
        set {
            self.setBoolRule(ALSRelativeLayout.ALIGN_PARENT_RIGHT, subjectBool: newValue)
        }
    }
    /**
     If true, makes the leading edge of this view match the leading edge of the parent.
     */
    public var alignParentLeading: Bool {
        get {
            return self.getBoolRule(ALSRelativeLayout.ALIGN_PARENT_LEADING)
        }
        set {
            self.setBoolRule(ALSRelativeLayout.ALIGN_PARENT_LEADING, subjectBool: newValue)
        }
    }
    /**
     If true, makes the trailing edge of this view match the trailing edge of the parent.
     */
    public var alignParentTrailing: Bool {
        get {
            return self.getBoolRule(ALSRelativeLayout.ALIGN_PARENT_TRAILING)
        }
        set {
            self.setBoolRule(ALSRelativeLayout.ALIGN_PARENT_TRAILING, subjectBool: newValue)
        }
    }

    public var alignTopTag: String? = nil
    /**
     Makes the bottom edge of this view match the bottom edge of the given anchor view string tag.
     */
    public var alignBottomTag: String? = nil
    /**
     Makes the left edge of this view match the left edge of the given anchor view string tag.
     */
    public var alignLeftTag: String? = nil
    /**
     Makes the right edge of this view match the right edge of the given anchor view string tag.
     */
    public var alignRightTag: String? = nil
    /**
     Makes the start edge of this view match the start edge of the given anchor view string tag.
     */
    public var alignLeadingTag: String? = nil
    /**
     Makes the trailing edge of this view match the trailing edge of the given anchor view string tag.
     */
    public var alignTrailingTag: String? = nil
    /**
     Positions the baseline of this view on the baseline of the given anchor view string tag.
     */
    public var alignBaselineTag: String? = nil
    /**
     Positions the bottom edge of this view above the given anchor view string tag.
     */
    public var aboveTag: String? = nil
    /**
     Positions the top edge of this view below the given anchor view string tag.
     */
    public var belowTag: String? = nil
    /**
     Positions the right edge of this view to the left of the given anchor view string tag.
     */
    public var toLeftOfTag: String? = nil
    /**
     Positions the left edge of this view to the right of the given anchor view string tag.
     */
    public var toRightOfTag: String? = nil
    /**
     Positions the trailing edge of this view to the leading of the given anchor view string tag.
     */
    public var toLeadingOfTag: String? = nil
    /**
     Positions the leading edge of this view to the trailing of the given anchor view string tag.
     */
    public var toTrailingOfTag: String? = nil

    /**
     If set to true, the parent will be used as the anchor when the anchor cannot be be found for `toLeftOf`, `toRightOf`, etc.
     */
    public var alignWithParentIfMissing: Bool = false

    /**
     If true, centers this subview horizontally and vertically within its parent.
     */
    public var centerInParent: Bool {
        get {
            return self.getBoolRule(ALSRelativeLayout.CENTER_IN_PARENT)
        }
        set {
            self.setBoolRule(ALSRelativeLayout.CENTER_IN_PARENT, subjectBool: newValue)
        }
    }
    /**
     If true, centers this subview vertically within its parent.
     */
    public var centerVertical: Bool {
        get {
            return self.getBoolRule(ALSRelativeLayout.CENTER_VERTICAL)
        }
        set {
            self.setBoolRule(ALSRelativeLayout.CENTER_VERTICAL, subjectBool: newValue)
        }
    }
    /**
     If true, centers this subview horizontally within its parent.
     */
    public var centerHorizontal: Bool {
        get {
            return self.getBoolRule(ALSRelativeLayout.CENTER_HORIZONTAL)
        }
        set {
            self.setBoolRule(ALSRelativeLayout.CENTER_HORIZONTAL, subjectBool: newValue)
        }
    }

    internal var alignTop: Int {
        get {
            return self.getRule(ALSRelativeLayout.ALIGN_TOP)
        }
        set {
            self.setRule(ALSRelativeLayout.ALIGN_TOP, subject: newValue)
        }
    }
    internal var alignBottom: Int {
        get {
            return self.getRule(ALSRelativeLayout.ALIGN_BOTTOM)
        }
        set {
            self.setRule(ALSRelativeLayout.ALIGN_BOTTOM, subject: newValue)
        }
    }
    internal var alignLeft: Int {
        get {
            return self.getRule(ALSRelativeLayout.ALIGN_LEFT)
        }
        set {
            self.setRule(ALSRelativeLayout.ALIGN_LEFT, subject: newValue)
        }
    }
    internal var alignRight: Int {
        get {
            return self.getRule(ALSRelativeLayout.ALIGN_RIGHT)
        }
        set {
            self.setRule(ALSRelativeLayout.ALIGN_RIGHT, subject: newValue)
        }
    }
    internal var alignLeading: Int {
        get {
            return self.getRule(ALSRelativeLayout.ALIGN_LEADING)
        }
        set {
            self.setRule(ALSRelativeLayout.ALIGN_LEADING, subject: newValue)
        }
    }
    internal var alignTrailing: Int {
        get {
            return self.getRule(ALSRelativeLayout.ALIGN_TRAILING)
        }
        set {
            self.setRule(ALSRelativeLayout.ALIGN_TRAILING, subject: newValue)
        }
    }
    internal var alignBaseline: Int {
        get {
            return self.getRule(ALSRelativeLayout.ALIGN_BASELINE)
        }
        set {
            self.setRule(ALSRelativeLayout.ALIGN_BASELINE, subject: newValue)
        }
    }

    internal var above: Int {
        get {
            return self.getRule(ALSRelativeLayout.ABOVE)
        }
        set {
            self.setRule(ALSRelativeLayout.ABOVE, subject: newValue)
        }
    }
    internal var below: Int {
        get {
            return self.getRule(ALSRelativeLayout.BELOW)
        }
        set {
            self.setRule(ALSRelativeLayout.BELOW, subject: newValue)
        }
    }
    internal var toLeftOf: Int {
        get {
            return self.getRule(ALSRelativeLayout.LEFT_OF)
        }
        set {
            self.setRule(ALSRelativeLayout.LEFT_OF, subject: newValue)
        }
    }
    internal var toRightOf: Int {
        get {
            return self.getRule(ALSRelativeLayout.RIGHT_OF)
        }
        set {
            self.setRule(ALSRelativeLayout.RIGHT_OF, subject: newValue)
        }
    }
    internal var toLeadingOf: Int {
        get {
            return self.getRule(ALSRelativeLayout.LEADING_OF)
        }
        set {
            self.setRule(ALSRelativeLayout.LEADING_OF, subject: newValue)
        }
    }
    internal var toTrailingOf: Int {
        get {
            return self.getRule(ALSRelativeLayout.TRAILING_OF)
        }
        set {
            self.setRule(ALSRelativeLayout.TRAILING_OF, subject: newValue)
        }
    }

    internal fileprivate(set) var marginAbsLeft: CGFloat = 0
    internal fileprivate(set) var marginAbsRight: CGFloat = 0

    internal var left: CGFloat = 0
    internal var top: CGFloat = 0
    internal var right: CGFloat = 0
    internal var bottom: CGFloat = 0

    internal fileprivate(set) var measuredWidth: CGFloat = 0
    internal fileprivate(set) var measuredHeight: CGFloat = 0

    internal var measuredWidthSpec: MeasureSpecMode = .unspecified
    internal var measuredHeightSpec: MeasureSpecMode = .unspecified

    fileprivate var initialRules: [Int] = [Int](repeating: 0, count: ALSRelativeLayout.VERB_COUNT)
    fileprivate var rules: [Int] = [Int](repeating: 0, count: ALSRelativeLayout.VERB_COUNT)

    /**
     * Whether this view had any relative rules modified following the most
     * recent resolution of layout direction.
     */
    fileprivate var needsLayoutResolution: Bool = false

    fileprivate var rulesChanged: Bool = false
    fileprivate var marginsChanged: Bool = false

    fileprivate var layoutDirection: UIUserInterfaceLayoutDirection = .leftToRight
    fileprivate weak var view: UIView!

    public required init(view: UIView) {
        self.widthDimension = view.frame.width
        self.heightDimension = view.frame.height
        self.view = view

        marginsChanged = true
        rulesChanged = true
    }

    internal func resolveViewTags() {
        alignTop = UIView.getTag(byStringTag: alignTopTag)
        alignBottom = UIView.getTag(byStringTag: alignBottomTag)
        alignLeft = UIView.getTag(byStringTag: alignLeftTag)
        alignRight = UIView.getTag(byStringTag: alignRightTag)
        alignLeading = UIView.getTag(byStringTag: alignLeadingTag)
        alignTrailing = UIView.getTag(byStringTag: alignTrailingTag)
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
    internal func resolveLayoutDirection(_ layoutDirection: UIUserInterfaceLayoutDirection) {
        if (shouldResolveRules(layoutDirection)) {
            resolveRules(layoutDirection)
        }

        if (shouldResolveMargins(layoutDirection)) {
            if (marginLeft != 0) {
                marginAbsLeft = marginLeft
            } else if (layoutDirection == .rightToLeft) {
                marginAbsLeft = marginTrailing
            } else {
                marginAbsLeft = marginLeading
            }

            if (marginRight != 0) {
                marginAbsRight = marginRight
            } else if (layoutDirection == .rightToLeft) {
                marginAbsRight = marginLeading
            } else {
                marginAbsRight = marginTrailing
            }
            marginsChanged = false
        }
        self.layoutDirection = layoutDirection
    }

    internal func measure(_ view: UIView, widthSpec: MeasureSpec, heightSpec: MeasureSpec) {
        if (widthSpec.1 == .exactly || heightSpec.1 == .exactly) {
            if (widthSpec.1 != .exactly) {
                // Exact height
                let sizeThatFits = view.sizeThatFits(CGSize(width: widthSpec.0, height: heightSpec.0))
                self.measuredWidth = sizeThatFits.width
                self.measuredHeight = heightSpec.0
            } else if (heightSpec.1 != .exactly) {
                // Exact width
                let sizeThatFits = view.sizeThatFits(CGSize(width: widthSpec.0, height: heightSpec.0))
                self.measuredWidth = widthSpec.0
                self.measuredHeight = sizeThatFits.height
            } else {
                // Exact both
                self.measuredWidth = widthSpec.0
                self.measuredHeight = heightSpec.0
            }
        } else if (widthSpec.1 == .atMost || heightSpec.1 == .atMost) {
            let sizeThatFits = view.sizeThatFits(CGSize(width: widthSpec.0, height: heightSpec.0))
            self.measuredWidth = sizeThatFits.width
            self.measuredHeight = sizeThatFits.height
        } else {
            self.measuredWidth = widthSpec.0
            self.measuredHeight = heightSpec.0
        }
        self.measuredWidthSpec = widthSpec.1
        self.measuredHeightSpec = heightSpec.1
    }

    internal func getRules(_ layoutDirection: UIUserInterfaceLayoutDirection) -> [Int] {
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
    fileprivate func resolveRules(_ layoutDirection: UIUserInterfaceLayoutDirection) {
        let isLayoutRtl = layoutDirection == .rightToLeft

        // Reset to initial state
        for (idx, value) in initialRules.enumerated() {
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


    fileprivate func shouldResolveRules(_ layoutDirection: UIUserInterfaceLayoutDirection) -> Bool {
        return (needsLayoutResolution || hasRelativeRules()) && (rulesChanged || layoutDirection != self.layoutDirection)
    }

    fileprivate func shouldResolveMargins(_ layoutDirection: UIUserInterfaceLayoutDirection) -> Bool {
        return marginsChanged || layoutDirection != self.layoutDirection
    }

    fileprivate func setRule(_ verb: Int, subject: Int) {
        // If we're removing a relative rule, we'll need to force layout
        // resolution the next time it's requested.
        if (!needsLayoutResolution && isRelativeRule(verb)
                && initialRules[verb] != 0 && subject == 0) {
            needsLayoutResolution = true
        }

        rules[verb] = subject
        initialRules[verb] = subject
        rulesChanged = true;
        if let rl = view.superview as? ALSRelativeLayout {
            rl.dirtyHierarchy = true
        }
    }

    fileprivate func getRule(_ verb: Int) -> Int {
        return rules[verb]
    }

    fileprivate func setBoolRule(_ verb: Int, subjectBool: Bool) {
        self.setRule(verb, subject: subjectBool ? ALSRelativeLayout.TRUE : 0)
    }

    fileprivate func getBoolRule(_ verbBool: Int) -> Bool {
        return rules[verbBool] == ALSRelativeLayout.TRUE
    }

    fileprivate func hasRelativeRules() -> Bool {
        return initialRules[ALSRelativeLayout.LEADING_OF] != 0 || initialRules[ALSRelativeLayout.TRAILING_OF] != 0 || initialRules[ALSRelativeLayout.ALIGN_LEADING] != 0 || initialRules[ALSRelativeLayout.ALIGN_TRAILING] != 0 || initialRules[ALSRelativeLayout.ALIGN_PARENT_LEADING] != 0 || initialRules[ALSRelativeLayout.ALIGN_PARENT_TRAILING] != 0
    }

    fileprivate func isRelativeRule(_ rule: Int) -> Bool {
        return rule == ALSRelativeLayout.LEADING_OF || rule == ALSRelativeLayout.TRAILING_OF || rule == ALSRelativeLayout.ALIGN_LEADING || rule == ALSRelativeLayout.ALIGN_TRAILING || rule == ALSRelativeLayout.ALIGN_PARENT_LEADING || rule == ALSRelativeLayout.ALIGN_PARENT_TRAILING
    }

    internal enum MeasureSpecMode {
        case unspecified, atMost, exactly
    }

    internal typealias MeasureSpec = (CGFloat, MeasureSpecMode)
    internal typealias MeasureStates = (MeasureSpecMode, MeasureSpecMode)
}
