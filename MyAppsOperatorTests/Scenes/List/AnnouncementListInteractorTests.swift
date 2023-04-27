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
        announcementListStateControllerSpy = AnnouncementListStateControllerSpy()
    }

    override func tearDownWithError() throws {
        sut = nil
        workerSpy = nil
        try super.tearDownWithError()
    }
    
    //MARK: - TestDoubles
    var workerSpy: WorkerSpy!
    var announcementListStateControllerSpy: AnnouncementListStateControllerSpy!
    
    final class WorkerSpy: AnnouncementWorkerProtocol {
        
        var error: Error? = nil
        var fetchCalled = false
        var fetched = [Announcement]()
        
        func fetch() async throws -> [MyAppsOperator.Announcement] {
            fetchCalled = true
            if error != nil {
                throw error!
            }
            return fetched
        }
        
        func create(_ announcement: MyAppsOperator.Announcement) async throws -> MyAppsOperator.Announcement {
            return announcement
        }
    }
    
    final class AnnouncementListStateControllerSpy: AnnouncementListStateUpdater {
        
        var updateFetchedAnnouncementsCalled = false
        var updateErrorAlertCalled = false
        
        func updateFetchedAnnouncements(_ list: [MyAppsOperator.Announcement]) {
            updateFetchedAnnouncementsCalled = true
        }
        
        func updateErrorAlert(_ error: Error) {
            updateErrorAlertCalled = true
        }
    }
     
    //MARK: - Tests
    func test_fetchList_whenIsNotError() async throws {
        // given
        sut.worker = workerSpy
        sut.stateController = announcementListStateControllerSpy
        workerSpy.fetched = [Announcement(title: "Test", content: "Test Of Unit Test")]
        
        // when
        try await sut.fetchList()
        
        // then
        XCTAssertTrue(workerSpy.fetchCalled)
        XCTAssertTrue(announcementListStateControllerSpy.updateFetchedAnnouncementsCalled)
    }
    
    func test_fetchList_whenIsError() async throws {
        // given
        workerSpy.error = NetworkError.timeOut
        sut.worker = workerSpy
        sut.stateController = announcementListStateControllerSpy
        
        // when
        try await sut.fetchList()
        
        // then
        XCTAssertTrue(workerSpy.fetchCalled)
        XCTAssertTrue(announcementListStateControllerSpy.updateErrorAlertCalled)
    }
}
