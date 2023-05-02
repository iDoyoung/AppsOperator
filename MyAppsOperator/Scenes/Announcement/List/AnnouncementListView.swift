//
//  AnnouncementListView.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/26.
//

import SwiftUI

struct AnnouncementListView: View {
    
    // Components
    
    private var announcementWorker = AnnouncementWorker(
        network: NetworkDataCodableService(
            network: NetworkService(
                configuration: NetworkAPIConfiguration(
                    baseURL: URL(string: "http://127.0.0.1:8080/announcements")!
                )
            )
        )
    )
    var interactor: AnnouncementListInteractor
    // UI
    
    @StateObject var fetchedAnnouncements: FetchedAnnouncementList
    
    var body: some View {
        NavigationStack {
            List(fetchedAnnouncements.items) {
                NavigationLink($0.title, value: $0)
            }
            .navigationTitle("공지사항")
        }
        .onAppear {
            Task {
                try await interactor.fetchList()
            }
        }
    }
    
    init() {
        let fetchedAnnouncements = FetchedAnnouncementList()
        let interactor = AnnouncementListInteractor()
        let stateController = AnnouncementListStateController()
        stateController.fetchedAnnouncements = fetchedAnnouncements
        interactor.stateController = stateController
        
        _fetchedAnnouncements = StateObject(wrappedValue: { fetchedAnnouncements }())
        interactor.worker = announcementWorker
        self.interactor = interactor
    }
}

struct AnnouncementListView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementListView()
    }
}
