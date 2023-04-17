//
//  NetworkAPIConfiguration.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/17.
//

import Foundation

protocol NetworkAPIConfigurer {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

struct NetworkAPIConfiguration: NetworkAPIConfigurer {
    
    var baseURL: URL
    var headers: [String : String]
    var queryParameters: [String : String]
    
    init(baseURL: URL, headers: [String : String] = [:], queryParameters: [String : String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
    }
}
