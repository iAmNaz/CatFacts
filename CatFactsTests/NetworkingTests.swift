//
//  CatFactsTests.swift
//  CatFactsTests
//
//  Created by Naz Mariano on 1/9/25.
//

import XCTest
import Mocker
import Combine
@testable import CatFacts

final class NetworkingTests: XCTestCase {
    var urlSession: URLSession!
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }

    override class func tearDown() {
        Mocker.removeAll()
        super.tearDown()
    }
    
    func testGetRequestSucceeds() {
        let expectation = self.expectation(description: "Should return decoded result")
        let mockedData = MockedData.catFacts.data
        
        let mock = Mock(url: Endpoint.CatFacts.getFacts(10).url!, contentType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()
        
        let networking = Networking(urlSession: urlSession)
        
        networking.get(.CatFacts.getFacts(10))
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                case .failure(_):
                    XCTFail()
                }
            }, receiveValue: { data in
                guard let catFact: CatFact = data else {
                    XCTFail()
                    return
                }
                XCTAssert(catFact.facts.count == 8)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
