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
    
    //MARK: - Method
    
    // User Case
    func fetchList() async throws {
        guard let worker else { fatalError("Must be not nil") }
        do {
            let fetched = try await worker.fetch
            
            // TODO: Call State Controller
        } catch let error {
            // TODO: Call State Controller
        }
    }
}
