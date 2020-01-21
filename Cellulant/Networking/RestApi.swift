//
//  RestApi.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Alamofire

typealias MoyaError = Moya.MoyaError

enum ApiError: Error {
    case serverError(response: ResponseBase)
}

class RestApi: Api {
    
//    func getUsers(page: Int) -> Single<ResponseBase> {
//        return requestObject(.getUsers(page: page), type: ResponseBase.self)
//    }
    
    func getUsers(page: Int) -> Single<FastResponseArray<ResponseBase>> {
        return requestObject(.getUsers(page: page), type: FastResponseArray<ResponseBase>.self)
    }
    
    let fastProvider: FastNetworking
    private var keychain = KeyChainStorage.instance

    init(fastProvider: FastNetworking) {
        self.fastProvider = fastProvider
    }
}

extension RestApi {

    func downloadString(url: URL) -> Single<String> {
        return Single.create { single in
            DispatchQueue.global().async {
                do {
                    single(.success(try String.init(contentsOf: url)))
                } catch {
                    single(.error(error))
                }
            }
            return Disposables.create { }
            }
            .observeOn(MainScheduler.instance)
    }

}

extension RestApi {
    private func request(_ target: CellulantApi) -> Single<Any> {
        return fastProvider.request(target)
            .mapJSON()
            .observeOn(MainScheduler.instance)
            .asSingle()
    }

    private func requestWithoutMapping(_ target: CellulantApi) -> Single<Moya.Response> {
        return fastProvider.request(target)
            .observeOn(MainScheduler.instance)
            .asSingle()
    }

    private func requestObject<T: Codable>(_ target: CellulantApi, type: T.Type) -> Single<T> {
        return fastProvider.request(target)
            .mapObject(T.self)
            .observeOn(MainScheduler.instance)
            .asSingle()
    }
    
    private func requestObjectObservable<T: Codable>(_ target: CellulantApi, type: T.Type) -> Observable<T> {
        return fastProvider.request(target)
            .mapObject(T.self)
            .observeOn(MainScheduler.instance)
            .asObservable()
    }

    private func requestArray<T: Codable>(_ target: CellulantApi, type: T.Type) -> Single<[T]> {
        return fastProvider.request(target)
            .mapArray(T.self)
            .observeOn(MainScheduler.instance)
            .asSingle()
    }
}
