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

final class CreateAnnouncementInteractor: ObservableObject {

    // MARK: - Properties
    
    // Components
    var worker: AnnouncementWorkerProtocol?
    var stateController: CreateAnnouncementStateUpdater?
    
    // MARK: - Methods
    
    // Use Case
    func create(title: String, content: String) async throws {
        guard let worker,
              let stateController else { fatalError("Must be init") }
        let annoucement = Announcement(title: title, content: content)
        do {
            try await worker.create(annoucement)
        } catch let error {
            await stateController.updateErrorAlert(with: error)
        }
    }
}
