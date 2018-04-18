//
//  ManagedObject.swift
//  Everpobre
//
//  Created by Mobile Sevenminds on 4/17/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import Foundation

extension Note {
    override public func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "main_title" {
            self.setValue(value, forKey: "title")
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    public override func value(forUndefinedKey key: String) -> Any? {
        if key == "main_title" {
            return "main_title"
        } else {
            return super.value(forKey: key)
        }
    }
}
