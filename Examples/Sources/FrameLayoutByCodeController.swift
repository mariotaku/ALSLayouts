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
        layout.backgroundColor = UIColor.white
        self.view = layout
        self.title = "FrameLayout code"
        
        let label = UILabel()
        label.text = "AutoLayout Sucks"
        label.textColor = UIColor.darkText
        layout.addSubview(label) { lp in
            lp.widthMode = .wrapContent
            lp.heightMode = .wrapContent
            lp.gravity = ALSGravity.CENTER
        }
    }
}
