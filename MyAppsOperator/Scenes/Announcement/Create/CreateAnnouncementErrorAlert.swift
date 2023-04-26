//
//  CreateAnnouncementAlert.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/24.
//

import Foundation

final class CreateAnnouncementErrorAlert: ObservableObject {
    var title: String = "Title"
    var content: String = ""
    @Published var didError = false
}
