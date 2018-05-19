//
//  UISplitViewControllerFirstMaster.swift
//  Everpobre
//
//  Created by Mobile Sevenminds on 5/18/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit

class UISplitViewControllerFirstMaster: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
