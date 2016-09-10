//
//  FrameLayoutTableController.swift
//  ALSLayouts
//
//  Created by Mariotaku Lee on 16/9/4.
//  Copyright © 2016年 Mariotaku. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell

class FrameLayoutTableController: UITableViewController {

    override func viewDidLoad() {
        tableView.estimatedRowHeight = 60
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FrameLayoutItem", forIndexPath: indexPath) as! FrameLayoutTableCell
        cell.display(indexPath.item % 2 == 0)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.fd_heightForCellWithIdentifier("FrameLayoutItem", cacheByIndexPath: indexPath) { cell in
            (cell as! FrameLayoutTableCell).display(indexPath.item % 2 == 0)
        }
    }
    
}
