//
//  API500px.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-19.
//  Copyright © 2016 Sid. All rights reserved.
//

import Foundation

class API500px {
    
    static let API_URL = "https://api.500px.com/v1/"
    static let PHOTOS_END_POINT = "photos"
    
    static let kCONSUMER_KEY = "consumer_key"
    static let kFEATURE = "feature"
    static let kIMAGE_SIZE = "image_size"
    static let kEXCLUDE = "exclude"
    static let kPHOTOS = "photos"
    static let kID = "id"
    static let kNAME = "name"
    static let kDESCRIPTION = "description"
    static let kTIMES_VIEWED = "times_viewed"
    static let kRATING = "rating"
    static let kCREATED_AT = "created_at"
    static let kCATEGORY = "category"
    static let kPRIVACY = "privacy"
    static let kWIDTH = "width"
    static let kHEIGHT = "height"
    static let kVOTES_COUNT = "votes_count"
    static let kCOMMENTS_COUNT = "comments_count"
    static let kNSFW = "nsfw"
    static let kIMAGE_URL = "image_url"
    
    static let CONSUMER_KEY = "fuxM7DPmpU4dQuFubUbQYOcLRUbeQBOGtqlzl56r"
    
    enum Feature: String {
        case popular = "popular"
        case highestRated = "highest_rated"
        case upcoming = "upcoming"
        case editors = "editors"
        case freshToday = "fresh_today"
        case freshYesterday = "fresh_yesterday"
        case freshWeek = "fresh_week"
    }
    
    enum ImageSize: Int {
        case one = 1
        case two = 2
        case hundred = 100
        case twoHundred = 200
        case fourHundredForty = 440
        case sixHundred = 600
    }
    
    enum API500pxError: Error {
        case responseKeyMissing(requiredKey: String)
        case networkingFailure(httpClientError: Error)
    }
    
    struct APIImageResponse {
        let images: [Image500px]?
        let error: API500pxError?
    }
    
    // Runs asynchronously on a background thread
    // Results are also returned on a background thread
    class func getPhotos(withFeature feature: Feature = .freshToday,
                         with size: ImageSize = .fourHundredForty,
                         with qos: DispatchQoS.QoSClass = .userInitiated,
                         completionHandler: @escaping (APIImageResponse) -> Void)
    {
        DispatchQueue.global(qos: qos).async {
            let parameters: Dictionary<String, Any> = [API500px.kCONSUMER_KEY: CONSUMER_KEY,
                                                       API500px.kFEATURE: feature,
                                                       API500px.kIMAGE_SIZE: size,
                                                       API500px.kEXCLUDE: "Nude"]
            
            let photosEndPoint = API500px.API_URL + API500px.PHOTOS_END_POINT
            HTTPClient.request(photosEndPoint, method: .get, parameters: parameters, completionHandler: {(response: HTTPClient.HTTPResponse) -> Void in
                if let error = response.error {
                    let error500pxAPI = API500pxError.networkingFailure(httpClientError: error)
                    completionHandler(APIImageResponse(images: nil, error: error500pxAPI))
                }
                else if let data = response.data {
                    if let imageData = data[kPHOTOS] {
                        var images: [Image500px] = []
                        
                        for imageInfo in (imageData as! [Dictionary<String, Any>])
                        {
                            let image500px = Image500px(id: imageInfo[API500px.kID] as! String,
                                                        name: imageInfo[API500px.kNAME] as! String,
                                                        description: imageInfo[API500px.kDESCRIPTION] as! String,
                                                        timesViewed: imageInfo[API500px.kTIMES_VIEWED] as! Int,
                                                        rating: imageInfo[API500px.kRATING] as! Float,
                                                        created_at: imageInfo[API500px.kCREATED_AT] as! Date,
                                                        category: imageInfo[API500px.kCATEGORY] as! Int,
                                                        privacy: (imageInfo[API500px.kPRIVACY] != nil),
                                                        width: imageInfo[API500px.kWIDTH] as! Int,
                                                        height: imageInfo[API500px.kHEIGHT] as! Int,
                                                        votesCount: imageInfo[API500px.kVOTES_COUNT] as! Int,
                                                        commentsCount: imageInfo[API500px.kCOMMENTS_COUNT] as! Int,
                                                        nsfw: (imageInfo[API500px.kNSFW] != nil),
                                                        imageURL: URL(string: imageInfo[API500px.kIMAGE_URL] as! String)!)
                            images.append(image500px)
                        }
                        
                        completionHandler(APIImageResponse(images: images, error: nil))
                    }
                    else {
                        completionHandler(APIImageResponse(images: nil, error: API500pxError.responseKeyMissing(requiredKey: kPHOTOS)))
                    }
                }
            })
        }
    }
}
