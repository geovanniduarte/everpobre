//
//  NotebookViewController.swift
//  Everpobre
//
//  Created by Mobile Sevenminds on 4/19/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit

class NotebookViewController: UIViewController {
    
    let edtNotebookName = UITextField()
    let lblNotebookName = UITextView()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func loadView() {
        let backView = UIView()
        
        backView.addSubview(lblNotebookName)
        backView.addSubview(edtNotebookName)
        
        
        lblNotebookName.translatesAutoresizingMaskIntoConstraints = false;
        edtNotebookName.translatesAutoresizingMaskIntoConstraints = false;
        
        let dictViews = ["lblNotebookName":lblNotebookName, "edtNotebookName":edtNotebookName]
        
        let constrains = NSLayoutConstraint.constraints(withVisualFormat: "|-10-[lblNotebookName]-20-[edtNotebookName]-10|", options: [], metrics: nil, views: dictViews)
        
        constrains.append(contentsOf: NSLayoutConstraint)
        
        
        self.view = backView
    }

}
