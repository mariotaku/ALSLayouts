//
//  LinearLayoutByCodeController.swift
//  ALSLayouts
//
//  Created by Mariotaku Lee on 16/9/4.
//  Copyright © 2016年 Mariotaku. All rights reserved.
//

import UIKit
import ALSLayouts

class LinearLayoutByCodeController: UIViewController {
    
    override func viewDidLoad() {
        let layout = ALSLinearLayout()
        layout.orientation = .Vertical
        layout.backgroundColor = UIColor.whiteColor()
        layout.gravity = ALSGravity.CENTER
        self.view = layout
        self.title = "LinearLayout code"
        
        for i in 1...5 {
            let label = UILabel()
            label.text = String(i)
            label.textColor = UIColor.darkTextColor()
            layout.addSubview(label) { lp in
                lp.widthMode = .WrapContent
                lp.heightMode = .WrapContent
            }
        }
    }
    
}