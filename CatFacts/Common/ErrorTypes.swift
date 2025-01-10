//
//  ErrorTypes.swift
//  CatFacts
//
//  Created by Naz Mariano on 1/10/25.
//

import Foundation

enum AsyncError: Error {
    case finishedWithoutValue
}

enum RequestError: Error {
    case decodingError(DecodingError)
    case emptyBody
    case invalidUrl
    case serverError
    case noReponse
}
