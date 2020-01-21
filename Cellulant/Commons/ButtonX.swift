//
//  Button.swift
//  Cellulant
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

public class ButtonX: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {


        layer.masksToBounds = true
        titleLabel?.lineBreakMode = .byWordWrapping
//        cornerRadius = Config.BaseDimensions.cornerRadius


        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}

import RxSwift
import RxCocoa

public extension Reactive where Base: UIButton {

    /// Bindable sink for `titleColor` property
    func borderColorX() -> Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.layer.borderColor = attr?.cgColor
            view.layer.borderWidth = 1
        }
    }
    
}
