//
//  CreateAnnouncementStateController.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/25.
//

import SwiftUI

protocol CreateAnnouncementStateUpdater {
    @MainActor func updateErrorAlert(with error: Error)
}

struct CreateAnnouncementStateController: CreateAnnouncementStateUpdater {
    
    var createAlert: CreateAnnouncementErrorAlert?
   
    @MainActor func updateErrorAlert(with error: Error) {
        guard let networkError = error as? NetworkError else { return }
        createAlert?.title = ""
        createAlert?.content = networkError.localizedDescription
        createAlert?.didError = true
    }
}
