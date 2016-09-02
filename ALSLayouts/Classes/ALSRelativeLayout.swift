//
//  ALSRelativeLayout.swift
//  Pods
//
//  Created by Mariotaku Lee on 16/9/2.
//
//

import UIKit

public class ALSRelativeLayout: ALSBaseLayout {
    
    var nodesNeedsRebuild: Bool = true
    
    public override func didAddSubview(subview: UIView) {
        nodesNeedsRebuild = true
    }
    
    public override func willRemoveSubview(subview: UIView) {
        nodesNeedsRebuild = true
    }
    
}