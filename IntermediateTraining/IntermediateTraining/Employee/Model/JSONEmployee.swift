//
//  JSONEmployee.swift
//  IntermediateTraining
//
//  Created by Christophe Bugnon on 23/03/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import Foundation

struct JSONEmployee: Decodable {
    
    let name: String
    let birthday: String
    let type: String
}
