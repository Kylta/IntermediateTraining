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
    
    func fetchCompanies() -> [Company] {
        
        let context = persistentContrainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
            return []
        }
    }
    
    func resetCompanies(completion: () -> ()) {
        
        let context = persistentContrainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            completion()
        } catch let delErr {
            print("Failed to delete objects from Core Data:", delErr)
        }
    }
    
    func createEmployee(employeeName: String) -> Error? {
        
        let context = persistentContrainer.viewContext
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
        
        employee.setValue(employeeName, forKey: "name")
        
        do {
            try context.save()
            return nil
        } catch let err {
            print("Failed to create employee:", err)
            return err
        }
    }

}
