//
//  FrameLayoutCell.swift
//  ALSLayouts
//
//  Created by Mariotaku Lee on 16/9/4.
//  Copyright © 2016年 Mariotaku. All rights reserved.
//

import UIKit
import ALSLayouts

class FrameLayoutTableCell: UITableViewCell {
    
    @IBOutlet weak var centerLabel: UILabel!
    
    func display(_ hideCenter: Bool) {
        let layout = contentView.subviews.first as! ALSBaseLayout
        centerLabel.layoutParams.hidden = hideCenter
        layout.setNeedsLayout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
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
