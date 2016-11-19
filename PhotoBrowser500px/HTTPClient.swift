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
        let error: Error?
    }
    
    enum HTTPResponseError: Error {
        case dataEmpty
        case unexpectedDataType
        case validationFailure(internalError: Error)
    }
    
    func request(_ url: String,
                 method: HTTPMethod = .get,
                 parameters: [String: Any]? = nil,
                 completionHandler: @escaping (HTTPResponse) -> Void)
    {
        Alamofire.request(url, method: method, parameters: parameters).validate().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success:
                debugPrint("Validation Successful")
                
                if let json = response.result.value {
                    if json is Dictionary<String, Any>
                    {
                        let data = json as! Dictionary<String, Any>
                        //response.result.value! as! NSDictionary)["photos"]
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
            case .failure(let error):
                debugPrint(error)
                let error = HTTPResponseError.validationFailure(internalError: error)
                completionHandler(HTTPResponse(data: nil, error: error))
            }
        }
    }
}
