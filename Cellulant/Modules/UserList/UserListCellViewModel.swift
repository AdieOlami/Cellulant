//
//  UserListCellViewModel.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserListCellViewModel: DefaultTableViewCellViewModel {

    let response: ResponseBase

    init(with response: ResponseBase) {
        self.response = response
        super.init()
        title.accept("\(response.firstName ?? "") \(response.lastName ?? "")")
//        image.accept(UIImage(named: ""))
        imageUrl.accept(response.avatar)
    }
}
