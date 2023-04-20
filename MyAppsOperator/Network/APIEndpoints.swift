//
//  APIEndpoints.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/19.
//

import Foundation

struct APIEndpoints {
    
    static func createAnnouncement(_ announcement: Announcement) -> Endpoint<Announcement> {
       return Endpoint(path: "new", encodableBodyParamater: announcement)
    }
}
