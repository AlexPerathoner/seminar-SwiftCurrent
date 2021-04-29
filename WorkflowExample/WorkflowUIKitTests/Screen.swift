//
//  Screen.swift
//  WorkflowTests
//
//  Created by Tyler Thompson on 8/30/19.
//  Copyright © 2021 WWT and Tyler Thompson. All rights reserved.
//

import Foundation
import UIKit

class Screen<T: UIViewController> {
    var view: UIView? {
        return viewController?.view
    }

    var viewController: T?

    func launch(usingCurrentViewStack: Bool = false) {

    }

    func waitForVisibility(timeout: Double = 3) {
        waitUntil(timeout, UIApplication.topViewController() is T)
        if let view = UIApplication.topViewController() as? T {
            viewController = view
        }
    }
}
