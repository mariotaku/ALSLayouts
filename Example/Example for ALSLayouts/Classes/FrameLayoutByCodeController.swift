//
//  FrameLayoutByCodeController.swift
//  ALSLayouts
//
//  Created by Mariotaku Lee on 16/9/2.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import ALSLayouts

class FrameLayoutByCodeController: UIViewController {
    override func viewDidLoad() {
        let layout = ALSFrameLayout()
        layout.backgroundColor = UIColor.whiteColor()
        self.view = layout
        self.title = "FrameLayout code"
        
        let label = UILabel()
        label.text = "AutoLayout Sucks"
        label.textColor = UIColor.darkTextColor()
        layout.addSubview(label) { lp in
            lp.widthMode = .WrapContent
            lp.heightMode = .WrapContent
            lp.gravity = ALSGravity.CENTER
        }
    }
}