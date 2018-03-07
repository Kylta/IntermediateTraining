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
    
    func didEditCompany(company: Company) {
        
        let row = companies.index(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }

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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        navigationItem.title = "Companies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        
        tableView.backgroundColor = .darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available..."
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
    }
    
    private func fetchCompanies() {
        // Attemps my core data fetch somehow...
        let context = CoreDataManager.shared.persistentContrainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            
            companies.forEach { print($0.name ?? ""); self.companies.append($0) }
            
            self.tableView.reloadData()
            
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
        }
    }
    
    @objc private func handleReset() {
        print("Attempting to delete all core data objects")
        
        let context = CoreDataManager.shared.persistentContrainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            
            var indexPathsToRemove = [IndexPath]()
            
            companies.enumerated().forEach({ (index, _) in
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            })
            
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
            
        } catch let delErr {
            print("Failed to delete objects from Core Data:", delErr)
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
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteHandlerFunction)
        deleteAction.backgroundColor = .lightRed
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
        editAction.backgroundColor = .darkBlue
        
        return [deleteAction, editAction]
    }
    
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        print("Attempt to edit company")
        
        let editCompanyController = CreateCompanyController()
        editCompanyController.delegate = self
        editCompanyController.company = companies[indexPath.row]
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        
        present(navController, animated: true, completion: nil)
    }
    
    private func deleteHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
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
        
        if let name = company.name, let founded = company.founded {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let foundedDateString = dateFormatter.string(from: founded)
            let dateString = "\(name) - Founded: \(foundedDateString)"
            
            cell.textLabel?.text = dateString
        } else {
            cell.textLabel?.text = company.name
        }
        
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        cell.imageView?.image = #imageLiteral(resourceName: "select_photo_empty")
        
        if let imageData = company.imageData {
            cell.imageView?.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
}

