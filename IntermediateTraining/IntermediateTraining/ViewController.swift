//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Christophe Bugnon on 02/03/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow

        navigationItem.title = "Companies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        
        setupNavigationStyle()

    }
    
    func setupNavigationStyle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let lightRed = UIColor(red: 247/255, green: 66/255, blue: 82/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = lightRed
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    }
    
    @objc func handleAddCompany() {
        print("Adding company...")
    }
    
}

