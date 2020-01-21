//
//  Api.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import RxSwift

protocol Api {
//    func getUsers(page: Int) -> Single<ResponseBase>
//    func getUsers(page: Int) -> Single<ResponseBase>
    func getUsers(page: Int) -> Single<FastResponseArray<ResponseBase>>
    
}

struct FastResponseArray<ResponseData: Codable>: Codable {
    var error: Bool?
    var message: String?
    var data: [ResponseData]?
    
    var isSucessful: Bool {
        return error == false
    }

}
