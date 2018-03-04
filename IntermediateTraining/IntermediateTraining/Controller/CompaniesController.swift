//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Christophe Bugnon on 02/03/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {

    func didAddCompany(company: Company) {
        companies.append(company)
        
        let lastElement = companies.count - 1
        let newIndexPath = IndexPath(row: lastElement, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    let cellId = "cellId"
    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCompanies()
        
        navigationItem.title = "Companies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        
        tableView.backgroundColor = .darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

    }
    
    private func fetchCompanies() {
        // Attemps my core data fetch somehow...
        let context = CoreDataManager.shared.persistentContrainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            
            companies.forEach({ (company) in
                print(company.name ?? "")
            })
            
            self.companies = companies
            self.tableView.reloadData()
            
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
        }
    }
    
    @objc func handleAddCompany() {
        print("Adding company...")
        
        let createCompanyController = CreateCompanyController()
        
        let navBarController = CustomNavigationController(rootViewController: createCompanyController)
        
        createCompanyController.delegate = self
        
        present(navBarController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let company = self.companies[indexPath.row]
            print("Attempting to delete company", company.name ?? "")
            
            // Remove our company from our tableView
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // delete the company from the Core Data
            let context = CoreDataManager.shared.persistentContrainer.viewContext
            
            context.delete(company)
            
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to delete company", saveErr)
            }
            
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (_, indexPath) in
            print("Attemps to edit company")
        }
        
        return [deleteAction, editAction]
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = .tealColor
        
        let company = companies[indexPath.row]
        
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return cell
    }
    
}


