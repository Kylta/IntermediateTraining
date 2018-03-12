//
//  CreateEmployeeController.swift
//  IntermediateTraining
//
//  Created by Christophe Bugnon on 09/03/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    var delegate: CreateEmployeeControllerDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Employee"
        
        view.backgroundColor = .darkBlue
        
        setupCancelButton()
        setupSaveInNavBar(selector: #selector(handleSave))
        
        _ = setupLightBlueBackgroundView(height: 50)
        
        setupUI()

    }
    
    @objc private func handleSave() {

        guard let employeeName = nameTextField.text else { return }
        
        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName)
        
        if let error = tuple.1 {
            // is where you present an error modal of some kind
            // perhaps use a UIAlertController to show your error message
            print(error)
        } else {
            dismiss(animated: true, completion: {
                self.delegate?.didAddEmployee(employee: tuple.0!)
            })
        }
    }
    
    private func setupUI() {
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true

    }
}
