//
//  DefaultTextField.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit

class DefaultTextField: UITextField, UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shared()
        makeUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        shared()
        makeUI()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.green.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    func shared() {
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
        borderStyle = .none
        layer.cornerRadius = 7.0
        layer.borderWidth = 1.0
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        layer.borderColor = UIColor.green.cgColor
    }
    
    override var placeholder: String? {
        didSet {
        }
    }

    func makeUI() {
        
        layer.masksToBounds = true
        layer.borderWidth = Config.BaseDimensions.borderWidth
        layer.cornerRadius = Config.BaseDimensions.cornerRadius

        snp.makeConstraints { (make) in
            make.height.equalTo(Config.BaseDimensions.textFieldHeight)
        }
    }
}

extension UITextField {
    
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setIconLeft(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 10, width: 12, height: 12))
        iconView.image = image
        
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 30, y: 0, width: 35, height: 35))
        iconContainerView.addSubview(iconView)
        
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func setIconLeftWide(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 5, y: 5, width: 25, height: 25))
        iconView.image = image
        
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 30, y: 0, width: 35, height: 35))
        iconContainerView.addSubview(iconView)
        
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func setIconRight(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 5, y: 10, width: 10, height: 10))
        iconView.image = image
        
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 30, y: 0, width: 35, height: 35))
        iconContainerView.addSubview(iconView)
        
        rightView = iconContainerView
        rightView?.contentMode = .scaleAspectFit
        rightViewMode = .always
    }
}
