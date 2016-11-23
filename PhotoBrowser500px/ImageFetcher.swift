//
//  ImageFetcher.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-20.
//  Copyright © 2016 Sid. All rights reserved.
//

import Foundation
import UIKit

class ImageFetcher: NSObject {
    
    enum ImageFetcherError: Error {
        case noData
        case invalideImageURL
        case unableToInitImage
        case networkingFailure(httpClientError: Error)
    }
    
    struct ImageFetcherResponse {
        let image: UIImage?
        let tag: Any?
        let error: ImageFetcherError?
    }
    
    // MARK: - Constants
    
    static let CACHE_MAX_CAPACITY = 75 // # of images that the cache can hold
    
    // MARK: - Private Members
    
    private(set) public var cache: [URL: UIImage]
    
    // MARK: - Constructors
    
    override init() {
        self.cache = [:]
        
        super.init()
    }
    
    // MARK: - Public Methods
    
    // fetches asynchronously in the background and calls the completion handler on the main thread
    func fetchImage(urlString: String,
                    tag: Any? = nil,
                    completionHandler: @escaping (ImageFetcherResponse) -> Void)
    {
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                HTTPClient.requestData(url, completionHandler: { (response: HTTPClient.HTTPDataResponse) in
                    if let error = response.error
                    {
                        // failed there was an HTTPResponseError
                        DispatchQueue.main.async {
                            let error = ImageFetcherError.networkingFailure(httpClientError: error)
                            completionHandler(ImageFetcherResponse(image: nil, tag: tag, error: error))
                        }
                    }
                    else if let data = response.data {
                        // success - create the UIImage
                        if let image = UIImage(data: data) {
                            
                            if let cachedImage = self.cache[url] {
                                DispatchQueue.main.async {
                                    completionHandler(ImageFetcherResponse(image: cachedImage, tag: tag, error: nil))
                                }
                            }
                            else {
                                if self.cache.count == ImageFetcher.CACHE_MAX_CAPACITY {
                                    self.purgeCache()
                                }
                                
                                // add to cache
                                self.cache[url] = image
                                
                                DispatchQueue.main.async {
                                    completionHandler(ImageFetcherResponse(image: image, tag: tag, error: nil))
                                }
                            }
                        }
                        else {
                            // failure - unable to create image
                            DispatchQueue.main.async {
                                let error = ImageFetcherError.unableToInitImage
                                completionHandler(ImageFetcherResponse(image: nil, tag: tag, error: error))
                            }
                        }
                    }
                    else {
                        // failure - response.data is nil
                        DispatchQueue.main.async {
                            let error = ImageFetcherError.noData
                            completionHandler(ImageFetcherResponse(image: nil, tag: tag, error: error))
                        }
                    }
                })
            }
            else {
                // failed to create URL, invalid URL string provided
                DispatchQueue.main.async {
                    let error = ImageFetcherError.invalideImageURL
                    completionHandler(ImageFetcherResponse(image: nil, tag: tag, error: error))
                }
            }
        }
    }
    
    func purgeCache() {
        debugPrint("Purging ImageFetcher cache")
        self.cache.removeAll()
    }
}
