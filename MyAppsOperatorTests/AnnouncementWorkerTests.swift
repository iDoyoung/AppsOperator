//
//  AnnouncementWorkerTests.swift
//  MyAppsOperatorTests
//
//  Created by Doyoung on 2023/04/20.
//

import XCTest
@testable import MyAppsOperator

final class AnnouncementWorkerTests: XCTestCase {

    //MARK: - System Under Test
    var sut: AnnouncementWorker!
    
    override func setUpWithError() throws {
        sut = AnnouncementWorker()
        networkServiceSpy = NetworkServiceSpy()
    }

    override func tearDownWithError() throws {
        sut = nil
        networkServiceMock = nil
        networkServiceSpy = nil
    }
    
    //MARK: - Test Doubles
    var networkServiceMock: NetworkDataCodableServicer!
    var networkServiceSpy: NetworkServiceSpy!
    
    final class NetworkServiceSpy: NetworkServicer {
        var dataMock: Data!
        var networkCalled = false
        
        func request(endpoint: MyAppsOperator.Requester) async throws -> Data {
            networkCalled = true
            return dataMock
        }
    }
    
    //MARK: - Tests
    func test_fetch() async throws {
        // given
        let mockData = Announcement(title: "Test", content: "Unit test of create a Announcement")
        networkServiceSpy.dataMock = try JSONEncoder().encode([mockData])
        networkServiceMock = NetworkDataCodableService(network: networkServiceSpy)
        sut.network = networkServiceMock
        
        // when
        let fetched = try await sut.fetch()
        
        // then
        XCTAssertTrue(networkServiceSpy.networkCalled)
        XCTAssertTrue(fetched.contains(mockData))
    }
    
    func test_create() async throws {
        // given
        let mockData = Announcement(title: "Test", content: "Unit test of create a Announcement")
        networkServiceSpy.dataMock = try JSONEncoder().encode(mockData)
        networkServiceMock = NetworkDataCodableService(network: networkServiceSpy)
        sut.network = networkServiceMock
        
        // when
        let expectation = try await sut.create(mockData)
        
        // then
        XCTAssertTrue(networkServiceSpy.networkCalled)
        XCTAssertEqual(expectation, mockData)
    }
    
    func test_delete() async throws {
        // given
        let mockData = UUID()
        networkServiceSpy.dataMock = try JSONEncoder().encode(mockData)
        networkServiceMock = NetworkDataCodableService(network: networkServiceSpy)
        sut.network = networkServiceMock

        // when
        let expectation = try await sut.delete(with: mockData.uuidString)
        
        // then
        XCTAssertTrue(networkServiceSpy.networkCalled)
        XCTAssertEqual(mockData.uuidString, expectation)
    }
}
