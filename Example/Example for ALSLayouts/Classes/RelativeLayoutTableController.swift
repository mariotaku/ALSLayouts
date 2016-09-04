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
    
    let data: [String] = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla aliquam risus quis nulla feugiat porttitor. Ut ornare orci et lectus dapibus, nec imperdiet massa tempor.",
        "Ut in turpis sed ex sagittis accumsan quis sed nisi. Donec porta est velit, at molestie nisi ornare at. Maecenas felis magna, dignissim ac pulvinar vel, pulvinar at libero.",
        "Donec purus lectus, aliquam id consequat vitae, sodales vel mauris. Nam tempor gravida suscipit. In semper turpis at nibh dapibus, in vehicula tellus pharetra. Maecenas vel venenatis neque, eu hendrerit erat.",
        "Donec ut metus sit amet ipsum dictum lobortis. Vivamus vulputate nulla eget eros sodales, at efficitur ante pretium. Vestibulum massa nisl, tincidunt posuere libero eu, porttitor tristique tortor.",
        "Aenean luctus vitae orci nec mollis. Morbi vehicula, mauris in eleifend finibus, neque erat finibus elit, a porttitor quam purus sit amet lectus. Aenean aliquet mi quis erat efficitur, at aliquet eros feugiat.",
        "Vivamus et mollis risus. Donec eu mi eget nibh lacinia fringilla. Nunc pretium magna orci, non interdum nisl porta vestibulum. In dictum interdum augue, ultricies sodales urna volutpat quis. Integer sagittis elementum ipsum, ut porttitor dolor.",
        "Pellentesque venenatis blandit risus, quis egestas ipsum bibendum quis. Nam eu libero auctor, ornare nisl ut, cursus felis. Etiam facilisis finibus egestas. Nam vel urna quis augue efficitur luctus. Nam placerat elit quis vehicula egestas.",
        "Duis consectetur nunc enim, vel consequat magna lobortis in. Maecenas egestas blandit mollis. Sed faucibus volutpat hendrerit. Donec eget odio fermentum, vestibulum augue quis, porttitor turpis.",
        "In vel hendrerit nisi. Maecenas efficitur metus sit amet venenatis sagittis. Mauris et magna vulputate, luctus nisi sed, aliquam lorem. Morbi lacinia eu sem et congue. Etiam laoreet tellus quis feugiat ullamcorper.",
        "Cras maximus iaculis quam, at auctor dolor mattis eget. Etiam aliquet est quam, eget volutpat justo malesuada vitae. Pellentesque elit nulla, suscipit nec erat id, sagittis elementum purus.",
        "Duis in justo nunc. Pellentesque in suscipit erat. Pellentesque eu consectetur eros. Fusce condimentum ullamcorper nunc, eget euismod orci auctor nec. In erat turpis, rhoncus eu dignissim non, vehicula at mi.",
        "Pellentesque malesuada molestie nisl et pharetra. Aliquam leo nulla, accumsan in metus et, placerat commodo erat. Quisque placerat, quam at lacinia semper, eros massa dignissim turpis, at vulputate sapien orci in est.",
        "Nullam velit quam, viverra in egestas nec, ultricies vitae tellus. Cras laoreet tincidunt dui nec pharetra. Donec ultricies sollicitudin arcu, nec auctor enim vehicula eu. Duis eu tellus vitae urna condimentum egestas nec sit amet mi.",
        "Integer non sapien nec velit luctus varius. Vivamus eget urna a risus finibus vulputate. Sed ut est vel leo ultricies cursus. Aenean vel dolor est. Duis aliquet arcu sit amet justo ornare scelerisque.",
        "Phasellus venenatis aliquet massa, condimentum suscipit est. Nunc ut viverra lorem."
    ]
    
    @IBAction func toggleProfileImage(sender: AnyObject) {
        self.hideProfileImage = !self.hideProfileImage
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.fd_debugLogEnabled = true
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ExampleItem", forIndexPath: indexPath) as! RelativeLayoutTableCell
        cell.profileImageView.layoutParams?.hidden = self.hideProfileImage
        cell.display(data[indexPath.item % data.count])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.fd_heightForCellWithIdentifier("ExampleItem", cacheByIndexPath: indexPath) { cell in
            let tableCell = cell as! RelativeLayoutTableCell
            tableCell.profileImageView.layoutParams?.hidden = self.hideProfileImage
            tableCell.display(self.data[indexPath.item % self.data.count])
        }
    }
    
}