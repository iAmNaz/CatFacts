//
//  Mocks.swift
//  CatFactsTests
//
//  Created by Naz Mariano on 1/11/25.
//

import Foundation
import Mocker

func mockUrlSession() -> URLSession {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockingURLProtocol.self]
    let urlSession = URLSession(configuration: configuration)
    
    return urlSession
}

public final class MockedData {
    public static let catFacts: URL = Bundle(for: MockedData.self).url(forResource: "cat_facts", withExtension: "json")!
}

internal extension URL {
    /// Returns a `Data` representation of the current `URL`. Force unwrapping as it's only used for tests.
    var data: Data {
        return try! Data(contentsOf: self)
    }
}
