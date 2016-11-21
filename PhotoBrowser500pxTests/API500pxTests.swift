//
//  API500pxTests.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-19.
//  Copyright © 2016 Sid. All rights reserved.
//

import XCTest
@testable import PhotoBrowser500px

class API500pxTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetPhotosDefault() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let asyncExpectation = expectation(description: "API500px getPhotosDefault()")
        
        API500px.getPhotos { (response: API500px.APIImageResponse) in
            XCTAssertTrue(response.images != nil)
            XCTAssertTrue(response.error == nil)
            XCTAssertTrue((response.images?.count)! > 0)
            
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testGetPhotosFreshTodayWithSize440() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let asyncExpectation = expectation(description: "API500px Fresh Today with size 440")
        
        API500px.getPhotos(withFeature: .freshToday, withSize: .fourHundredForty, completionHandler: { (response: API500px.APIImageResponse) -> Void in
            XCTAssertTrue(response.images != nil)
            XCTAssertTrue(response.error == nil)
            XCTAssertTrue((response.images?.count)! > 0)
            XCTAssertTrue(response.images?.first?.curSize == API500px.ImageSize.fourHundredForty)
            XCTAssertTrue(response.images?.first?.feature == API500px.Feature.freshToday)
            
            asyncExpectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testGetPhotosPopularWithSize2() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let asyncExpectation = expectation(description: "API500px Popular with size 2")
        
        API500px.getPhotos(withFeature: .popular, withSize: .two, completionHandler: { (response: API500px.APIImageResponse) -> Void in
            XCTAssertTrue(response.images != nil)
            XCTAssertTrue(response.error == nil)
            XCTAssertTrue((response.images?.count)! > 0)
            XCTAssertTrue(response.images?.first?.curSize == API500px.ImageSize.two)
            XCTAssertTrue(response.images?.first?.feature == API500px.Feature.popular)
            
            asyncExpectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testGetPhotosPopularAnimals() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let asyncExpectation = expectation(description: "API500px Popular animals with size 2")
        
        API500px.getPhotos(withFeature: .popular, withCategories: [.animals], withSize: .two, completionHandler: { (response: API500px.APIImageResponse) -> Void in
            XCTAssertTrue(response.images != nil)
            XCTAssertTrue(response.error == nil)
            XCTAssertTrue((response.images?.count)! > 0)
            XCTAssertTrue(response.images?.first?.curSize == API500px.ImageSize.two)
            XCTAssertTrue(response.images?.first?.feature == API500px.Feature.popular)
            XCTAssertTrue(response.images?.first?.category == API500px.Category.animals)
            
            asyncExpectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testGetPhotosWithResultCount57() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let asyncExpectation = expectation(description: "API500px Popular animals with size 2")
        
        API500px.getPhotos(withFeature: .popular, withSize: .two, withResultCount: 57, completionHandler: { (response: API500px.APIImageResponse) -> Void in
            XCTAssertTrue(response.images != nil)
            XCTAssertTrue(response.error == nil)
            XCTAssertTrue((response.images?.count)! == 57)
            XCTAssertTrue(response.images?.first?.curSize == API500px.ImageSize.two)
            XCTAssertTrue(response.images?.first?.feature == API500px.Feature.popular)
            
            asyncExpectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testGetPhotosWithMultipleCategories() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let asyncExpectation = expectation(description: "API500px Multiple categories")
        
        API500px.getPhotos(withCategories: [.animals, .abstract, .blackAndWhite, .cityAndArchitecture],
                           withSize: .two,
                           completionHandler: { (response: API500px.APIImageResponse) -> Void in
            XCTAssertTrue(response.images != nil)
            XCTAssertTrue(response.error == nil)
            XCTAssertTrue((response.images?.count)! > 0)
            XCTAssertTrue(response.images?.first?.curSize == API500px.ImageSize.two)
            
            XCTAssertTrue((response.images?.contains(where: { (img: Image500px) -> Bool in
                return img.category == .animals
            }))!)

            XCTAssertTrue((response.images?.contains(where: { (img: Image500px) -> Bool in
                return img.category == .abstract
            }))!)
        
            XCTAssertTrue((response.images?.contains(where: { (img: Image500px) -> Bool in
                return img.category == .blackAndWhite
            }))!)

            XCTAssertTrue((response.images?.contains(where: { (img: Image500px) -> Bool in
                return img.category == .cityAndArchitecture
            }))!)

            asyncExpectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 35) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
}
