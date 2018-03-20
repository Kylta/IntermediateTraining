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
            UIBarButtonItem(title: "Do Work", style: .plain, target: self, action: #selector(doWork))
        ]
        
        navigationItem.title = "Companies"
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        
        tableView.backgroundColor = .darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)

    }
    
    @objc private func doWork() {
        
        CoreDataManager.shared.persistentContrainer.performBackgroundTask ({ (backgroundContext) in
            (0...20000).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
            }
            
            do {
                try backgroundContext.save()
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


