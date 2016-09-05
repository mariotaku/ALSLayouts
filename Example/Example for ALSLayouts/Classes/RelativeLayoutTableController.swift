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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "RelativeLayoutCell", bundle: nil), forCellReuseIdentifier: "RelativeLayoutNibCell")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Storyboard" : "Nib"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let name = indexPath.section == 0 ? "RelativeLayoutItem" : "RelativeLayoutNibCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(name, forIndexPath: indexPath) as! RelativeLayoutTableCell
        cell.profileImageView.layoutParams.hidden = self.hideProfileImage
        cell.display(LoremLpsum.data[indexPath.item % LoremLpsum.data.count])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let name = indexPath.section == 0 ? "RelativeLayoutItem" : "RelativeLayoutNibCell"
        
        return tableView.fd_heightForCellWithIdentifier(name, cacheByIndexPath: indexPath) { cell in
            let tableCell = cell as! RelativeLayoutTableCell
            tableCell.profileImageView.layoutParams.hidden = self.hideProfileImage
            tableCell.display(LoremLpsum.data[indexPath.item % LoremLpsum.data.count])
        }
    }
    
}