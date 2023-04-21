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
        sut = CreateAnnouncementInteractor(worker: workerSpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        workerSpy = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    var workerSpy: WorkerSpy!
    
    final class WorkerSpy: AnnouncementWorkerProtocol {
        var createCalled = false
        
        func create(_ annoucement: MyAppsOperator.Announcement) async throws -> MyAppsOperator.Announcement {
            createCalled = true
            return annoucement
        }
    }
    
    //MARK: - Tests
    func test_create() async throws {
        // given
        
        // when
        try await sut.create(Announcement(title: "Test", content: "Unit test of create a Announcement"))
        
        // then
        XCTAssertTrue(workerSpy.createCalled)
    }
}
