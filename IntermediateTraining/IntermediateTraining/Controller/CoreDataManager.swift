//
//  CoreDataManager.swift
//  IntermediateTraining
//
//  Created by Christophe Bugnon on 04/03/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContrainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IntermediateTrainingModels")
        container.loadPersistentStores { (storeDescription, error) in
            if let err = error {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
}
