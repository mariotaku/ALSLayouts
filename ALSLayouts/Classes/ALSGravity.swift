/*
 * Copyright (C) 2006 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation

/**
 * Standard constants and tools for placing an object within a potentially
 * larger container.
 */
public class ALSGravity {
    
    /** Constant indicating that no gravity has been set **/
    public static let NO_GRAVITY: Int = 0x0000
    
    /** Raw bit indicating the gravity for an axis has been specified. */
    static let AXIS_SPECIFIED: Int = 0x0001
    
    /** Raw bit controlling how the left/top edge is placed. */
    static let AXIS_PULL_BEFORE: Int = 0x0002
    /** Raw bit controlling how the right/bottom edge is placed. */
    static let AXIS_PULL_AFTER: Int = 0x0004
    /** Raw bit controlling whether the right/bottom edge is clipped to its
     * container, based on the gravity direction being applied. */
    static let AXIS_CLIP: Int = 0x0008
    
    /** Bits defining the horizontal axis. */
    static let AXIS_X_SHIFT: Int = 0
    /** Bits defining the vertical axis. */
    static let AXIS_Y_SHIFT: Int = 4

    
    /**
     * Push object to the top of its container, not changing its size.
     */
    public static let TOP = (AXIS_PULL_BEFORE | AXIS_SPECIFIED) << AXIS_Y_SHIFT
    /**
     * Push object to the bottom of its container, not changing its size.
     */
    public static let BOTTOM = (AXIS_PULL_AFTER | AXIS_SPECIFIED) << AXIS_Y_SHIFT
    /**
     * Push object to the left of its container, not changing its size.
     */
    public static let LEFT = (AXIS_PULL_BEFORE | AXIS_SPECIFIED) << AXIS_X_SHIFT
    /**
     * Push object to the right of its container, not changing its size.
     */
    public static let RIGHT = (AXIS_PULL_AFTER | AXIS_SPECIFIED) << AXIS_X_SHIFT
    
    /**
     * Place object in the vertical center of its container, not changing its
     * size.
     */
    public static let CENTER_VERTICAL = AXIS_SPECIFIED << AXIS_Y_SHIFT
    /**
     * Grow the vertical size of the object if needed so it completely fills
     * its container.
     */
    public static let FILL_VERTICAL = TOP | BOTTOM
    
    /**
     * Place object in the horizontal center of its container, not changing its
     * size.
     */
    public static let CENTER_HORIZONTAL = AXIS_SPECIFIED << AXIS_X_SHIFT
    /**
     * Grow the horizontal size of the object if needed so it completely fills
     * its container.
     */
    public static let FILL_HORIZONTAL = LEFT | RIGHT
    
    /**
     * Place the object in the center of its container in both the vertical
     * and horizontal axis, not changing its size.
     */
    public static let CENTER = CENTER_VERTICAL | CENTER_HORIZONTAL
    
    /**
     * Grow the horizontal and vertical size of the object if needed so it
     * completely fills its container.
     */
    public static let FILL = FILL_VERTICAL | FILL_HORIZONTAL
    
    /**
     * Flag to clip the edges of the object to its container along the
     * vertical axis.
     */
    public static let CLIP_VERTICAL = AXIS_CLIP << AXIS_Y_SHIFT
    
    /**
     * Flag to clip the edges of the object to its container along the
     * horizontal axis.
     */
    public static let CLIP_HORIZONTAL = AXIS_CLIP << AXIS_X_SHIFT
    
    /**
     * Raw bit controlling whether the layout direction is relative or not (LEADING/TRAILING instead of
     * absolute LEFT/RIGHT).
     */
    static let RELATIVE_LAYOUT_DIRECTION = 0x00800000
    
    /**
     * Binary mask to get the absolute horizontal gravity of a gravity.
     */
    static let HORIZONTAL_GRAVITY_MASK = (AXIS_SPECIFIED | AXIS_PULL_BEFORE | AXIS_PULL_AFTER) << AXIS_X_SHIFT
    /**
     * Binary mask to get the vertical gravity of a gravity.
     */
    static let VERTICAL_GRAVITY_MASK = (AXIS_SPECIFIED | AXIS_PULL_BEFORE | AXIS_PULL_AFTER) << AXIS_Y_SHIFT
    
