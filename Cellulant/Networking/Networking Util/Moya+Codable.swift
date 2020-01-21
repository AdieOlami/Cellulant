//
//  Moya+Codable.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import RxSwift
import Moya

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    func mapObject<T: Codable>(_ type: T.Type, path: String? = nil) -> Single<T> {
        return flatMap { response -> Single<T> in
            return Single.just(try response.mapObject(type, path: path))
        }
    }
    
    func mapArray<T: Codable>(_ type: T.Type, path: String? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(try response.mapArray(type, path: path))
        }
    }
    
    func filterSuccess() -> Single<E> {
        return flatMap { (response) -> Single<E> in
            if 200 ... 299 ~= response.statusCode {
                return Single.just(response)
            } else {
                let netError = NetworkingError(response)
                return Single.error(netError)
            }
        }
    }
    
//    func filterSuccess() -> Single<E> {
//        return flatMap { (response) -> Single<E> in
//            if 200 ... 299 ~= response.statusCode {
//                return Single.just(response)
//            }
//
//            print("THIS ERROR JSON jsonObject2 xx mm \(response.data)")
//
//            do {
//                let jsonObject2 = try JSONSerialization.jsonObject(with: response.getJsonData(), options: .allowFragments)
//                print("THIS ERROR JSON jsonObject2 xx \(jsonObject2)")
//                let jsonObject = try JSONSerialization.jsonObject(with: response.getJsonData(), options: .allowFragments) as? NetworkingError
//
//                print("THIS ERROR JSON  xx \(jsonObject)")
//                return Single.error(jsonObject ?? NetworkingError.self as! Error)
//            }
//        }
//    }
}

extension Response {
    
    // MARK: -
    func mapObject<T: Codable>(_ type: T.Type, path: String? = nil) throws -> T {
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: try getJsonData(path))
        } catch let error {
            ////// GET WHERE TYE ERROR IS
            log("ERROR IN CODE \(error)", .error)
            throw MoyaError.jsonMapping(self)
        }
    }
    
    // MARK: -
    func mapArray<T: Codable>(_ type: T.Type, path: String? = nil) throws -> [T] {
        
        do {
            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([T].self, from: try getJsonData(path))
        } catch let error {
            log("ERROR IN CODE 2 \(error)", .error)
            throw MoyaError.jsonMapping(self)
        }
    }
    
    // MARK: -
    func getJsonData(_ path: String? = nil) throws -> Data {
        
        do {
            
            var jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            if let path = path {
                
                guard let specificObject = jsonObject.value(forKeyPath: path) else {
                    throw MoyaError.jsonMapping(self)
                }
                jsonObject = specificObject as AnyObject
            }
            
            return try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        } catch let error {
            log("ERROR IN CODE 3 \(error)", .error)
            throw MoyaError.jsonMapping(self)
        }
    }
}

public extension ObservableType where E == Response {
    
    func mapObject<T: Codable>(_ type: T.Type, _ path: String? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(type, path: path))
        }
    }
    
    func mapArray<T: Codable>(_ type: T.Type, _ path: String? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(type, path: path))
        }
    }
    
//    func filterSuccess() -> Observable<E> {
//        return flatMap { (response) -> Observable<E> in
//            guard 200 ... 299 ~= response.statusCode else {
//                return Observable.just(response)
//            }
//
//            do {
//                let jsonObject2 = try JSONSerialization.jsonObject(with: response.getJsonData(), options: .allowFragments)
//                print("THIS ERROR JSON jsonObject2 \(jsonObject2)")
//                let jsonObject = try JSONSerialization.jsonObject(with: response.getJsonData(), options: .allowFragments) as? NetworkingError
////                if let error = jsonObject {
//                    print("THIS ERROR JSON \(jsonObject)")
//                return Observable.error(jsonObject ?? NetworkingError.self as! Error)
////                }
//            }
//
////            if let errorJson = try response.getJsonData(),
////                let error = Mapper<NetworkingError>().map(errorJson) {
////                return Observable.error(error)
////            }
//
//            // Its an error and can't decode error details from server, push generic message
////            let genericError = NetworkingError.init(httpResponse: <#T##HTTPURLResponse?#>, networkData: <#T##Data?#>, baseError: <#T##Error#>)
////////                .genericError(code: response.statusCode, message: "Unknown Error")
////            return Observable.error(genericError)
//        }
//    }
}
