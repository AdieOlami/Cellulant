//
//  UserListViewModel.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class UserListViewModel: ViewModel, ViewModelType {

    struct Input {
        let trigger: Observable<Void>
        let footerRefresh: Observable<Void>
        let selection: Driver<UserListCellViewModel>
    }

    struct Output {
        let items: BehaviorRelay<[UserListCellViewModel]>
    }

    let branchSelected = PublishSubject<ResponseBase>()

    override init(provider: Api) {
        super.init(provider: provider)
    }
    func transform(input: Input) -> Output {
        
        let elements = BehaviorRelay<[UserListCellViewModel]>(value: [])
        let refresh = input.trigger
        //            Observable.of(input.trigger, cacheRemoved, nightModeEnabled.mapToVoid()).merge()
                
        refresh.flatMapLatest({ [weak self] () -> Observable<[UserListCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.loading)
        }).subscribe(onNext: { (items) in
            print("THIS IS THE ITEM \(items)")
            elements.accept(items)
        }).disposed(by: rx.disposeBag)

        

        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[UserListCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page += 1
            return self.request()
                .trackActivity(self.footerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(elements.value + items)
            }).disposed(by: rx.disposeBag)

        return Output(items: elements)
    }

    func request() -> Observable<[UserListCellViewModel]> {
        
        var request: Single<FastResponseArray<ResponseBase>>
           
        request = provider.getUsers(page: page)
        
        return request
               .trackActivity(loading)
               .trackError(error)
                .compactMap { $0.data?.map { UserListCellViewModel(with: $0) } }
            }
//        return request
//           .trackActivity(loading)
//           .trackError(error)
//            .compactMap { $0.data?.map { ActiveDeviceCellViewModel(with: $0) } }
//        return provider.getUsers(page: page)
//            .trackActivity(loading)
//            .trackError(error)
//            .map { ($0.data?.map({ (users) -> UserListCellViewModel in
//                let viewModel = UserListCellViewModel(with: users)
//                return viewModel
//            }))!}
//    }
}
