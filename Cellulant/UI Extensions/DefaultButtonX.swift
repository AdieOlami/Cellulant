//
//  DefaultButton.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DefaultButtonX: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        shared()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shared() {
        translatesAutoresizingMaskIntoConstraints = false
//        setTitleColor(.white, for: .normal)
        layer.masksToBounds = true
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
