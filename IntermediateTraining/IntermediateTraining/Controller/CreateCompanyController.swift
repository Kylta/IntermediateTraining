//
//  CreateCompanyController.swift
//  IntermediateTraining
//
//  Created by Christophe Bugnon on 02/03/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import UIKit
import CoreData

// Custom delegation
protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
}

class CreateCompanyController: UIViewController {
    
    var delegate: CreateCompanyControllerDelegate?
    
    let lightBackgroundView: UIView = {
        let uv = UIView()
        uv.backgroundColor = .lightBlue
        uv.translatesAutoresizingMaskIntoConstraints = false
        return uv
    }()
    
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
        
        navigationItem.title = "Create Company"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        view.backgroundColor = .darkBlue
        
        setupUI()
        
    }
    
    @objc func handleSave() {
        
        // Initialization of our Core Data stack
        let persistentContainer = NSPersistentContainer(name: "IntermediateTrainingModels")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let err = error {
                fatalError("Loading of store failed: \(err)")
            }
        }
        
        let context = persistentContainer.viewContext
        
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        company.setValue(nameTextField.text, forKey: "name")
        
        // Perform the save
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to save company: ", saveErr)
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        
        view.addSubview(lightBackgroundView)
        lightBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBackgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
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
