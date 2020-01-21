//
//  AuthViewModel.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import RxCocoa
import RxSwift

class AuthViewModel: ViewModel, ViewModelType {

    struct Input {
        let nextTrigger: Driver<Void>
    }

    struct Output {
        let nextTriggered: Driver<UserListViewModel>
        let buttonEnabled: Driver<Bool>
    }

    let email = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")
//    var newUserModel = BehaviorRelay<User?>(value: nil)
    
    override init(provider: Api) {
        super.init(provider: provider)
    }
    
    func transform(input: Input) -> Output {
        let code = PublishSubject<User?>()
        let nextTriggered = input.nextTrigger
        
        nextTriggered.drive(onNext: { [weak self] () in
            let firstname = self?.email.value
            let lastname = self?.password.value
            var newUser = User()
            newUser.email = firstname
            newUser.password = lastname
            newUser.save()
            code.onNext(newUser)
        }).disposed(by: rx.disposeBag)
        
        let nextt = code.asDriver(onErrorJustReturn: (nil)).map { (data) -> UserListViewModel in
            let viewModel = UserListViewModel(provider: self.provider)
            // forced unwrap beacuse I know user must provide both.
            
            AuthManager.setToken(token: data!)
            return viewModel
        }
        
        let buttonEnabled = BehaviorRelay.combineLatest(email, password, self.loading.asObservable()) {
            return $0.isNotEmpty && $1.isNotEmpty && !$2 && validateEmail($0) && $0.count > 4
        }.asDriver(onErrorJustReturn: false)
        
        func validateEmail(_ input: String) -> Bool {
            guard let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: [.caseInsensitive]) else {
                assertionFailure("Regex not valid")
                return false
            }
            
            let regexFirstMatch = regex.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count))
            
            return regexFirstMatch != nil
        }

        return Output(nextTriggered: nextt, buttonEnabled: buttonEnabled)
    }
    
//    func request() -> Observable<[UserListCellViewModel]> {
//        return provider.getUsers(page: page)
//            .trackActivity(loading)
//            .trackError(error)
//            .map { $0.map({ (users) -> UserListCellViewModel in
//                let viewModel = UserListCellViewModel(with: users)
//                return viewModel
//            })}
//    }
}
