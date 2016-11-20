//
//  DateHelperTests.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-19.
//  Copyright © 2016 Sid. All rights reserved.
//

import XCTest
@testable import PhotoBrowser500px

class DataHelperTests: XCTestCase {
    
    var testDate: Date? = nil
    var testDateStrShortStyle: String? = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // to keep the tests consistent let's use the gregorian calendar
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2009
        components.month = 6
        components.day = 15
        components.hour = 5
        components.minute = 20
        
        let date = calendar.date(from: components)
        self.testDate = date!
        
        self.testDateStrShortStyle = "6/15/09, 5:20 AM"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        self.testDate = nil
        self.testDateStrShortStyle = nil
    }
    
    func testDateFromString() {
        let dateStr = "2009/06/15 5:20"
        let date = DateHelper.dateFromString(dateStr, withDateFormat: "yyyy/MM/dd h:m")
        
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        XCTAssertTrue(dateComponents.year == 2009)
        XCTAssertTrue(dateComponents.month == 6)
        XCTAssertTrue(dateComponents.day == 15)
        XCTAssertTrue(dateComponents.hour == 5)
        XCTAssertTrue(dateComponents.minute == 20)
    }
    
    func testDateFromISO8601String() {
        let ISO8601DateStr = "2012-02-09T02:27:16-05:00"
        let date = DateHelper.dateFromISO8601String(ISO8601DateStr)
        
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .timeZone], from: date)
        
        XCTAssertTrue(dateComponents.year == 2012)
        XCTAssertTrue(dateComponents.month == 2)
        XCTAssertTrue(dateComponents.day == 9)
        XCTAssertTrue(dateComponents.hour == 2)
        XCTAssertTrue(dateComponents.minute == 27)
        XCTAssertTrue(dateComponents.second == 16)
        XCTAssertTrue(dateComponents.timeZone == TimeZone(identifier: "America/Toronto"))
    }
    
    func testStringFromDate() {
        let dateStr = DateHelper.stringFromDate(date: self.testDate! as NSDate)
        XCTAssertTrue(dateStr == self.testDateStrShortStyle)
    }
    
    func testStringFromDateWithFormat() {
        let dateStr = DateHelper.stringFromDate(date: self.testDate!, withDateFormat: "yyyy/MM/dd h:m a")
        let dateStr2 = DateHelper.stringFromDate(date: self.testDate! as NSDate, withDateFormat: "yyyy/MM/dd h:m a")
        
        XCTAssertTrue(dateStr == "2009/06/15 5:20 AM")
        XCTAssertTrue(dateStr2 == "2009/06/15 5:20 AM")
    }
    
    func testDatesAreOnSameDay() {
        let date1 = self.testDate
        
        // to keep the tests consistent let's use the gregorian calendar
        let calendar = Calendar(identifier: .gregorian)
        
        // Create a date that is on the same day but different time
        var components = DateComponents()
        components.year = 2009
        components.month = 6
        components.day = 15
        components.hour = 2
        components.minute = 50
        
        let dateSameDay = calendar.date(from: components)
        XCTAssertTrue(DateHelper.datesAreOnSameDay(date1: date1!, date2: dateSameDay!))
        
        // Create a date that is on a different day
        var components2 = DateComponents()
        components2.year = 2009
        components2.month = 6
        components2.day = 25
        components2.hour = 2
        components2.minute = 50
        
        let dateDiffDay = calendar.date(from: components2)
        XCTAssertTrue(!DateHelper.datesAreOnSameDay(date1: date1!, date2: dateDiffDay!))
    }
}