    /**
     * Special constant to enable clipping to an overall display along the
     * vertical dimension.  This is not applied by default by
     * [.apply]; you must do so
     * yourself by calling [.applyDisplay].
     */
    static let DISPLAY_CLIP_VERTICAL = 0x10000000
    
    /**
     * Special constant to enable clipping to an overall display along the
     * horizontal dimension.  This is not applied by default by
     * [.apply]; you must do so
     * yourself by calling [.applyDisplay].
     */
    static let DISPLAY_CLIP_HORIZONTAL = 0x01000000
    
    /**
     * Push object to x-axis position at the start of its container, not changing its size.
     */
    public static let LEADING = RELATIVE_LAYOUT_DIRECTION | LEFT
    
    /**
     * Push object to x-axis position at the end of its container, not changing its size.
     */
    public static let TRAILING = RELATIVE_LAYOUT_DIRECTION | RIGHT
    
    /**
     * Binary mask for the horizontal gravity and script specific direction bit.
     */
    static let RELATIVE_HORIZONTAL_GRAVITY_MASK = LEADING | TRAILING

    
    /**
     * Apply a gravity constant to an object.
     *
     * @param gravity   The desired placement of the object, as defined by the
     *                  constants in this class.
     *
     * @param w         The horizontal size of the object.
     *
     * @param h         The vertical size of the object.
     *
     * @param container The frame of the containing space, in which the object
     *                  will be placed.  Should be large enough to contain the
     *                  width and height of the object.
     *
     * @param xAdj      Offset to apply to the X axis.  If gravity is LEFT this
     *                  pushes it to the right; if gravity is RIGHT it pushes it to
     *                  the left; if gravity is CENTER_HORIZONTAL it pushes it to the
     *                  right or left; otherwise it is ignored.
     *
     * @param yAdj      Offset to apply to the Y axis.  If gravity is TOP this pushes
     *                  it down; if gravity is BOTTOM it pushes it up; if gravity is
     *                  CENTER_VERTICAL it pushes it down or up; otherwise it is
     *                  ignored.
     *
     * @param outRect   Receives the computed frame of the object in its
     *                  container.
     */
    static func apply(gravity: Int, w: CGFloat, h: CGFloat, container: CGRect, inout outRect: CGRect, xAdj: CGFloat = 0, yAdj: CGFloat = 0) {
        switch (gravity & ((AXIS_PULL_BEFORE | AXIS_PULL_AFTER) << AXIS_X_SHIFT)) {
        case 0:
            outRect.left = container.left + ((container.right - container.left - w) / 2) + xAdj
            outRect.right = outRect.left + w
            if ((gravity & (AXIS_CLIP << AXIS_X_SHIFT)) == (AXIS_CLIP << AXIS_X_SHIFT)) {
                if (outRect.left < container.left) {
                    outRect.left = container.left
                }
                if (outRect.right > container.right) {
                    outRect.right = container.right
                }
            }
        case AXIS_PULL_BEFORE << AXIS_X_SHIFT:
            outRect.left = container.left + xAdj
            outRect.right = outRect.left + w
            if ((gravity & (AXIS_CLIP << AXIS_X_SHIFT)) == (AXIS_CLIP << AXIS_X_SHIFT)) {
                if (outRect.right > container.right) {
                    outRect.right = container.right
                }
                
            }
        case AXIS_PULL_AFTER << AXIS_X_SHIFT:
            outRect.right = container.right - xAdj
            outRect.left = outRect.right - w
            if ((gravity & (AXIS_CLIP << AXIS_X_SHIFT)) == (AXIS_CLIP << AXIS_X_SHIFT)) {
                if (outRect.left < container.left) {
                    outRect.left = container.left
                }
                
            }
        default:
            outRect.left = container.left + xAdj
            outRect.right = container.right + xAdj
            
        }
        
        
        switch (gravity & ((AXIS_PULL_BEFORE | AXIS_PULL_AFTER) << AXIS_Y_SHIFT)) {
        case 0:
            outRect.top = container.top + ((container.bottom - container.top - h) / 2) + yAdj
            outRect.bottom = outRect.top + h
            if ((gravity & (AXIS_CLIP << AXIS_Y_SHIFT)) == (AXIS_CLIP << AXIS_Y_SHIFT)) {
                if (outRect.top < container.top) {
                    outRect.top = container.top
                }
                if (outRect.bottom > container.bottom) {
                    outRect.bottom = container.bottom
                }
            }
            
        case AXIS_PULL_BEFORE << AXIS_Y_SHIFT:
            outRect.top = container.top + yAdj
            outRect.bottom = outRect.top + h
            if ((gravity & (AXIS_CLIP << AXIS_Y_SHIFT)) == (AXIS_CLIP << AXIS_Y_SHIFT)) {
                if (outRect.bottom > container.bottom) {
                    outRect.bottom = container.bottom
                }
            }
            
        case AXIS_PULL_AFTER << AXIS_Y_SHIFT:
            outRect.bottom = container.bottom - yAdj
            outRect.top = outRect.bottom - h
            if ((gravity & (AXIS_CLIP << AXIS_Y_SHIFT)) == (AXIS_CLIP << AXIS_Y_SHIFT)) {
                if (outRect.top < container.top) {
                    outRect.top = container.top
                }
            }
            
        default:
            outRect.top = container.top + yAdj
            outRect.bottom = container.bottom + yAdj
        }
    }
    
