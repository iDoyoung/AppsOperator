//
//  NetworkService.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/17.
//

import Foundation

enum NetworkError: Error {
    case notConnectedInternet
    case badURL
    case timeOut
    case unexpected(Error)
}

protocol NetworkServicer {
    func request(endpoint: Requester) async throws -> Data
}

protocol NetworkSessionDataProtocol {
    func request(_ request: URLRequest) async throws -> (Data, URLResponse)
}

final class NetworkSessionData: NetworkSessionDataProtocol {
    
    func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(for: request)
    }
}

final class NetworkService: NetworkServicer {
    
    let configuration: NetworkAPIConfigurer
    let sessionData: NetworkSessionDataProtocol
    
    init(configuration: NetworkAPIConfigurer, sessionData: NetworkSessionDataProtocol = NetworkSessionData()) {
        self.configuration = configuration
        self.sessionData = sessionData
    }
    
    func request(endpoint: Requester) async throws -> Data {
        let urlRequest = try? endpoint.requestURL(with: configuration)
        guard let urlRequest else { throw NetworkError.badURL }
        return try await request(request: urlRequest)
    }
    
    private func request(request: URLRequest) async throws -> Data {
        do {
            let (data, _) = try await sessionData.request(request)
            return data
        } catch {
           throw resolve(error: error)
        }
    }
    
    private func resolve(error: Error) -> NetworkError {
        let errorCode = URLError.Code(rawValue: (error as NSError).code)
        switch errorCode {
        case .notConnectedToInternet: return .notConnectedInternet
        case .timedOut: return .timeOut
        case .badURL: return .badURL
        default:
            return .unexpected(error)
        }
    }
}
