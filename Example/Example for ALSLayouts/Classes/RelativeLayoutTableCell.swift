//
//  RelativeLayoutTableCell.swift
//  ALSLayouts
//
//  Created by Mariotaku Lee on 16/9/3.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import ALSLayouts

class RelativeLayoutTableCell: UITableViewCell {
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let layout = contentView.subviews.first as! ALSRelativeLayout
        var contentSize = layout.sizeThatFits(size)
        contentSize.width += contentView.layoutMargins.left + contentView.layoutMargins.right
        contentSize.height += contentView.layoutMargins.top + contentView.layoutMargins.bottom
        return contentSize
    }
    
}