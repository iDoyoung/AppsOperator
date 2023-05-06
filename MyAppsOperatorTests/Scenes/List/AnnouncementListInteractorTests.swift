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
        var mockData: Announcement? = nil
        var fetched = [Announcement]()
        
        var fetchCalled = false
        var createCalled = false
        var deleteCalled = false
        
        func fetch() async throws -> [MyAppsOperator.Announcement] {
            fetchCalled = true
            if error != nil {
                throw error!
            }
            return fetched
        }
        
        func create(_ announcement: MyAppsOperator.Announcement) async throws -> MyAppsOperator.Announcement {
            createCalled = true
            return announcement
        }
        
        func delete(with id: String) async throws -> String {
            deleteCalled = true
            return mockData!.title
        }
    }
    
    final class AnnouncementListStateControllerSpy: AnnouncementListStateUpdater {
        
        var updateFetchedAnnouncementsCalled = false
        var updateErrorAlertCalled = false
        var deleteAnnouncementCalled = false
        
        func updateFetchedAnnouncements(_ list: [MyAppsOperator.Announcement]) {
            updateFetchedAnnouncementsCalled = true
        }
        
        func updateErrorAlert(_ error: Error) {
            updateErrorAlertCalled = true
        }
        
        func deleteAnnouncement(_ title: String) {
            deleteAnnouncementCalled = true
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
    
    func test_delete() async throws {
        // given
        let anncouncement = Announcement(id: UUID(), title: "Test", content: "Unit Test Of Delete")
        
        workerSpy.mockData = anncouncement
        sut.worker = workerSpy
        
        // when
        try await sut.deleteItem(anncouncement.id!)
        
        // then
        XCTAssertTrue(workerSpy.deleteCalled)
    }
}
