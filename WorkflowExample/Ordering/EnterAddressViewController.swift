//
//  EnterAddressViewController.swift
//  WorkflowExample
//
//  Created by Tyler Thompson on 9/24/19.
//  Copyright © 2019 Tyler Thompson. All rights reserved.
//

import Foundation
import DynamicWorkflow

class EnterAddressViewController: UIWorkflowItem<Order>, StoryboardLoadable {
    var order:Order?
    @IBAction func saveAddress() {
        order?.orderType = .delivery(Address(line1: "MyAddress", line2: "", city: "", state: "", zip: ""))
        proceedInWorkflow(order)
    }
}

extension EnterAddressViewController: FlowRepresentable {
    func shouldLoad(with order: Order) -> Bool {
        self.order = order
        return true
    }
}
