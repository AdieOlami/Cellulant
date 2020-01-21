//
//  NavigationController.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return globalStatusBarStyle.value
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        interactivePopGestureRecognizer?.delegate = nil // Enable default iOS back swipe gesture

    }
}
