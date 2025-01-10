//
//  CatFact.swift
//  CatFacts
//
//  Created by Naz Mariano on 1/10/25.
//

import Foundation

/*
 {
     "data": [
         "In 1987 cats overtook dogs as the number one pet in America."
     ]
 }
 */

struct CatFact: Decodable {
    let facts: [String]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let result = try values.decode([String].self, forKey: .data)

        if result.count > 0 {
            facts = result
        } else {
            facts = []
        }
    }
}
