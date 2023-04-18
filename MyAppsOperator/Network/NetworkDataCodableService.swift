//
//  NetworkDataCodableService.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/18.
//

import Foundation

enum NetworkDataCodableError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
}

protocol NetworkDataCodableServicer {
    func request<T: Decodable, E: ResponseRequester>(with endpoint: E) async throws -> T where T == E.Response
    func request<E: ResponseRequester>(with endpoint: E) async throws
}

final class NetworkDataCodableService: NetworkDataCodableServicer {
    private let network: NetworkServicer
    
    init(network: NetworkServicer) {
        self.network = network
    }
    
    func request<T: Decodable, E: ResponseRequester>(with endpoint: E) async throws -> T where T == E.Response {
        let data = try await network.request(endpoint: endpoint)
        let response: T = try decode(data: data)
        return response
    }
    
    func request<E: ResponseRequester>(with endpoint: E) async throws {
        _ = try await network.request(endpoint: endpoint)
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        do {
            let docoded: T = try JSONResponseDecoder().decode(data)
            return docoded
        } catch {
            throw NetworkDataCodableError.parsing(error)
        }
    }
}

final class JSONResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    init() { }
    func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
