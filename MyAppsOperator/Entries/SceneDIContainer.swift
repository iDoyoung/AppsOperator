//
//  SceneDIContainer.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/19.
//

import Foundation

final class SceneDIContainer {
    
    lazy var announcementNetworkService: NetworkDataCodableServicer = {
        let configuration = NetworkAPIConfiguration(baseURL: URL(string: "http://127.0.0.1:8080")!)
        let service = NetworkService(configuration: configuration)
        return NetworkDataCodableService(network: service)
    }()
    
}
