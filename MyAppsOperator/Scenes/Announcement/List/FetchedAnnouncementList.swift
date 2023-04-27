//
//  FetchedAnnouncementList.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/26.
//

import Foundation

final class FetchedAnnouncementList: ObservableObject {
    @Published var items: [AnnouncementViewModel] = []
}
