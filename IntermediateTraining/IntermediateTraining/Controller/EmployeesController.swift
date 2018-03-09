//
//  EmployeeController.swift
//  IntermediateTraining
//
//  Created by Christophe Bugnon on 09/03/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import UIKit

class EmployeesController: UITableViewController {
    
    var company: Company?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.darkBlue
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        
    }
    
    @objc private func handleAdd() {
        let createEmployeeController = CreateEmployeeController()
        let navController = UINavigationController(rootViewController: createEmployeeController)
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
}
