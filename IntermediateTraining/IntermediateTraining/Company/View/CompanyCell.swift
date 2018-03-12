//
//  CompanyCell.swift
//  IntermediateTraining
//
//  Created by Christophe Bugnon on 08/03/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    var company: Company? {
        didSet {
            nameFoundedDateLabel.text = company?.name
            
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
            
            if let name = company?.name, let founded = company?.founded {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let foundedDateString = dateFormatter.string(from: founded)
                let dateString = "\(name) - Founded: \(foundedDateString)"
                nameFoundedDateLabel.text = dateString
            } else {
                nameFoundedDateLabel.text = company?.name
            }
        }
    }
    
    let companyImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.darkBlue.cgColor
        iv.layer.borderWidth = 1
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameFoundedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "COMPANY NAME"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.tealColor
        
        setupLayout()
        
    }
    
    private func setupLayout() {
        
        addSubview(companyImageView)
        [companyImageView.heightAnchor.constraint(equalToConstant: 40),
         companyImageView.widthAnchor.constraint(equalToConstant: 40),
         companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
         companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor)].forEach({$0.isActive = true })
        
        addSubview(nameFoundedDateLabel)
        [nameFoundedDateLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 8),
         nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor),
         nameFoundedDateLabel.rightAnchor.constraint(equalTo: rightAnchor),
         nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)].forEach({$0.isActive = true })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
