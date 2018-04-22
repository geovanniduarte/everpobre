//
//  FormCell.swift
//  Everpobre
//
//  Created by Mobile Sevenminds on 4/20/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit

class FormCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var edtName: UITextField!
    @IBOutlet var imgUsar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
