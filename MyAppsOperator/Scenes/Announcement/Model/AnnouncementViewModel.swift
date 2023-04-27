//
//  AnnouncementViewModel.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/23.
//

import Foundation

struct AnnouncementViewModel: Identifiable, Hashable {
    var id: UUID? = nil
    var title: String = ""
    var content: String = ""
    var createdAt: String? = nil
    var deletedAt: String? = nil
}
