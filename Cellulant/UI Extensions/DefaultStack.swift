//
//  DefaultStack.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit

class DefaultStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        shared()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shared() {
//        axis = .horizontal
        spacing = 10
//        distribution = .equalSpacing
        translatesAutoresizingMaskIntoConstraints = false
    }
}
