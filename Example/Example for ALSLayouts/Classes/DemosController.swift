//
//  ViewController.swift
//  ALSLayouts
//
//  Created by Mariotaku Lee on 09/01/2016.
//  Copyright (c) 2016 Mariotaku Lee. All rights reserved.
//

import UIKit

class DemosController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleManualLaunch(indexPath)
    }
    
    func handleManualLaunch(_ indexPath: IndexPath) -> Bool {
        switch (indexPath as NSIndexPath).section {
        case 0:
            switch (indexPath as NSIndexPath).item {
            case 1:
                let vc = FrameLayoutByCodeController()
                navigationController?.show(vc, sender: self)
                return true
            default:
                return false
            }
        case 1:
            switch (indexPath as NSIndexPath).item {
            case 1:
                let vc = RelativeLayoutByCodeController()
                navigationController?.show(vc, sender: self)
                return true
            default:
                return false
            }
        case 2:
            switch (indexPath as NSIndexPath).item {
            case 1:
                let vc = LinearLayoutByCodeController()
                navigationController?.show(vc, sender: self)
                return true
            default:
                return false
            }
        default:
            return false
        }
    }
}

