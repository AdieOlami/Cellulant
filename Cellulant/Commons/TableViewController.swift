//
//  TableViewController.swift
//  Cellulant
//
//  Created by Olar's Mac on 10/13/19.
//  Copyright © 2019 Adie Olalekan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import KafkaRefresh
import DZNEmptyDataSet

class TableViewController: ViewController, UIScrollViewDelegate {

    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()

    let isHeaderLoading = BehaviorRelay(value: false)
    let isFooterLoading = BehaviorRelay(value: false)

    lazy var tableView: TableView = {
        let view = TableView(frame: CGRect(), style: .plain)
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.rx.setDelegate(self).disposed(by: rx.disposeBag)
        return view
    }()

    var clearsSelectionOnViewWillAppear = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if clearsSelectionOnViewWillAppear == true {
            deselectSelectedRow()
        }
    }

    override func makeUI() {
        super.makeUI()

        stackView.spacing = 0
        stackView.insertArrangedSubview(tableView, at: 0)

        tableView.bindGlobalStyle(forHeadRefreshHandler: { [weak self] in
            self?.headerRefreshTrigger.onNext(())
        })

        tableView.bindGlobalStyle(forFootRefreshHandler: { [weak self] in
            self?.footerRefreshTrigger.onNext(())
        })

//        isHeaderLoading.bind(to: tableView.headRefreshControl.rx.isAnimating).disposed(by: rx.disposeBag)
//        isFooterLoading.bind(to: tableView.footRefreshControl.rx.isAnimating).disposed(by: rx.disposeBag)

        tableView.footRefreshControl.autoRefreshOnFoot = true

        let updateEmptyDataSet = isLoading.mapToVoid().asObservable().merge(with: emptyDataSetImageTintColor.mapToVoid()).merge(with: languageChanged.asObservable())
//        let updateEmptyDataSet = Observable.of(isLoading.mapToVoid().asObservable(), emptyDataSetImageTintColor.mapToVoid(), languageChanged.asObservable()).merge()
        updateEmptyDataSet.subscribe(onNext: { [weak self] (_) in
            self?.tableView.reloadEmptyDataSet()
        }).disposed(by: rx.disposeBag)

        error.subscribe(onNext: { [weak self] (error) in
            var title = ""
            var description = ""
//            let image = R.image.icon_toast_warning()
            switch error {
            case .serverError(let response): break
//                title = response.message ?? ""
//                description = response.message ?? ""
            }
//            self?.tableView.makeToast(description, title: title, image: image)
        }).disposed(by: rx.disposeBag)
    }

    override func updateUI() {
        super.updateUI()
    }
}

extension TableViewController {

    func deselectSelectedRow() {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            selectedIndexPaths.forEach({ (indexPath) in
                tableView.deselectRow(at: indexPath, animated: false)
            })
        }
    }
}

extension TableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.font = UIFont(name: ".SFUIText-Bold", size: 15.0)!
            view.contentView.backgroundColor = .white
            view.textLabel?.textColor = .black
//            themeService.rx
//                .bind({ $0.text }, to: view.textLabel!.rx.textColor)
//                .bind({ $0.primaryDark }, to: view.contentView.rx.backgroundColor)
//                .disposed(by: rx.disposeBag)
        }
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteButton = UITableViewRowAction(style: .default, title: "HIDE") { (action, indexPath) in
//            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
//            return
//        }
//
//        let moreButton = UITableViewRowAction(style: .default, title: "MORE") { (action, indexPath) in
//            // here is yours custom action
//            return
//        }
//        return [deleteButton, moreButton]
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let delete = deleteAction(at: indexPath)
            let config = UISwipeActionsConfiguration(actions: [delete])
            return config
        }

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .destructive, title: "") {[weak self] (action, view, completion) in
            guard let self = self else { return completion(true) }
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            self.tableView.reloadData()
            completion(true)

        }
        action.image = #imageLiteral(resourceName: "trashicon")
        action.backgroundColor = UIColor(hexString: "#D01F1D")
        return action
    }
}
