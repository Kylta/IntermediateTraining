//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Christophe Bugnon on 02/03/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {

    let cellId = "cellId"
    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.companies = CoreDataManager.shared.fetchCompanies()

        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Do Updates", style: .plain, target: self, action: #selector(doNestedUpdates))
        ]
        
        navigationItem.title = "Companies"
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        
        tableView.backgroundColor = .darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)

    }
    
    @objc private func doNestedUpdates() {
        print("Trying to perfom nested updates now")
        
        DispatchQueue.global(qos: .background).async {
            
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            
            privateContext.parent = CoreDataManager.shared.persistentContrainer.viewContext
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            
            do {
                
                let companies = try privateContext.fetch(request)
                
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "F: \(company.name ?? "")"
                })
                
                do {
                    try privateContext.save()
                    
                    DispatchQueue.main.async {
                        
                        do {
                            let context = CoreDataManager.shared.persistentContrainer.viewContext
                            
                            if context.hasChanges {
                                try context.save()
                            }
                            
                            self.tableView.reloadData()
                            
                        } catch let finalSaveErr {
                            print("Failed to save main context:", finalSaveErr)
                        }
                        
                    }
                    
                } catch let saveErr {
                    print("Failed to save on private context:", saveErr)
                }
                
            } catch let fetchErr {
                print("Failed to fetch on private context:", fetchErr)
            }
            
        }
        
    }
    
    @objc private func doUpdates() {
        print("Try to updates somes new companies")
        
        CoreDataManager.shared.persistentContrainer.performBackgroundTask { (backgroundContext) in
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            
            do {
                let companies = try backgroundContext.fetch(request)
                
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "D: \(company.name ?? "")"
                })
                
                do {
                    try backgroundContext.save()
                    
                    DispatchQueue.main.async {
                        CoreDataManager.shared.persistentContrainer.viewContext.reset()
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                } catch let saveErr {
                    print("Failed to save on background:", saveErr)
                }
                
            } catch let err {
                print("Failed to fetch companies on background:", err)
            }
            
        }
    }
    
    @objc private func doWork() {
        
        CoreDataManager.shared.persistentContrainer.performBackgroundTask ({ (backgroundContext) in
            (0...5).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
            }
            
            do {
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
            } catch let err {
                print("Failed to save:", err)
            }
        })
        
    }
    
    @objc private func handleReset() {
        
        CoreDataManager.shared.resetCompanies {
            var indexPathsToRemove = [IndexPath]()
            companies.enumerated().forEach({ (index, _) in
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            })
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
        }
    }

    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        let navBarController = CustomNavigationController(rootViewController: createCompanyController)
        
        createCompanyController.delegate = self
        present(navBarController, animated: true, completion: nil)
    }

}


