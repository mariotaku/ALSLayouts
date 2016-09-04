//
//  LinearLayoutTableController.swift
//  ALSLayouts
//
//  Created by Mariotaku Lee on 16/9/4.
//  Copyright © 2016年 Mariotaku. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell

class LinearLayoutTableController: UITableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LinearLayoutItem", forIndexPath: indexPath) as! LinearLayoutTableCell
        cell.display(LoremLpsum.data[indexPath.item % LoremLpsum.data.count])
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.fd_heightForCellWithIdentifier("LinearLayoutItem", cacheByIndexPath: indexPath) { cell in
            let tableCell = cell as! LinearLayoutTableCell
            tableCell.display(LoremLpsum.data[indexPath.item % LoremLpsum.data.count])
        }
    }
}