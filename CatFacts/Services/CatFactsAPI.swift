//
//  CatFactsAPI.swift
//  CatFacts
//
//  Created by Naz Mariano on 1/10/25.
//

import Foundation

class CatFactsAPI {
    private let networking: Networking

    init(networking: Networking = Networking.shared) {
        self.networking = networking
    }
    
    func getCatPhotos(_ limit: Int) async throws -> [CatPhoto]? {
        return try await networking.get(.CatPhoto.getPhotos(limit)).async()
    }
    
    func getCatFacts(_ limit: Int) async throws -> CatFact? {
        return try await networking.get(.CatFacts.getFacts(limit)).async()
    }
}
