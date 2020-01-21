//
//  LogManager.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import RxSwift

public func logDebug(_ message: @autoclosure () -> String) {
    log(message())
}

public func logError(_ message: @autoclosure () -> String) {
    log(message())
}

public func logInfo(_ message: @autoclosure () -> String) {
    log(message())
}

public func logVerbose(_ message: @autoclosure () -> String) {
    log(message())
}

public func logWarn(_ message: @autoclosure () -> String) {
    print(message())
}

public func logResourcesCount() {
    #if DEBUG
//    logDebug("RxSwift resources count: \(RxSwift.Resources.total)")
    #endif
}
