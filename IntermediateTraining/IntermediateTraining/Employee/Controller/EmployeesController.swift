//
//  EmployeeController.swift
//  IntermediateTraining
//
//  Created by Christophe Bugnon on 09/03/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import UIKit
import CoreData

class IndentedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: customRect)
    }
}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    
    var company: Company?
    var employees = [Employee]()
    let cellId = "cellId"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCompany()
        
        tableView.backgroundColor = UIColor.darkBlue
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allEmployees[section].count
//        if section == 0 {
//            return shortNameEmployees.count
//        }
//        return longNameEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
//        let employee = employees[indexPath.row]
        
//        let employee = indexPath.section == 0 ? shortNameEmployees[indexPath.row] : longNameEmployees[indexPath.row]
        
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = employee.name

        if let birthday = employee.employeeinformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            
            cell.textLabel?.text = "\(employee.name ?? "")   \(dateFormatter.string(from: birthday))"
        }
        
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .tealColor
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        
        if section == 0 {
            label.text = "Short Names"
        } else if section == 1 {
            label.text = "Long Names"
        } else {
            label.text = "Very long Names"
        }
        
        label.textColor = .darkBlue
        label.backgroundColor = .lightBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    var shortNameEmployees = [Employee]()
    var longNameEmployees = [Employee]()
    var veryLongNameEmployees = [Employee]()
    
    var allEmployees = [[Employee]]()
    
    private func fetchCompany() {
        
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        
        shortNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count < 6
            }
            return false
        })
        
        longNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count >= 6 && count < 9
            }
            return false
        })
        
        veryLongNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count >= 9
            }
            return false
        })
        
        allEmployees = [
            shortNameEmployees,
            longNameEmployees,
            veryLongNameEmployees
        ]
        
        print(shortNameEmployees.count, longNameEmployees.count, veryLongNameEmployees.count)
    
//        self.employees = companyEmployees
    }
    
    @objc private func handleAdd() {
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
}
