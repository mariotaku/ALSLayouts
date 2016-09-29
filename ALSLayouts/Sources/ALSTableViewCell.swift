//
//  ALSTableViewCell.swift
//  ALSLayouts
//
//  Created by Mariotaku Lee on 2016/9/29.
//
//

import UIKit

/**
 Convenience UITableViewCell class for layout and measure correctly
 */
open class ALSTableViewCell: UITableViewCell {
    
    /// Implementation to perform calculation for content view
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let layout = contentView.subviews.first as! ALSBaseLayout
        var layoutSize = size
        layoutSize.width -= contentView.layoutMargins.left + contentView.layoutMargins.right
        layoutSize.height -= contentView.layoutMargins.top + contentView.layoutMargins.bottom
        var contentSize = layout.sizeThatFits(layoutSize)
        contentSize.width += contentView.layoutMargins.left + contentView.layoutMargins.right
        contentSize.height += contentView.layoutMargins.top + contentView.layoutMargins.bottom
        return contentSize
    }
    
}
