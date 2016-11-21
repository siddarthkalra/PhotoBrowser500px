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
    static let MAX_PHOTO_RESULT_ALLOWED = 100
    
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
    static let kSIZE = "size"
    static let kIMAGES = "images"
    static let kVOTES_COUNT = "votes_count"
    static let kCOMMENTS_COUNT = "comments_count"
    static let kNSFW = "nsfw"
    static let kIMAGE_URL = "image_url"
    static let kRPP = "rpp" // # of results to return
    static let kONLY = "only" // used to filter results by category
    
    static let CONSUMER_KEY = "fuxM7DPmpU4dQuFubUbQYOcLRUbeQBOGtqlzl56r"
    
    enum Feature: String {
        case notSet
        case popular
        case highestRated = "highest_rated"
        case upcoming
        case editors
        case freshToday = "fresh_today"
        case freshYesterday = "fresh_yesterday"
        case freshWeek = "fresh_week"
        
        var description: String {
            switch self {
            case .notSet: return "Not set"
            case .popular: return "popular"
            case .highestRated: return "highest_rated"
            case .upcoming: return "upcoming"
            case .editors: return "editors"
            case .freshToday: return "fresh_today"
            case .freshYesterday: return "fresh_yesterday"
            case .freshWeek: return "fresh_week"
            }
        }
        
        static var allCases: [Feature] {
            return [.notSet, .popular, .highestRated, .upcoming,
                    .editors, .freshToday, .freshYesterday, .freshWeek]
        }
    }
    
    enum Category: Int {
        case notSet = -1
        case uncategorized = 0
        case abstract = 10
        case animals = 11
        case blackAndWhite = 5
        case celebrities = 1
        case cityAndArchitecture = 9
        case commercial = 15
        case concert = 16
        case family = 20
        case fashion = 14
        case film = 2
        case fineArt = 24
        case food = 23
        case journalism = 3
        case landscapes = 8
        case macro = 12
        case nature = 18
        case nude = 4
        case people = 7
        case performingArts = 19
        case sport = 17
        case stillLife = 6
        case street = 21
        case transportation = 26
        case travel = 13
        case underwater = 22
        case urbanExploration = 27
        case wedding = 25
        
        var description: String {
            switch self {
            case .notSet: return "Not set"
            case .uncategorized: return "Uncategorized"
            case .abstract: return "Abstract"
            case .animals: return "Animals"
            case .blackAndWhite: return "Black and White"
            case .celebrities: return "Celebrities"
            case .cityAndArchitecture: return "City and Architecture"
            case .commercial: return "Commercial"
            case .concert: return "Concert"
            case .family: return "Family"
            case .fashion: return "Fashion"
            case .film: return "Film"
            case .fineArt: return "Fine Art"
            case .food: return "Food"
            case .journalism: return "Journalism"
            case .landscapes: return "Landscapes"
            case .macro: return "Macro"
            case .nature: return "Nature"
            case .nude: return "Nude"
            case .people: return "People"
            case .performingArts: return "PerformingArts"
            case .sport: return "Sport"
            case .stillLife: return "Still Life"
            case .street: return "Street"
            case .transportation: return "Transportation"
            case .travel: return "Travel"
            case .underwater: return "Underwater"
            case .urbanExploration: return "Urban Exploration"
            case .wedding: return "Wedding"
            }
        }
        
        static var allCases: [Category] {
            return [.notSet, .uncategorized, .abstract, .animals, .blackAndWhite, .celebrities, .cityAndArchitecture,
                    .commercial, .concert, .family, .fashion, .film, .fineArt, .food, .journalism, .landscapes,
                    .macro, .nature, .nude, .people, .performingArts, .sport, .stillLife, .street, .transportation,
                    .travel, .underwater, .urbanExploration, .wedding]
        }
    }
    
    enum ImageSize: Int {
        case notSet = 0
        case one = 1
        case two = 2
        case hundred = 100
        case twoHundred = 200
        case fourHundredForty = 440
        case sixHundred = 600
    }
    
    enum API500pxError: Error {
        case noData
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
                         withCategory category: Category = .notSet,
                         withSize size: ImageSize = .fourHundredForty,
                         withResultCount resultCount: Int = -1,
                         withQos qos: DispatchQoS.QoSClass = .userInitiated,
                         completionHandler: @escaping (APIImageResponse) -> Void)
    {
        DispatchQueue.global(qos: qos).async {
            var parameters: Dictionary<String, Any> = [API500px.kCONSUMER_KEY: CONSUMER_KEY,
                                                       API500px.kFEATURE: feature.description,
                                                       API500px.kIMAGE_SIZE: size.rawValue,
                                                       API500px.kEXCLUDE: "Nude"]
            if category != .notSet {
                parameters[API500px.kONLY] = category.description
            }
            if resultCount > 0 {
                var actualResultCount = resultCount
                
                if actualResultCount > API500px.MAX_PHOTO_RESULT_ALLOWED {
                   actualResultCount = API500px.MAX_PHOTO_RESULT_ALLOWED
                }
                
                parameters[API500px.kRPP] = actualResultCount
            }
            
            let photosEndPoint = URL(string: API500px.API_URL + API500px.PHOTOS_END_POINT)
            HTTPClient.request(photosEndPoint!, method: .get, parameters: parameters, completionHandler: {(response: HTTPClient.HTTPResponse) -> Void in
                if let error = response.error {
                    let error500pxAPI = API500pxError.networkingFailure(httpClientError: error)
                    completionHandler(APIImageResponse(images: nil, error: error500pxAPI))
                }
                else if let data = response.data {
                    if let imageData = data[kPHOTOS] {
                        var images: [Image500px] = []
                        
                        for imageInfo in (imageData as! [Dictionary<String, Any>])
                        {
                            let image500px = API500px.createImage500px(withImageResponse: imageInfo,
                                                                       withInternalImages: imageInfo[API500px.kIMAGES],
                                                                       withFeature: data[API500px.kFEATURE])
                            images.append(image500px)
                        }
                        
                        completionHandler(APIImageResponse(images: images, error: nil))
                    }
                    else {
                        completionHandler(APIImageResponse(images: nil, error: API500pxError.responseKeyMissing(requiredKey: kPHOTOS)))
                    }
                }
                else {
                    // failure - response.data is nil
                    completionHandler(APIImageResponse(images: nil, error: .noData))
                }
            })
        }
    }
    
    class func createImage500px(withImageResponse imageInfo: Dictionary<String, Any>,
                                withInternalImages internalImagesOptional: Any?,
                                withFeature featureValueOptional: Any?) -> Image500px
    {
        // Get the feature
        var feature: Feature = .notSet
        if let featureValue = featureValueOptional {
            if let featureEnum = Feature(rawValue: featureValue as! String) {
                feature = featureEnum
            }
        }
        
        var imageSize: ImageSize = .notSet
        
        // Get current image size
        // Image500px.width and .height contain the original image size
        if let internalImages = internalImagesOptional
        {
            if internalImages is Array<Dictionary<String, Any>> {
                let firstImg = (internalImages as! Array<Dictionary<String, Any>>).first
                
                if let size = firstImg?[API500px.kSIZE] {
                    if let croppedSize = ImageSize(rawValue: size as! Int) {
                        imageSize = croppedSize
                    }
                }
            }
        }
        
        // Get the category
        var category: Category = .notSet
        if let categoryInt = imageInfo[API500px.kCATEGORY] {
            if let categoryEnum = Category(rawValue: categoryInt as! Int) {
                category = categoryEnum
            }
        }
        
        return Image500px(id: imageInfo[API500px.kID] as! Int,
                          name: imageInfo[API500px.kNAME] as! String,
                          description: imageInfo[API500px.kDESCRIPTION] as? String,
                          timesViewed: imageInfo[API500px.kTIMES_VIEWED] as! Int,
                          rating: imageInfo[API500px.kRATING] as! Float,
                          created_at: DateHelper.dateFromISO8601String(imageInfo[API500px.kCREATED_AT] as! String),
                          category: category,
                          privacy: (imageInfo[API500px.kPRIVACY] != nil),
                          origWidth: imageInfo[API500px.kWIDTH] as! Int,
                          origHeight: imageInfo[API500px.kHEIGHT] as! Int,
                          curSize: imageSize,
                          votesCount: imageInfo[API500px.kVOTES_COUNT] as! Int,
                          commentsCount: imageInfo[API500px.kCOMMENTS_COUNT] as! Int,
                          nsfw: imageInfo[API500px.kNSFW] as! Bool,
                          imageURL: imageInfo[API500px.kIMAGE_URL] as! String,
                          feature: feature)
    }
}
