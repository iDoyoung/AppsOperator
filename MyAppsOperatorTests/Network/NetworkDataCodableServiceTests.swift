//
//  NetworkDataCodableServiceTests.swift
//  MyAppsOperatorTests
//
//  Created by Doyoung on 2023/04/18.
//

import XCTest
@testable import MyAppsOperator

struct EntityMock: Codable {
    let data: String
}

final class NetworkCodableServiceTests: XCTestCase {

    //MARK: - System Under Tests
    var sut: NetworkDataCodableService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sesssionData = NetworkSessionDataMock()
        let networkService = NetworkService(configuration: NetworkAPIConfigureMock(), sessionData: sesssionData)
        sut = NetworkDataCodableService(network: networkService)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    var sesssionData: NetworkSessionDataMock!
    
    enum ErrorMock: Error {
        case someError
    }
    
    struct NetworkAPIConfigureMock: NetworkAPIConfigurer {
        var baseURL: URL = URL(string: "https://mock.test.com")!
        var headers: [String: String] = [:]
        var queryParameters: [String: String] = [:]
    }
    
    final class NetworkSessionDataMock: NetworkSessionDataProtocol {
        var data: Data? = nil
        var response: URLResponse? = nil
        var error: Error?
        
        func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
            if let data, let response {
                return (data, response)
            } else {
                throw error!
            }
        }
    }
    
    struct MockHTTPURLResponse {
        let response: HTTPURLResponse?
        
        init(statusCode: Int) {
            self.response = HTTPURLResponse(url: URL(string: "https://mock.test.com")!,
                                            statusCode: statusCode,
                                            httpVersion: "1",
                                            headerFields: nil)
        }
    }
    
    //MARK: - Tests
    func test_request_whenReceiveValidResponse_shouldDecodeResponse() async throws {
        ///given
        let encoder = JSONEncoder()
        let data = try? encoder.encode(EntityMock(data: "Test"))
        sesssionData.data = data
        sesssionData.response = MockHTTPURLResponse(statusCode: 200).response
        let response = try await sut.request(with: Endpoint<EntityMock>(path: "https://mock.test.com"))
        XCTAssertEqual(response.data, "Test")
    }
    
    func test_request_whenReceiveInvalidResponse_shouldBeDecodeError() async throws {
        ///given
        sesssionData.data = "Test".data(using: .utf8)
        sesssionData.response = MockHTTPURLResponse(statusCode: 200).response
        ///when
        do {
            let _ = try await sut.request(with: Endpoint<EntityMock>(path: "https://mock.test.com"))
            XCTFail("Should Be Error")
        } catch let error {
            guard case NetworkDataCodableError.parsing = error else {
                XCTFail("Uncorrect Error")
                return
            }
            ///then
            XCTAssert(true)
        }
    }
}
