//
//  HTTPClientTests.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-19.
//  Copyright © 2016 Sid. All rights reserved.
//

import XCTest
import Alamofire
@testable import PhotoBrowser500px

class HTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetRequestNoParams() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let asyncExpectation = expectation(description: "HTTPClient Get No Params")
        
        HTTPClient.request(URL(string: "https://httpbin.org/get")!, completionHandler: {(response: HTTPClient.HTTPResponse) -> Void in
            XCTAssertTrue(response.data != nil)
            XCTAssertTrue(response.error == nil)
            XCTAssertTrue(response.data!["url"] as! String == "https://httpbin.org/get")
            
            asyncExpectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testGetRequestWithParams() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let asyncExpectation = expectation(description: "HTTPClient Get With Params")
        
        HTTPClient.request(URL(string: "https://httpbin.org/get")!, parameters: nil, completionHandler: {(response: HTTPClient.HTTPResponse) -> Void in
            XCTAssertTrue(response.data != nil)
            XCTAssertTrue(response.error == nil)
            XCTAssertTrue(response.data!["url"] as! String == "https://httpbin.org/get")
            
            asyncExpectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testPostRequestNoParams() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let asyncExpectation = expectation(description: "HTTPClient Post No Params")
        
        HTTPClient.request(URL(string: "https://httpbin.org/post")!, method: .post, completionHandler: {(response: HTTPClient.HTTPResponse) -> Void in
            XCTAssertTrue(response.data != nil)
            XCTAssertTrue(response.error == nil)
            XCTAssertTrue(response.data!["url"] as! String == "https://httpbin.org/post")
            
            asyncExpectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testPostRequestWithParams() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let asyncExpectation = expectation(description: "HTTPClient Post With Params")
        
        HTTPClient.request(URL(string: "https://httpbin.org/post")!, method: .post, parameters: nil, completionHandler: {(response: HTTPClient.HTTPResponse) -> Void in
            XCTAssertTrue(response.data != nil)
            XCTAssertTrue(response.error == nil)
            XCTAssertTrue(response.data!["url"] as! String == "https://httpbin.org/post")
            
            asyncExpectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testRequestJpegData() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let asyncExpectation = expectation(description: "HTTPClient Request JPEG Data")
        
        HTTPClient.requestData(URL(string: "https://httpbin.org/image/jpeg")!, completionHandler: {(response: HTTPClient.HTTPDataResponse) -> Void in
            XCTAssertTrue(response.data != nil)
            XCTAssertTrue(response.error == nil)
            XCTAssertTrue((response.data?.count)! > 0)

            asyncExpectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testRequestPngData() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let asyncExpectation = expectation(description: "HTTPClient Request PNG Data")
        
        HTTPClient.requestData(URL(string: "https://httpbin.org/image/png")!, completionHandler: {(response: HTTPClient.HTTPDataResponse) -> Void in
            XCTAssertTrue(response.data != nil)
            XCTAssertTrue(response.error == nil)
            XCTAssertTrue((response.data?.count)! > 0)
            
            asyncExpectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
}
