//
//  AnnouncementListInteractorTests.swift
//  MyAppsOperatorTests
//
//  Created by Doyoung on 2023/04/27.
//

import XCTest
@testable import MyAppsOperator

final class AnnouncementListInteractorTests: XCTestCase {
    
    //MARK: - System Under Test
    
    var sut: AnnouncementListInteractor!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AnnouncementListInteractor()
        workerSpy = WorkerSpy()
    }

    override func tearDownWithError() throws {
        sut = nil
        workerSpy = nil
        try super.tearDownWithError()
    }
    
    //MARK: - TestDoubles
    var workerSpy: WorkerSpy!
    final class WorkerSpy: AnnouncementWorkerProtocol {
        
        var fetchCalled = false
        var fetched = [Announcement]()
        
        func fetch() async throws -> [MyAppsOperator.Announcement] {
            fetchCalled = true
            return fetched
        }
        
        func create(_ announcement: MyAppsOperator.Announcement) async throws -> MyAppsOperator.Announcement {
            return announcement
        }
    }
    
    //MARK: - Tests
    func test_fetchList() async throws {
        // given
        sut.worker = workerSpy
        workerSpy.fetched = [Announcement(title: "Test", content: "Test Of Unit Test")]
        
        // when
        try await sut.fetchList()
        
        // then
        XCTAssertTrue(workerSpy.fetchCalled)
    }
}
