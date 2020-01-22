//
//  UserListVC.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Rswift
import Material
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = "UserListVC"

class UserListVC: TableViewController {
    
    let disposeBag = DisposeBag()
    lazy var tableViewX: TableView = {
        let view = TableView(frame: CGRect(), style: .plain)
        view.delegate = self
//        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func makeUI() {
        super.makeUI()
//        tableView.register(R.nib.userCell)
        view.addSubview(tableViewX)
        tableViewX.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        tableViewX.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? UserListViewModel else { return }

        let refresh = rx.viewWillAppear.mapToVoid().merge(with: languageChanged.asObservable())
        let input = UserListViewModel.Input(trigger: refresh, footerRefresh: footerRefreshTrigger,
                                            selection: tableView.rx.modelSelected(UserListCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        viewModel.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)
        viewModel.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)


        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableViewX.rx.items(cellIdentifier: reuseIdentifier, cellType: UserCell.self)) { tableView, viewModel, cell in
                cell.textLabel?.text = "\(viewModel.response.firstName ?? "") \(viewModel.response.lastName ?? "")"
                let url = URL(string: viewModel.response.avatar ?? "https://example.com/image.png")
                cell.imageView?.kf.setImage(with: url)
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)
        
//        items
//        .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
//            cell.textLabel?.text = "\(element) @ row \(row)"
//        }
//        .disposed(by: disposeBag)

        viewModel.branchSelected.subscribe(onNext: { [weak self] (branch) in
            self?.navigator.pop(sender: self)
        }).disposed(by: rx.disposeBag)

        viewModel.error.asDriver().drive(onNext: { [weak self] (error) in
            log("Error")
//            self?.showAlert(title: "HEEEYY ERRORR", message: error.localizedDescription)
        }).disposed(by: rx.disposeBag)
    }
    
}
//
//extension UserListVC: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}
