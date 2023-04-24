//
//  AnnouncementViewModel.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/23.
//

import Foundation

final class AnnouncementViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var createdAt: String? = nil
    @Published var deletedAt: String? = nil
}
