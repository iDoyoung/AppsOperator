//
//  AnnouncementListStateController.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/27.
//

import Foundation

protocol AnnouncementListStateUpdater {
    func updateFetchedAnnouncements(_ list: [Announcement])
    @MainActor func updateErrorAlert(_ error: Error)
}

final class AnnouncementListStateController: AnnouncementListStateUpdater {
    
    var fetchedAnnouncements: FetchedAnnouncementList?
    
    func updateFetchedAnnouncements(_ list: [Announcement]) {
        let viewModel = list.map {
            AnnouncementViewModel(
                id: $0.id,
                title: $0.title,
                content: $0.content
            )
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.fetchedAnnouncements?.items = viewModel
        }
    }
    
    @MainActor func updateErrorAlert(_ error: Error) {
        
    }
}
