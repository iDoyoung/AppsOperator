//
//  AnnouncementWorker.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/20.
//

import Foundation

protocol AnnouncementWorkerProtocol {
    @discardableResult func create(_ annoucement: Announcement) async throws -> Announcement
}

final class AnnouncementWorker: AnnouncementWorkerProtocol {
    
    var network: NetworkDataCodableServicer?
        
    init(network: NetworkDataCodableServicer? = nil) {
        self.network = network
    }
    
    func fetch() async throws -> [Announcement] {
        guard let network else { fatalError("Nil: Network service is \"nil\"") }
        let endpoint = APIEndpoints.fetchAnnouncements()
        return try await network.request(with: endpoint)
    }
    
    @discardableResult func create(_ annoucement: Announcement) async throws -> Announcement {
        guard let network else { fatalError("Nil: Network service is \"nil\"") }
        let endpoint = APIEndpoints.createAnnouncement(annoucement)
        return try await network.request(with: endpoint)
    }
}
