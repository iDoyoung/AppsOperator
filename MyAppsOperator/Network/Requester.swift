//
//  Requester.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/17.
//

import Foundation

enum RequestGenerationError: Error {
    case components
}

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol ResponseRequester: Requester {
    associatedtype Response
}

protocol Requester {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethodType { get }
    var headerParameters: [String: String] { get }
    var queryParameters: [String: String] { get }
    var encodableBodyParamater: Encodable? { get }
    var bodyParameters: [String: Any] { get }
    
    func requestURL(with networkConfiguration: NetworkAPIConfigurer) throws -> URLRequest
}

extension Requester {
    
    func requestURL(with configuration: NetworkAPIConfigurer) throws -> URLRequest {
        let url = try getURL(with: configuration)
        var urlRequest = URLRequest(url: url)
        var headers = configuration.headers
        headerParameters.forEach { headers.updateValue($1, forKey: $0)}
        
        // Setup Body
        if let encodableBodyParamater {
            urlRequest.httpBody = try JSONEncoder().encode(encodableBodyParamater)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else if !bodyParameters.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters)
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
    
    private func getURL(with configuration: NetworkAPIConfigurer) throws -> URL {
        var baseURL = configuration.baseURL.absoluteString.last != "/" ? configuration.baseURL.absoluteString.appending("/") : configuration.baseURL.absoluteString
        if baseURL.prefix(7) != "http://" && baseURL.prefix(8) != "https://" {
           baseURL = "https://" + baseURL
        }
        let endpoint = isFullPath ? path: baseURL.appending(path)
        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestGenerationError.components }
        var items = [URLQueryItem]()
        configuration.queryParameters.forEach { items.append(URLQueryItem(name: $0, value: $1)) }
        queryParameters.forEach { items.append(URLQueryItem(name: $0, value: $1)) }
        urlComponents.queryItems = items.isEmpty ? nil : items
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
}
