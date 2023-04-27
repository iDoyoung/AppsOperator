//
//  CreateAnnouncementStateControllerTests.swift
//  MyAppsOperatorTests
//
//  Created by Doyoung on 2023/04/26.
//

import XCTest
@testable import MyAppsOperator

final class CreateAnnouncementStateControllerTests: XCTestCase {

    //MARK: - System Under Tests
    
    var sut: CreateAnnouncementStateController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAlert = CreateAnnouncementErrorAlert()
        sut = CreateAnnouncementStateController()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    
    var mockAlert: CreateAnnouncementErrorAlert!
   
    //MARK: - Tests
    func test() async throws {
        // given
        sut.createAlert = mockAlert
        let error = NetworkError.badURL
        // when
        await sut.updateErrorAlert(with: error)
        
        //then
        XCTAssertEqual(sut.createAlert!.title, "")
        XCTAssertEqual(sut.createAlert!.content, error.localizedDescription)
        XCTAssertTrue(sut.createAlert!.didError)
    }
}
