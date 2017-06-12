//
//  RelativeLayoutByCodeController.swift
//  ALSLayouts
//
//  Created by Mariotaku Lee on 16/9/4.
//  Copyright © 2016年 Mariotaku. All rights reserved.
//

import UIKit
import ALSLayouts

class RelativeLayoutByCodeController: UIViewController {
    override func viewDidLoad() {
        let layout = ALSRelativeLayout()
        layout.backgroundColor = UIColor.white
        self.view = layout
        self.title = "RelativeLayout code"
        
        let centerLabel = UILabel()
        centerLabel.text = "Center"
        centerLabel.textColor = UIColor.darkText
        layout.addSubview(centerLabel, tagString: "centerLabel") { lp in
            lp.widthMode = .wrapContent
            lp.heightMode = .wrapContent
            lp.centerInParent = true
        }
        
        let fooLabel = UILabel()
        fooLabel.text = "Foo below center"
        fooLabel.textColor = UIColor.darkText
        
        layout.addSubview(fooLabel, tagString: "fooLabel") { lp in
            lp.widthMode = .wrapContent
            lp.heightMode = .wrapContent
            lp.belowTag = "centerLabel"
            lp.centerHorizontal = true
        }
    }
}
