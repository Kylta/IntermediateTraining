//
//  JSONCompany.swift
//  IntermediateTraining
//
//  Created by Christophe Bugnon on 23/03/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import Foundation

class JSONCompany: Decodable {
    
    let name: String
    let founded: String
    var employees: [JSONEmployee]?
}
