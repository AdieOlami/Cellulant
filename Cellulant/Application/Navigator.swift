//
//  Navigator.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SafariServices

protocol Navigatable {
    var navigator: Navigator! { get set }
}
//swiftlint:disable all
class Navigator {
    static var `default` = Navigator()

    // MARK: - segues list, all app scenes
    enum Scene {
        case login(viewModel: AuthViewModel)
        case userList(viewModel: UserListViewModel)
    }

    enum Transition {
        case root(in: UIWindow)
//        case navigation(type: HeroDefaultAnimationType)
//        case customModal(type: HeroDefaultAnimationType)
        case modal
        case detail
        case alert
        case custom
        case popup
    }

    // MARK: - get a single VC
    func get(segue: Scene) -> UIViewController? {
        switch segue {
        case .login(let viewModel):
            return AuthVC(viewModel: viewModel, navigator: self)
        case .userList(let viewModel):
            return UserListVC(viewModel: viewModel, navigator: self)
        }
    }

    func pop(sender: UIViewController?, toRoot: Bool = false) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: true)
        } else {
            sender?.navigationController?.popViewController(animated: true)
        }
    }

    func dismiss(sender: UIViewController?) {
        sender?.navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - invoke a single segue
    func show(segue: Scene, sender: UIViewController?, transition: Transition = .modal/*.navigation(type: .zoom)*/) { //cover(direction: .left)
        if let target = get(segue: segue) {
            show(target: target, sender: sender, transition: transition)
        }
    }

    private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        switch transition {
        case .root(in: let window):
            UIView.transition(with: window, duration: 0.5, options: .curveEaseInOut, animations: {
                
                window.rootViewController = UINavigationController(rootViewController: target)
//                target
//                    UINavigationController(rootViewController: target)
                
            }, completion: nil)
            return
        case .custom: return
        default: break
        }

        guard let sender = sender else {
            fatalError("You need to pass in a sender for .navigation or .modal transitions")
        }

        if let nav = sender as? UINavigationController {
            //push root controller on navigation stack
            nav.pushViewController(target, animated: false)
            return
        }

        switch transition {
//        case .navigation(let type):
//            if let nav = sender.navigationController {
//                // push controller to navigation stack
//                nav.hero.navigationAnimationType = .autoReverse(presenting: type)
//                nav.pushViewController(target, animated: true)
//            }
//        case .customModal(let type):
//            // present modally with custom animation
//            DispatchQueue.main.async {
//                let nav = NavigationController(rootViewController: target)
//                nav.hero.modalAnimationType = .autoReverse(presenting: type)
//                sender.present(nav, animated: true, completion: nil)
//            }
        case .modal:
            // present modally
            DispatchQueue.main.async {
                let nav = NavigationController(rootViewController: target)
                sender.present(nav, animated: true, completion: nil)
            }
        case .detail:
            DispatchQueue.main.async {
                let nav = NavigationController(rootViewController: target)
                sender.showDetailViewController(nav, sender: nil)
            }
        case .alert:
            DispatchQueue.main.async {
                sender.present(target, animated: true, completion: nil)
            }
            
        case .popup:
            DispatchQueue.main.async {
                sender.addChild(target)
//                target.delegate = sender
                target.view.frame = sender.view.frame
                sender.view.addSubview(target.view)
                target.didMove(toParent: sender)
            }
        default: break
        }
    }
}
