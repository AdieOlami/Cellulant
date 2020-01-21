//
//  UserCell.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit

class UserCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.snp.remakeConstraints { (make) in
            make.size.equalTo(40)
        }
        
        detailLabel.isHidden = false
        attributedDetailLabel.isHidden = false
        secondDetailLabel.textAlignment = .right
        textsStackView.axis = .horizontal
        textsStackView.distribution = .fillEqually
    }

    override func bind(to viewModel: DefaultTableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? UserListCellViewModel else { return }
        print("THIS IS THE ITEM BEOO")
    }
}
