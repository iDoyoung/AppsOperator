//
//  CreateAnnouncementInteractorTests.swift
//  MyAppsOperatorTests
//
//  Created by Doyoung on 2023/04/21.
//

import XCTest
@testable import MyAppsOperator

final class CreateAnnouncementInteractorTests: XCTestCase {

    //MARK: - System Under Test
    
    var sut: CreateAnnouncementInteractor!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        workerSpy = WorkerSpy()
        stateControllerSpy = CreateAnnouncementStateUpdaterSpy()
        sut = CreateAnnouncementInteractor()
    }

    override func tearDownWithError() throws {
        sut = nil
        workerSpy = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    var workerSpy: WorkerSpy!
    var stateControllerSpy: CreateAnnouncementStateUpdater!
    
    final class WorkerSpy: AnnouncementWorkerProtocol {
        
        var createCalled = false
        
        func fetch() async throws -> [MyAppsOperator.Announcement] {
            return []
        }
        
        func create(_ annoucement: MyAppsOperator.Announcement) async throws -> MyAppsOperator.Announcement {
            createCalled = true
            return annoucement
        }
    }
    
    final class CreateAnnouncementStateUpdaterSpy: CreateAnnouncementStateUpdater {
        var updateErrorAlertCalled = false
        
        func updateErrorAlert(with error: Error) {
            updateErrorAlertCalled = true
        }
    }
    
    //MARK: - Tests
    func test_create() async throws {
        // given
        sut.worker = workerSpy
        sut.stateController = stateControllerSpy
        // when
        try await sut.create(title: "Test", content: "Unit test")
        
        // then
        XCTAssertTrue(workerSpy.createCalled)
    }
}
