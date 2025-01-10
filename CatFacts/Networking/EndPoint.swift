//
//  EndPoint.swift
//  CatFacts
//
//  Created by Naz Mariano on 1/9/25.
//

import Foundation

protocol EndPointProtocol {
    var scheme: String { get }
    var host: String { get }
    var path: String { get set }
    var queryItems: [URLQueryItem] { get set }
    var url: URL? { get }
}

struct Endpoint: EndPointProtocol {
    var scheme: String {
        if Config.environment == APIEnvironment.mock.rawValue {
            return "http"
        } else {
            return "https"
        }
    }

    var host: String
    var path: String
    var queryItems = [URLQueryItem]()
}

protocol AppEnvironment {
    static var host: String { get }
}

private func localhost() -> String {
    let ip = (Bundle.main.infoDictionary?["HostIP"] as? String) ?? "192.168.0.207"
    return ip
}

// MARK: Cat Photo Host
struct CatPhotoHost: AppEnvironment {
    static var host: String {
        if Config.environment == "mock" {
            return localhost()
        } else {
            return "api.thecatapi.com"
        }
    }
}

// MARK: Cat Facts Host
struct CatFactsHost: AppEnvironment {
    static var host: String {
        if Config.environment == "mock" {
            return localhost()
        } else {
            return "meowfacts.herokuapp.com"
        }
    }
}

extension Endpoint {
    // MARK: Cat Photos
    enum CatPhoto {
        static var host: String {
            CatPhotoHost.host
        }
        
        static func getPhotos(_ limit: Int) -> Endpoint {
            return Endpoint(
                host: host,
                path: "/v1/images/search",
                queryItems: [.init(name: "limit", value: "\(limit)")]
            )
        }
    }

    // MARK: Cat Facts
    enum CatFacts {
        static var host: String {
            CatFactsHost.host
        }
        
        static func getFacts(_ count: Int) -> Endpoint {
            return Endpoint(
                host: host,
                path: "/",
                queryItems: [.init(name: "count", value: "\(count)")]
            )
        }
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        if Config.environment == "mock" {
            components.port = 8080
        }
        
        if queryItems.count > 0 {
            components.queryItems = queryItems
        }

        return components.url
    }
}
