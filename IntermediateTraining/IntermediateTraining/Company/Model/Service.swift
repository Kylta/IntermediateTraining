//
//  Service.swift
//  IntermediateTraining
//
//  Created by Christophe Bugnon on 23/03/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import Foundation

struct Service: Decodable {
    
    static let shared = Service()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer() {
     print("Attempting to download companies...")
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in

            print("Finished downloading...")
            if let err = err {
                print("Failed to download companies...:", err)
                return
            }
            
            guard let data = data else { return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
            let jsonCompany = try jsonDecoder.decode([JSONCompany].self, from: data)
                
                jsonCompany.forEach({ (jsonCompany) in
                    print(jsonCompany.name)
                    
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        print("  \(jsonEmployee.name)")
                    })
                })
                
            } catch let jsonDecodeErr {
                print("Failed to decode:", jsonDecodeErr)
            }
            
//            let string = String(data: data, encoding: .utf8)
            
        }.resume()
    }
}
