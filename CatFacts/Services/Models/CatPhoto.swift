//
//  CatPhoto.swift
//  CatFacts
//
//  Created by Naz Mariano on 1/9/25.
//

import Foundation

/*
 {
     "id": "2as",
     "url": "https://cdn2.thecatapi.com/images/2as.jpg",
     "width": 600,
     "height": 399
 }
 */

struct CatPhoto: Decodable {
    let id: String
    let url: String
    let width: Double
    let height: Double
}
