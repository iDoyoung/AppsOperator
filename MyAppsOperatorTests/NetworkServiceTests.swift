//
//  NetworkServiceTests.swift
//  MyAppsOperatorTests
//
//  Created by Doyoung on 2023/04/18.
//

import XCTest
@testable import MyAppsOperator

final class NetworkServiceTests: XCTestCase {

    //MARK: - System under test
    var sut: NetworkService!
    let sesssionDataMock = NetworkSessionDataMock()
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkService(configuration: NetworkAPIConfigurableMock(), sessionData: sesssionDataMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    //MARK: - Test Doubles
    enum ErrorMock: Error {
        case someError
    }
    
    struct NetworkAPIConfigurableMock: NetworkAPIConfigurer {
        var baseURL: URL = URL(string: "https://mock.test.com")!
        var headers: [String: String] = [:]
        var queryParameters: [String: String] = [:]
    }
    
    struct EndpointMock: Requester {
        var path: String = ""
        var isFullPath: Bool = false
        var method: HTTPMethodType = .get
        var headerParameters: [String : String] = [:]
        var queryParameters: [String : String] = [:]
        var bodyParameters: [String : Any] = [:]
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
    func test_request_whenRecivedResponseWithData_shouldBeSuccessAndCorrectData() async throws {
        ///given
        sesssionDataMock.data = "Response data".data(using: .utf8)!
        sesssionDataMock.response = MockHTTPURLResponse(statusCode: 200).response
        ///when
        let data = try await sut.request(endpoint: EndpointMock())
        ///then
        XCTAssertEqual(data, sesssionDataMock.data)
    }
    
    func test_request_whenInternetIsNotConnected_shouldBeFailAndNetworkErrorIsNotConnectedInternet() async throws {
        // given
        sesssionDataMock.error = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet)
        // when
        do {
           _ = try await sut.request(endpoint: EndpointMock())
        } catch let error {
            guard case NetworkError.notConnectedInternet = error else {
                XCTFail("Uncorrect Error")
                return
            }
            ///then
            XCTAssert(true)
        }
    }
    
    func test_request_whenBadURL_shouldBeFailAndNetworkErrorIsBadURL() async throws {
        // given
        sesssionDataMock.error = NSError(domain: "network", code: NSURLErrorBadURL)
        // when
        do {
            _ = try await sut.request(endpoint: EndpointMock())
        } catch let error {
            guard case NetworkError.badURL = error else {
                XCTFail("Uncorrect Error")
                return
            }
            // then
            XCTAssert(true)
        }
    }
    
    func test_request_whenTimeOut_shouldBeFailAndNetworkErrorIsTimeOut() async throws {
        // given
        sesssionDataMock.error = NSError(domain: "network", code: NSURLErrorTimedOut)
        // when
        do {
            _ = try await sut.request(endpoint: EndpointMock())
        } catch let error {
            guard case NetworkError.timeOut = error else {
                XCTFail("Uncorrect Error")
                return
            }
            // then
            XCTAssert(true)
        }
    }
}

