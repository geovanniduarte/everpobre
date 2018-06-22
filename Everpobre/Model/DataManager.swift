//
//  DataManager.swift
//  Everpobre
//
//  Created by Mobile Sevenminds on 4/12/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    
    static let sharedManager = DataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Everpobre")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let err = error as NSError? {
                //error handle.
                print(err)
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
        })
        return container
    }()
    
    
}
