//
//  ViewControllerWrapper.swift
//  SwiftCurrent_SwiftUI
//
//
//  Created by Tyler Thompson on 8/7/21.
//  Copyright © 2021 WWT and Tyler Thompson. All rights reserved.
//

#if (os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)) && canImport(UIKit)
import SwiftUI
import SwiftCurrent

/// A wrapper for exposing `UIViewController`s that are `FlowRepresentable` to SwiftUI.
@available(iOS 14.0, macOS 11, tvOS 14.0, *)
public struct ViewControllerWrapper<F: FlowRepresentable & UIViewController>: View, UIViewControllerRepresentable, FlowRepresentable {
    public typealias UIViewControllerType = F
    public typealias WorkflowInput = F.WorkflowInput
    public typealias WorkflowOutput = F.WorkflowOutput

    public weak var _workflowPointer: AnyFlowRepresentable? {
        didSet {
            vc._workflowPointer = _workflowPointer
        }
    }

    private var vc: F
    private let args: WorkflowInput?
    public init(with args: F.WorkflowInput) {
        self.args = args
        vc = F._factory(F.self, with: args)
    }

    public init() {
        args = nil
        vc = F._factory(F.self)
    }

    public func makeUIViewController(context: Context) -> F { vc }

    public func updateUIViewController(_ uiViewController: F, context: Context) { }

    public func shouldLoad() -> Bool { vc.shouldLoad() }
}
#endif