    /**
     * Apply a gravity constant to an object.
     *
     * @param gravity         The desired placement of the object, as defined by the
     *                        constants in this class.
     *
     * @param w               The horizontal size of the object.
     *
     * @param h               The vertical size of the object.
     *
     * @param container       The frame of the containing space, in which the object
     *                        will be placed.  Should be large enough to contain the
     *                        width and height of the object.
     *
     * @param xAdj            Offset to apply to the X axis.  If gravity is LEFT this
     *                        pushes it to the right; if gravity is RIGHT it pushes it to
     *                        the left; if gravity is CENTER_HORIZONTAL it pushes it to the
     *                        right or left; otherwise it is ignored.
     *
     * @param yAdj            Offset to apply to the Y axis.  If gravity is TOP this pushes
     *                        it down; if gravity is BOTTOM it pushes it up; if gravity is
     *                        CENTER_VERTICAL it pushes it down or up; otherwise it is
     *                        ignored.
     *
     * @param outRect         Receives the computed frame of the object in its
     *                        container.
     *
     * @param layoutDirection The layout direction.
     *
     * @see View.LAYOUT_DIRECTION_LTR
     *
     * @see View.LAYOUT_DIRECTION_RTL
     */
    static func apply(gravity: Int, w: CGFloat, h: CGFloat, container: CGRect, inout outRect: CGRect, xAdj: CGFloat = 0, yAdj: CGFloat = 0, layoutDirection: UIUserInterfaceLayoutDirection) {
        let absGravity = getAbsoluteGravity(gravity, layoutDirection: layoutDirection)
        return apply(absGravity, w: w, h: h, container: container, outRect: &outRect, xAdj: xAdj, yAdj: yAdj)
    }
    
    /**
     * Apply additional gravity behavior based on the overall "display" that an
     * object exists in.  This can be used after
     * [.apply] to place the object
     * within a visible display.  By default this moves or clips the object
     * to be visible in the display; the gravity flags
     * [.DISPLAY_CLIP_HORIZONTAL] and [.DISPLAY_CLIP_VERTICAL]
     * can be used to change this behavior.
     *
     * @param gravity  Gravity constants to modify the placement within the
     *                 display.
     *
     * @param display  The rectangle of the display in which the object is
     *                 being placed.
     *
     * @param inoutObj Supplies the current object position; returns with it
     *                 modified if needed to fit in the display.
     */
    static func applyDisplay(gravity: Int, display: CGRect) -> CGRect {
        var inoutObj = CGRectZero
        if (gravity & DISPLAY_CLIP_VERTICAL != 0) {
            if (inoutObj.top < display.top) {
                inoutObj.top = display.top
            }
            if (inoutObj.bottom > display.bottom) {
                inoutObj.bottom = display.bottom
            }
        } else {
            var off: CGFloat = 0
            if (inoutObj.top < display.top) {
                off = display.top - inoutObj.top
            } else if (inoutObj.bottom > display.bottom) {
                off = display.bottom - inoutObj.bottom
            }
            if (off != 0) {
                if (inoutObj.size.height > display.bottom - display.top) {
                    inoutObj.top = display.top
                    inoutObj.bottom = display.bottom
                } else {
                    inoutObj.top += off
                    inoutObj.bottom += off
                }
            }
        }
        
        if (gravity & DISPLAY_CLIP_HORIZONTAL != 0) {
            if (inoutObj.left < display.left) {
                inoutObj.left = display.left
            }
            if (inoutObj.right > display.right) {
                inoutObj.right = display.right
            }
        } else {
            var off: CGFloat = 0
            if (inoutObj.left < display.left) {
                off = display.left - inoutObj.left
            } else if (inoutObj.right > display.right) {
                off = display.right - inoutObj.right
            }
            if (off != 0) {
                if (inoutObj.size.width > display.right - display.left) {
                    inoutObj.left = display.left
                    inoutObj.right = display.right
                } else {
                    inoutObj.left += off
                    inoutObj.right += off
                }
            }
        }
        
        return inoutObj
    }
    
