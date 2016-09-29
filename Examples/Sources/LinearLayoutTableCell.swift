//
//  LinearLayoutTableCell.swift
//  ALSLayouts
//
//  Created by Mariotaku Lee on 16/9/4.
//  Copyright © 2016年 Mariotaku. All rights reserved.
//

import UIKit
import ALSLayouts

class LinearLayoutTableCell: ALSTableViewCell {
    
    @IBOutlet weak var textView: UILabel!
    
    func display(_ data: String) {
        textView.text = data
        let layout = contentView.subviews.first as! ALSBaseLayout
        layout.setNeedsLayout()
    }
    
}
