//
//  Announcement.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/19.
//

import Foundation

struct Announcement: Codable {
    var id: UUID?
    var title: String
    var content: String
    var createdAt: Date?
    var deletedAt: Date?
}
