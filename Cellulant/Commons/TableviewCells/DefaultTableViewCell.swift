//
//  DefaultTableViewCell.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit
import SwifterSwift

class DefaultTableViewCell: TableViewCell {

    lazy var leftImageView: ImageViewX = {
        let view = ImageViewX(frame: CGRect())
        view.contentMode = .scaleAspectFit
        view.snp.makeConstraints({ (make) in
            make.size.equalTo(50)
        })
        return view
    }()

    lazy var badgeImageView: ImageViewX = {
        let view = ImageViewX(frame: CGRect())
        view.backgroundColor = .white
//        view.cornerRadius = 10
        view.borderColor = .white
//        view.borderWidth = 1
        containerView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.bottom.left.equalTo(self.leftImageView)
            make.size.equalTo(20)
        })
        return view
    }()

    lazy var titleLabel: LabelX = {
        let view = LabelX()
        view.font = view.font.withSize(14)
        return view
    }()

    lazy var detailLabel: LabelX = {
        let view = LabelX()
        view.font = view.font.withSize(12)
        view.setPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.vertical)
        return view
    }()

    lazy var secondDetailLabel: LabelX = {
        let view = LabelX()
        view.font = UIFont.boldSystemFont(ofSize: 12)
        return view
    }()

    lazy var attributedDetailLabel: LabelX = {
        let view = LabelX()
        view.font = UIFont.boldSystemFont(ofSize: 11)
        return view
    }()

    lazy var textsStackView: StackViewX = {
        let views: [UIView] = [self.titleLabel, self.detailLabel, self.secondDetailLabel, self.attributedDetailLabel]
        let view = StackViewX(arrangedSubviews: views)
        view.spacing = 2
        return view
    }()

    lazy var rightImageView: ImageViewX = {
        let view = ImageViewX(frame: CGRect())
        view.snp.makeConstraints({ (make) in
            make.width.equalTo(20)
        })
        return view
    }()

    override func makeUI() {
        super.makeUI()
        print("THIS IS THE ITEM (viewModel.title.value)")
        stackView.addArrangedSubview(leftImageView)
        stackView.addArrangedSubview(textsStackView)
        stackView.addArrangedSubview(rightImageView)
        stackView.snp.remakeConstraints({ (make) in
            let inset = self.inset
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: inset/2, left: inset, bottom: inset/2, right: inset))
            make.height.greaterThanOrEqualTo(Config.BaseDimensions.tableRowHeight)
        })
    }

    func bind(to viewModel: DefaultTableViewCellViewModel) {
        
        print("THIS IS THE ITEM \(viewModel.title.value)")
        viewModel.title.asDriver().drive(titleLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.title.asDriver().replaceNilWith("").map { $0.isEmpty }.drive(titleLabel.rx.isHidden).disposed(by: rx.disposeBag)

        viewModel.detail.asDriver().drive(detailLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.detail.asDriver().replaceNilWith("").map { $0.isEmpty }.drive(detailLabel.rx.isHidden).disposed(by: rx.disposeBag)

        viewModel.secondDetail.asDriver().drive(secondDetailLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.secondDetail.asDriver().replaceNilWith("").map { $0.isEmpty }.drive(secondDetailLabel.rx.isHidden).disposed(by: rx.disposeBag)

        viewModel.attributedDetail.asDriver().drive(attributedDetailLabel.rx.attributedText).disposed(by: rx.disposeBag)
        viewModel.attributedDetail.asDriver().map { $0 == nil }.drive(attributedDetailLabel.rx.isHidden).disposed(by: rx.disposeBag)

        viewModel.badge.asDriver().drive(badgeImageView.rx.image).disposed(by: rx.disposeBag)
        viewModel.badge.map { $0 == nil }.asDriver(onErrorJustReturn: true).drive(badgeImageView.rx.isHidden).disposed(by: rx.disposeBag)


        viewModel.hidesDisclosure.asDriver().drive(rightImageView.rx.isHidden).disposed(by: rx.disposeBag)

        viewModel.image.asDriver().filterNil()
            .drive(leftImageView.rx.image).disposed(by: rx.disposeBag)

        viewModel.imageUrl.map { $0?.url }.asDriver(onErrorJustReturn: nil).filterNil()
            .drive(leftImageView.rx.imageURL).disposed(by: rx.disposeBag)

        viewModel.imageUrl.asDriver().filterNil()
            .drive(onNext: { [weak self] (url) in
//                self?.leftImageView.hero.id = url
            }).disposed(by: rx.disposeBag)
    }
}
