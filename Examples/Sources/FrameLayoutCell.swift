//
//  FrameLayoutCell.swift
//  ALSLayouts
//
//  Created by Mariotaku Lee on 16/9/4.
//  Copyright © 2016年 Mariotaku. All rights reserved.
//

import UIKit
import ALSLayouts

class FrameLayoutTableCell: ALSTableViewCell {
    
    @IBOutlet weak var centerLabel: UILabel!
    
    func display(_ hideCenter: Bool) {
        let layout = contentView.subviews.first as! ALSBaseLayout
        centerLabel.layoutParams.hidden = hideCenter
        layout.setNeedsLayout()
    }
    
}
