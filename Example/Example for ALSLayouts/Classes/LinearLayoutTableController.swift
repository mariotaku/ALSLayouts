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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinearLayoutItem", for: indexPath) as! LinearLayoutTableCell
        cell.display(LoremLpsum.data[(indexPath as NSIndexPath).item % LoremLpsum.data.count])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: "LinearLayoutItem", cacheBy: indexPath) { cell in
            let tableCell = cell as! LinearLayoutTableCell
            tableCell.display(LoremLpsum.data[(indexPath as NSIndexPath).item % LoremLpsum.data.count])
        }
    }
}
