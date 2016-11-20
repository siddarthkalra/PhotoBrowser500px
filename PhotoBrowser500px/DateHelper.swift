//
//  DateHelper.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-19.
//  Copyright © 2016 Sid. All rights reserved.
//

import Foundation

class DateHelper {
    
    class func dateFromString(_ string: String, withDateFormat format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        return dateFormatter.date(from: string)!
    }
    
    class func dateFromISO8601String(_ string: String) -> Date {
        return DateHelper.dateFromString(string, withDateFormat: "yyyy-MM-dd'T'HH:mm:ssZZ")
    }
    
    class func stringFromDate(date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        return dateFormatter.string(from: date as Date)
    }
    
    class func stringFromDate(date: NSDate, withDateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date as Date)
    }
    
    class func stringFromDate(date: Date, withDateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
    
    class func datesAreOnSameDay(date1: Date, date2: Date) -> Bool {
        let userCalender: Calendar = Calendar.current
        return userCalender.compare(date1, to: date2, toGranularity: .day) == .orderedSame
    }
}
