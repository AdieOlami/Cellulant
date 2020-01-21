//
//  CellulantApi.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import Moya
import Alamofire

protocol ProductAPIType {
    var addXAuth: Bool { get }
}

private let assetDir: URL = {
    let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
}()

enum CellulantApi {
    case getUsers(page: Int)
}

extension CellulantApi: TargetType, ProductAPIType {
    
    var baseURL: URL {
        return URL(string: Config.environment.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getUsers: return "users"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getUsers: return .get
        }
    }
    
    // Leave for Unit Test
    var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        switch self {
            case .getUsers(let page): return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    var addXAuth: Bool {
        switch self {
        default: return true
        }
    }
}

//func stubbedResponse(_ filename: String) -> Data! {
//    @objc class TestClass: NSObject {}
//
//    let bundle = Bundle(for: TestClass.self)
//    let path = bundle.path(forResource: filename, ofType: "json")
//    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
//
//}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

