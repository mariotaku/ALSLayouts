//
//  RelativeLayoutTableCell.swift
//  ALSLayouts
//
//  Created by Mariotaku Lee on 16/9/3.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import ALSLayouts

class RelativeLayoutTableCell: ALSTableViewCell {
    
    @IBOutlet weak var profileImageView: UIView!
    @IBOutlet weak var textView: UILabel!
    
    func display(_ text: String) {
        textView.text = text
        let layout = contentView.subviews.first as! ALSRelativeLayout
        layout.setNeedsLayout()
    }
    
}
