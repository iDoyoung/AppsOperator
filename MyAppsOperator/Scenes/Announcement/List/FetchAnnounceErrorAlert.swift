//
//  FetchAnnounceErrorAlert.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/27.
//

import Foundation

final class FetchAnnounceErrorAlert: ObservableObject {
    var title: String = "Title"
    var content: String = ""
    @Published var didError = false
}
