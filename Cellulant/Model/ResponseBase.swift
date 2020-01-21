//
//  ResponseBase.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation

struct ResponseBase: Codable {
    var id: Int?
    var email: String?
    var firstName: String?
    var lastName: String?
    var avatar: String?
}
