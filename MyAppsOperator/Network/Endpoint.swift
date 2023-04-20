//
//  Endpoint.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/17.
//

import Foundation

struct Endpoint<R>: ResponseRequester {
    
    typealias Response = R
    
    var path: String
    var isFullPath: Bool
    var method: HTTPMethodType
    var headerParameters: [String: String]
    var queryParameters: [String: String]
    var encodableBodyParamater: Encodable?
    var bodyParameters: [String: Any]
    
    init(
        path: String,
        isFullPath: Bool = false,
        method: HTTPMethodType = .get,
        headerParameters: [String: String] = [:],
        queryParameters: [String: String] = [:],
        encodableBodyParamater: Encodable? = nil,
        bodyParameters: [String: Any] = [:]
    ) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameters = headerParameters
        self.queryParameters = queryParameters
        self.encodableBodyParamater = encodableBodyParamater
        self.bodyParameters = bodyParameters
    }
}
