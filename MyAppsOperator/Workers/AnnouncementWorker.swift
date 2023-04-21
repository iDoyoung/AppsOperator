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
        
    @discardableResult func create(_ annoucement: Announcement) async throws -> Announcement {
        guard let network else { fatalError("Network service is Nil") }
        let endpoint = APIEndpoints.createAnnouncement(annoucement)
        return try await network.request(with: endpoint)
    }
}
