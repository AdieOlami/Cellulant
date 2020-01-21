//
//  Config.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit

struct Config {
    static let environment: Environment = {
        #if STAGING
        return .staging
        #else
        return .production
        #endif
    }()
    
    static let buildType: BuildType = {
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }()
    
    private init() {}
    
    struct Network {
        static let useStaging = false  // set true for tests and generating screenshots with fastlane
        static let loggingEnabled = false
    }
    
    struct BaseDimensions {
        static let inset: CGFloat = 10
        static let tabBarHeight: CGFloat = 58
        static let toolBarHeight: CGFloat = 66
        static let navBarWithStatusBarHeight: CGFloat = 64
        static let cornerRadius: CGFloat = 5
        static let borderWidth: CGFloat = 1
        static let buttonHeight: CGFloat = 40
        static let textFieldHeight: CGFloat = 50
        static let tableRowHeight: CGFloat = 40
        static let segmentedControlHeight: CGFloat = 36
    }

    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        static let Tmp = NSTemporaryDirectory()
    }

    struct UserDefaultsKeys {
        static let bannersEnabled = "BannersEnabled"
    }
}

enum Environment: String {
    case staging, production
    
    var baseURL: String {
        switch self {
        case .staging: return "https://reqres.in/api/"
        case .production: return "https://reqres.in/api/"
        }
    }
    
}

enum BuildType: String {
    case debug, release
}