    /**
     * Apply additional gravity behavior based on the overall "display" that an
     * object exists in.  This can be used after
     * [.apply] to place the object
     * within a visible display.  By default this moves or clips the object
     * to be visible in the display; the gravity flags
     * [.DISPLAY_CLIP_HORIZONTAL] and [.DISPLAY_CLIP_VERTICAL]
     * can be used to change this behavior.
     *
     * @param gravity         Gravity constants to modify the placement within the
     *                        display.
     *
     * @param display         The rectangle of the display in which the object is
     *                        being placed.
     *
     * @param inoutObj        Supplies the current object position; returns with it
     *                        modified if needed to fit in the display.
     *
     * @param layoutDirection The layout direction.
     *
     * @see View.LAYOUT_DIRECTION_LTR
     *
     * @see View.LAYOUT_DIRECTION_RTL
     */
    static func applyDisplay(gravity: Int, display: CGRect, inoutObj: CGRect, layoutDirection: UIUserInterfaceLayoutDirection) -> CGRect {
        let absGravity = getAbsoluteGravity(gravity, layoutDirection: layoutDirection)
        return applyDisplay(absGravity, display: display)
    }
    
    /**
     *
     * Indicate whether the supplied gravity has a vertical pull.
     *
     * @param gravity the gravity to check for vertical pull
     *
     * @return true if the supplied gravity has a vertical pull
     */
    static func isVertical(gravity: Int) -> Bool {
        return gravity > 0 && gravity & VERTICAL_GRAVITY_MASK != 0
    }
    
    /**
     *
     * Indicate whether the supplied gravity has an horizontal pull.
     *
     * @param gravity the gravity to check for horizontal pull
     *
     * @return true if the supplied gravity has an horizontal pull
     */
    static func isHorizontal(gravity: Int) -> Bool {
        return gravity > 0 && gravity & RELATIVE_HORIZONTAL_GRAVITY_MASK != 0
    }
    
    /**
     *
     * Convert script specific gravity to absolute horizontal value.
     *
     *
     * if horizontal direction is LTR, then LEADING will set LEFT and TRAILING will set RIGHT.
     * if horizontal direction is RTL, then LEADING will set RIGHT and TRAILING will set LEFT.
     *
     * @param gravity         The gravity to convert to absolute (horizontal) values.
     *
     * @param layoutDirection The layout direction.
     *
     * @return gravity converted to absolute (horizontal) values.
     */
    static func getAbsoluteGravity(gravity: Int, layoutDirection: UIUserInterfaceLayoutDirection) -> Int {
        var result = gravity
        // If layout is script specific and gravity is horizontal relative (LEADING or TRAILING)
        if ((result & RELATIVE_LAYOUT_DIRECTION) > 0) {
            if (result & ALSGravity.LEADING == ALSGravity.LEADING) {
                // Remove the LEADING bit
                result = result & ~LEADING
                if (layoutDirection == .RightToLeft) {
                    // Set the RIGHT bit
                    result = result | RIGHT
                } else {
                    // Set the LEFT bit
                    result = result | LEFT
                }
            } else if (result & ALSGravity.TRAILING == ALSGravity.TRAILING) {
                // Remove the TRAILING bit
                result = result & ~TRAILING
                if (layoutDirection == .RightToLeft) {
                    // Set the LEFT bit
                    result = result | LEFT
                } else {
                    // Set the RIGHT bit
                    result = result | RIGHT
                }
            }
            // Don't need the script specific bit any more, so remove it as we are converting to
            // absolute values (LEFT or RIGHT)
            result = result & ~RELATIVE_LAYOUT_DIRECTION
        }
        return result
    }
    
}