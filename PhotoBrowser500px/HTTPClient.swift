//
//  HTTPClient.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-19.
//  Copyright © 2016 Sid. All rights reserved.
//

import Foundation
import Alamofire

class HTTPClient {
    
    public struct HTTPResponse {
        let data: Dictionary<String, Any>?
        let error: HTTPResponseError?
    }
    
    public struct HTTPDataResponse {
        let data: Data?
        let error: HTTPResponseError?
    }
    
    enum HTTPResponseError: Error {
        case noConnection
        case dataEmpty
        case unexpectedDataType
        case validationFailure(internalError: Error)
    }
    
    // Returns binary data
    class func requestData(_ url: URL,
                           parameters: [String: Any]? = nil,
                           completionHandler: @escaping (HTTPDataResponse) -> Void)
    {
        if !Reachability.isConnectedToNet() {
            let error = HTTPResponseError.noConnection
            completionHandler(HTTPDataResponse(data: nil, error: error))
            
            return
        }
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseData { (response: DataResponse<Data>) in
            switch response.result {
            case .success:
                debugPrint("Validation Successful")
                
                if let data = response.result.value {
                    completionHandler(HTTPDataResponse(data: data, error: nil))
                }
                else {
                    // failed
                    let error = HTTPResponseError.dataEmpty
                    completionHandler(HTTPDataResponse(data: nil, error: error))
                }
                
                break
            case .failure(let error):
                debugPrint(response.request!)
                debugPrint(response.response!)
                debugPrint(error)
                let error = HTTPResponseError.validationFailure(internalError: error)
                completionHandler(HTTPDataResponse(data: nil, error: error))
                
                break
            }
        }
    }
    
    // Returns JSON
    class func request(_ url: URL,
                       method: HTTPMethod = .get,
                       parameters: [String: Any]? = nil,
                       completionHandler: @escaping (HTTPResponse) -> Void)
    {
        if !Reachability.isConnectedToNet() {
            let error = HTTPResponseError.noConnection
            completionHandler(HTTPResponse(data: nil, error: error))
            
            return
        }
        
        Alamofire.request(url, method: method, parameters: parameters).validate().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    if json is Dictionary<String, Any>
                    {
                        let data = json as! Dictionary<String, Any>
                        completionHandler(HTTPResponse(data: data, error: nil))
                    }
                    else {
                        // failed
                        let error = HTTPResponseError.unexpectedDataType
                        completionHandler(HTTPResponse(data: nil, error: error))
                    }
                }
                else {
                    // failed
                    let error = HTTPResponseError.dataEmpty
                    completionHandler(HTTPResponse(data: nil, error: error))
                }
                
                break
            case .failure(let error):
                debugPrint(error)
                debugPrint(response.request)
                let error = HTTPResponseError.validationFailure(internalError: error)
                completionHandler(HTTPResponse(data: nil, error: error))
                
                break
            }
        }
    }
}
