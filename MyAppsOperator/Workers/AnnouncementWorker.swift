//
//  AnnouncementWorker.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/20.
//

import Foundation

protocol AnnouncementWorkerProtocol {
    func fetch() async throws -> [Announcement]
    @discardableResult func create(_ announcement: Announcement) async throws -> Announcement
    func delete(with id: String) async throws -> String
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
    
    @discardableResult func create(_ announcement: Announcement) async throws -> Announcement {
        guard let network else { fatalError("Nil: Network service is \"nil\"") }
        let endpoint = APIEndpoints.createAnnouncement(announcement)
        return try await network.request(with: endpoint)
    }
    
    func delete(with id: String) async throws -> String {
        guard let network else { fatalError("Nil: Network Service is \"nil\"") }
        let endpoint = APIEndpoints.deleteAnnouncement(with: id)
        return try await network.request(with: endpoint)
    }
}
