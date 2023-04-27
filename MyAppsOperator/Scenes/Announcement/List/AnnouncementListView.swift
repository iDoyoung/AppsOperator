//
//  AnnouncementListView.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/26.
//

import SwiftUI

struct AnnouncementListView: View {
    
    @StateObject var fetchedAnnouncements: FetchedAnnouncementList
    
    var body: some View {
        NavigationStack {
            List(fetchedAnnouncements.items) {
                Text($0.title)
                NavigationLink($0.title, value: $0)
            }
            .navigationTitle("공지사항")
        }
    }
    
    init() {
        let fetchedAnnouncements = FetchedAnnouncementList()
        _fetchedAnnouncements = StateObject(wrappedValue: { fetchedAnnouncements }())
    }
}

struct AnnouncementListView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementListView()
    }
}
