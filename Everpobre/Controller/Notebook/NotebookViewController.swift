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
    let lblNotebookName = UILabel()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func loadView() {
        let backView = UIView()
        backView.backgroundColor = .white
        
        lblNotebookName.text = "Name"
        lblNotebookName.backgroundColor = UIColor.red
        backView.addSubview(lblNotebookName)
        
        edtNotebookName.placeholder = "Placeholder"
        backView.addSubview(edtNotebookName)
        
        
        lblNotebookName.translatesAutoresizingMaskIntoConstraints = false;
        edtNotebookName.translatesAutoresizingMaskIntoConstraints = false;
        
        let dictViews = ["lblNotebookName":lblNotebookName, "edtNotebookName":edtNotebookName]
        
        var constrains = NSLayoutConstraint.constraints(withVisualFormat: "|-10-[lblNotebookName]-20-[edtNotebookName]-10-|", options: [], metrics: nil, views: dictViews)
        
       

        constrains.append(NSLayoutConstraint(item: lblNotebookName, attribute: .top, relatedBy: .equal, toItem: backView.layoutMarginsGuide, attribute: .top, multiplier: 1, constant: 20))
        
       constrains.append(NSLayoutConstraint(item: edtNotebookName, attribute: .top, relatedBy: .equal, toItem: backView.layoutMarginsGuide, attribute: .top, multiplier: 1, constant: 20))
        
        backView.addConstraints(constrains)
        
        self.view = backView
    }

}
