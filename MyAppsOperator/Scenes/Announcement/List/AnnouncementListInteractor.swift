//
//  AnnouncementListInteractor.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/27.
//

import Foundation

protocol AnnouncementListUseCase {
    func fetchList() async throws
}

final class AnnouncementListInteractor {
   
    // MARK: - Properties
    
    // Components
    var worker: AnnouncementWorkerProtocol?
    var stateController: AnnouncementListStateUpdater?
    
    //MARK: - Method
    
    // Use Case
    func fetchList() async throws {
        guard let worker else { fatalError("Must be not nil") }
        async let item = worker.fetch()
        
        do {
            try await stateController?.updateFetchedAnnouncements(item)
        } catch let error {
            await stateController?.updateErrorAlert(error)
        }
    }
}
