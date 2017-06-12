//
//  RelativeLayoutTableController.swift
//  ALSLayouts
//
//  Created by Mariotaku Lee on 16/9/3.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class RelativeLayoutTableController: UITableViewController {
    
    var hideProfileImage: Bool = false
    
    @IBAction func toggleProfileImage(_ sender: AnyObject) {
        self.hideProfileImage = !self.hideProfileImage
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RelativeLayoutCell", bundle: nil), forCellReuseIdentifier: "RelativeLayoutNibCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Storyboard" : "Nib"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let name = (indexPath as NSIndexPath).section == 0 ? "RelativeLayoutItem" : "RelativeLayoutNibCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: name, for: indexPath) as! RelativeLayoutTableCell
        cell.profileImageView.layoutParams.hidden = self.hideProfileImage
        cell.display(LoremLpsum.data[(indexPath as NSIndexPath).item % LoremLpsum.data.count])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
