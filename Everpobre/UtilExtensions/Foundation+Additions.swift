//
//  Foundation+Additions.swift
//  Everpobre
//
//  Created by Mobile Sevenminds on 4/26/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit

extension Date {
    func  formattedDate() -> String {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: self)
        return date
    }
}
