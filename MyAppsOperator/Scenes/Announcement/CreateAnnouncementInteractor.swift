//
//  CreateAnnouncementInteractor.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/21.
//

import Foundation
 
protocol CreateAnnouncementUseCase {
    func create()
}

final class CreateAnnouncementInteractor {
    
    // MARK: - Properties
    
    // Components
    private var worker: AnnouncementWorkerProtocol
    
    // MARK: - Methods
    init(worker: AnnouncementWorkerProtocol) {
        self.worker = worker
    }
    
    // Use Case
    func create(_ annoucement: Announcement) async throws {
        try await worker.create(annoucement)
        
    }
}
