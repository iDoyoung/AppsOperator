//
//  AnnouncementListStateControllerTests.swift
//  MyAppsOperatorTests
//
//  Created by Doyoung on 2023/04/27.
//

import XCTest
@testable import MyAppsOperator

final class AnnouncementListStateControllerTests: XCTestCase {

    //MARK: - System Under Test
    
    var sut: AnnouncementListStateController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AnnouncementListStateController()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    var mockFetchedAnnouncements: [Announcement]!
    
    //MARK: - Tests
    func test_updateFetchedAnnouncements() {
        
        // given
        sut.fetchedAnnouncements = FetchedAnnouncementList()
        mockFetchedAnnouncements = [
            Announcement(title: "Test", content: "Unit Test")
        ]
        let expect = mockFetchedAnnouncements.map {
            AnnouncementViewModel(
                id: $0.id,
                title: $0.title,
                content: $0.content
            )
        }
        // when
        sut.updateFetchedAnnouncements(mockFetchedAnnouncements)
        
        // then
        XCTAssertEqual(sut.fetchedAnnouncements?.items, expect)
    }
}
