//
//  CreateEmployeeController.swift
//  IntermediateTraining
//
//  Created by Christophe Bugnon on 09/03/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import UIKit

class CreateEmployeeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Employee"
        
        view.backgroundColor = .darkBlue
        
        setupCancelButton()
    }
}
