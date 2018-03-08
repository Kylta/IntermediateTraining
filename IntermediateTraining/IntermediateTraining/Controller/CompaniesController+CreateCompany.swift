//
//  CompaniesController+CreateCompany.swift
//  IntermediateTraining
//
//  Created by Christophe Bugnon on 08/03/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegate {
    
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
    
}
