//
//  DefaultLabel.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit

class DefaultLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shared()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shared() {
        textColor = .black
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont(name: "Avenir", size: 16)
        textAlignment = .left
        numberOfLines = 0
    }
}

class UnderlinedLabel: DefaultLabel {
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}

