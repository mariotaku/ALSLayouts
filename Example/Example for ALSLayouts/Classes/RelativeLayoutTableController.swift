//
//  RelativeLayoutTableController.swift
//  ALSLayouts
//
//  Created by Mariotaku Lee on 16/9/3.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell

class RelativeLayoutTableController: UITableViewController {
    
    var hideProfileImage: Bool = false
    
    @IBAction func toggleProfileImage(sender: AnyObject) {
        self.hideProfileImage = !self.hideProfileImage
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RelativeLayoutItem", forIndexPath: indexPath) as! RelativeLayoutTableCell
        cell.profileImageView.layoutParams.hidden = self.hideProfileImage
        cell.display(LoremLpsum.data[indexPath.item % LoremLpsum.data.count])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.fd_heightForCellWithIdentifier("RelativeLayoutItem", cacheByIndexPath: indexPath) { cell in
            let tableCell = cell as! RelativeLayoutTableCell
            tableCell.profileImageView.layoutParams.hidden = self.hideProfileImage
            tableCell.display(LoremLpsum.data[indexPath.item % LoremLpsum.data.count])
        }
    }
    
}