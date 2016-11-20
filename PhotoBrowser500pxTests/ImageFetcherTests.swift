//
//  ImageFetcherTests.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-20.
//  Copyright © 2016 Sid. All rights reserved.
//

import XCTest
@testable import PhotoBrowser500px

class ImageFetcherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchPngImage() {
        
        let asyncExpectation = expectation(description: "ImageFetcher Get PNG Image")
        
        let imageFetcher = ImageFetcher()
        imageFetcher.fetchImage(urlString: "https://httpbin.org/image/png", completionHandler: { (response: ImageFetcher.ImageFetcherResponse) -> Void in
            let zeroSize = CGSize(width: 0.0, height: 0.0)
            
            XCTAssertTrue(response.image != nil)
            XCTAssertTrue(response.error == nil)
            XCTAssertTrue((response.image?.size.width)! > zeroSize.width)
            XCTAssertTrue((response.image?.size.height)! > zeroSize.height)

            asyncExpectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testFetchJpegImage() {
        
        let asyncExpectation = expectation(description: "ImageFetcher Get JPEG Image")
        
        let imageFetcher = ImageFetcher()
        imageFetcher.fetchImage(urlString: "https://httpbin.org/image/jpeg", completionHandler: { (response: ImageFetcher.ImageFetcherResponse) -> Void in
            let zeroSize = CGSize(width: 0.0, height: 0.0)
            
            XCTAssertTrue(response.image != nil)
            XCTAssertTrue(response.error == nil)
            XCTAssertTrue((response.image?.size.width)! > zeroSize.width)
            XCTAssertTrue((response.image?.size.height)! > zeroSize.height)
            
            asyncExpectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
}
