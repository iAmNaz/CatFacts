//
//  Networking.swift
//  CatFacts
//
//  Created by Naz Mariano on 1/9/25.
//

import Combine
import Foundation
import os
import UIKit

/// In order for us to represent the`URLSession` with a few of its interfaces
/// we created a session protocol and use to hold an instance of it.
public protocol Session {
    func dataTaskPublisher(for url: URL) -> URLSession.DataTaskPublisher
}

/// Force conformance to the `Session` protocol.
///
/// We can now use `Session` as a type to represent the actual `URLSession` object.
extension URLSession: Session {}

final class Networking: ObservableObject {
    private var urlSession: URLSession
    private var cancellable: AnyCancellable!

    typealias IdentifiableModel = Codable & Identifiable & Comparable

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Networking.self)
    )

    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    static let shared = Networking()
    
    /// Use this initializer to create an instance of the API client
    ///
    /// A default `URLSession` object is set
    /// - Parameter urlSession where you optionally pass your own `URLSession` object.
    init(urlSession: URLSession = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue())) {
        self.urlSession = urlSession
    }

    func get<InboundModel: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<InboundModel, Error> {
        assert(endpoint.url != nil, "URL is malformed")

        let url = endpoint.url!
        
        logger.registerInfoLog("\(url)")

        let request = make(url: url, token: nil, method: .get)

        return send(request)
    }
    
    fileprivate func make(url: URL, token: String?, clientKey: String? = nil, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }
        return request
    }
    
    fileprivate func send(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        return urlSession
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { element -> Data in

                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode < 500
                else {

                    self.logger.registerInfoLog("Internal server error")
                    
                    throw RequestError.serverError
                }
                
                self.logger.registerInfoLog("Status code: \(httpResponse.statusCode)")
                
                let data = element.data

                if let jsonString = String(data: data, encoding: .utf8) {
                    self.logger.registerInfoLog("\(jsonString)")
                }
                
                self.logger.registerInfoLog("Response data: \(data)")

                if data.isEmpty {
                    throw RequestError.emptyBody
                }

                return data
            }
            .eraseToAnyPublisher()
    }
    
    fileprivate func send<InboundModel: Decodable>(_ request: URLRequest) -> AnyPublisher<InboundModel, Error> {
        return urlSession
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { element -> Data in

                guard let httpResponse = element.response as? HTTPURLResponse
                else {
                    self.logger.registerErrorLog("Empty response received")
                    throw RequestError.noReponse
                }
                
                self.logger.registerInfoLog("Status code: \(httpResponse.statusCode)")
                
                let data = element.data

                if let jsonString = String(data: data, encoding: .utf8) {
                    self.logger.registerInfoLog("Response: \(jsonString)")
                }

                if data.isEmpty {
                    throw RequestError.emptyBody
                }

                return data
            }
            .tryMap{ data in
                do {
                    let inboundModel = try Networking.decoder.decode(InboundModel.self, from: data)
                    return inboundModel
                } catch {
                    throw RequestError.decodingError(error as! DecodingError)
                }
            }
            .eraseToAnyPublisher()
    }
}

extension String {
    static let get = "GET"
    static let post = "POST"
    static let patch = "PATCH"
    static let put = "PUT"
    static let delete = "DELETE"
}
