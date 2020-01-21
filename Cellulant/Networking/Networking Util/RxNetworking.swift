//
//  RxNetworking.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxSwiftExt

let networkRetryPredicate: RetryPredicate = { error in
    if let err = error as? NetworkingError, let response = err.httpResponse {
        let code = response.statusCode
        if code >= 399 && code < 600 {
            return false
        }
    }
    
    return true
}

// Use this struct to pass the response and data along with
public struct NetworkingError: Error {
    let httpResponse: HTTPURLResponse?
    let networkData: Data?
    let baseError: MoyaError
    
    init(_ response: Response) {
        self.baseError = MoyaError.statusCode(response)
        self.httpResponse = response.response
        self.networkData = response.data
    }
    
    func getLocalizedDescription() -> String {
        return self.baseError.localizedDescription
    }
    
    func getErrorMessage() -> String? {
        
        guard let errorData = self.networkData else { return nil }
        let decoder = JSONDecoder()
        
        do {
//            let message = try decoder.decode(ResponseBase<String>.self, from: errorData)
//            return message.email
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
