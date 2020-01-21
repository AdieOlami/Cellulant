//
//  ApiClient.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import Alamofire
import netfox

class ApiClient {
    static let session: Session = {
        let config = URLSessionConfiguration.default
        if Config.buildType == .debug {
            config.protocolClasses?.insert(NFXProtocol.self, at: 0)
        }
        config.headers = .default
        
        config.httpAdditionalHeaders?["User-Agent"] = "\(Bundle.main.bundleIdentifier!)/\("iOS")/\(Bundle.main.buildNumber!)"
        return Alamofire.Session(configuration: config)
    }()
}

//final class func defaultAlamofireSession() -> Session {
//    let configuration = URLSessionConfiguration.default
//    configuration.headers = .default
//
//    return Session(configuration: configuration, startRequestsImmediately: false)
//}
