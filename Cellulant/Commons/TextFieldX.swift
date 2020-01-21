//
//  TextField.swift
//  Cellulant
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

class TextFieldX: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    override var placeholder: String? {
        didSet {
//            themeService.switch(themeService.type)
        }
    }

    func makeUI() {
//        themeService.rx
//            .bind({ $0.text }, to: rx.textColor)
//            .bind({ $0.secondary }, to: rx.tintColor)
//            .bind({ $0.textGray }, to: rx.placeholderColor)
//            .bind({ $0.text }, to: rx.borderColor)
//            .bind({ $0.keyboardAppearance }, to: rx.keyboardAppearance)
//            .disposed(by: rx.disposeBag)
//
//        layer.masksToBounds = true
//        borderWidth = Config.BaseDimensions.borderWidth
//        cornerRadius = Config.BaseDimensions.cornerRadius
//
//        snp.makeConstraints { (make) in
//            make.height.equalTo(Config.BaseDimensions.textFieldHeight)
//        }
    }
}
