//
//  Config.swift
//  CatFacts
//
//  Created by Naz Mariano on 1/9/25.
//

import Foundation

enum APIEnvironment: String {
    case mock = "mock"
    case dev = "dev"
}

struct Config {
    static var environment: String {
        if let env = Bundle.main.infoDictionary?["ENVIRONMENT"] as? String {
            return env
        }
        return ""
    }
}
