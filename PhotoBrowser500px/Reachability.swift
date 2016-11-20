//
//  Reachability.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-19.
//  Copyright © 2016 Sid. All rights reserved.
//

import Foundation

class Reachability {
    
    enum NetworkStatus {
        case notConnected
        case connectionViaWiFi
        case connectionViaWWAN
    }
    
    class func isConnectedToNet() -> Bool {
        let networkStatus = Reachability.isConnected()
        return networkStatus == NetworkStatus.connectionViaWiFi || networkStatus == NetworkStatus.connectionViaWWAN
    }
    
    class func isConnected() -> NetworkStatus {
        return NetworkStatus.connectionViaWiFi
    }
}
