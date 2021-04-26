//
//  TestOnly.swift
//  Workflow
//
//  Created by Tyler Thompson on 9/25/19.
//  Copyright © 2019 Tyler Thompson. All rights reserved.
//

import Foundation

#if canImport(XCTest)
extension Notification.Name {
    /// workflowLaunched: A notification only available when tests are being run that lets you know a workflow has been launched.
    public static var workflowLaunched: Notification.Name {
        .init(rawValue: "WorkflowLaunched")
    }
}

extension FlowRepresentable {
    /// proceedInWorkflowStorage: Your tests may want to manually set the closure so they can make assertions it was called, this is simply a convenience available for that.
    public var proceedInWorkflowStorage: ((Any?) -> Void)? {
        get {
            {
                _workflowPointer?.proceedInWorkflowStorage?(.args($0))
            }
        }
        set {
            _workflowPointer?.proceedInWorkflowStorage = { args in
                newValue?(args.extract(nil))
            }
        }
    }

    /// proceedInWorkflow: An alias for proceedInWorkflowStorage.
    public var _proceedInWorkflow: ((Any?) -> Void)? {
        get {
            {
                _workflowPointer?.proceedInWorkflowStorage?(.args($0))
            }
        }
        set {
            _workflowPointer?.proceedInWorkflowStorage = { args in
                newValue?(args.extract(nil))
            }
        }
    }
}
#endif
