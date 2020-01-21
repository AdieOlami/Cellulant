//
//  ViewModelType.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
//import RxSwiftExt
import RxOptional
import NSObject_Rx

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

class ViewModel: NSObject {

    let provider: Api

    var page = 1

    let loading = ActivityIndicator()
    let headerLoading = ActivityIndicator()
    let footerLoading = ActivityIndicator()

    let error = ErrorTracker()
    let parsedError = PublishSubject<ApiError>()

    init(provider: Api) {
        self.provider = provider
        super.init()

        error.asObservable().map { (error) -> ApiError? in
            let errorResponse = error as? MoyaError
            if let errorData = errorResponse?.response?.data {
                let decoder = JSONDecoder()
                    
                do {
                    let response = try decoder.decode(ResponseBase.self, from: errorData)
                    return ApiError.serverError(response: response)
                } catch {
                    print(error)
                }
            }
            
            return nil
        }.filterNil().bind(to: parsedError).disposed(by: rx.disposeBag)

        error.asDriver().drive(onNext: { (error) in
//            logError("\(error)")
        }).disposed(by: rx.disposeBag)
    }

    deinit {
//        logDebug("\(type(of: self)): Deinited")
//        logResourcesCount()
    }
}
