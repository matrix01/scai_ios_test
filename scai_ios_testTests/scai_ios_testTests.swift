//
//  scai_ios_testTests.swift
//  scai_ios_testTests
//
//  Created by Milan Mia on 8/5/21.
//

import XCTest
@testable import scai_ios_test

class scai_ios_testTests: XCTestCase {

    var networkManagerMock: NetworkManagerMock!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        networkManagerMock = NetworkManagerMock()
    }

    func testNetworkMockDecodeTest() {
        guard let request = ApiRequest.detailList.request else {
            XCTFail("Api request should not be nil.")
            return
        }
        let expectation = XCTestExpectation(description: "Network request expectation")
        
        var detailList: PhotoDetail?
        
        networkManagerMock.request(urlRequest: request, type: PhotoDetail.self)
            .subscribe(onNext: { list in
                defer {
                    expectation.fulfill()
                }
                detailList = list 
            }, onError: { error in
                XCTAssertNil(error)
                XCTFail("Network call should pass.")
            }).disposed(by: rx.disposeBag)
        
        wait(for: [expectation], timeout: 10.0)
        XCTAssertNotNil(detailList)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkManagerMock = nil
    }
}
