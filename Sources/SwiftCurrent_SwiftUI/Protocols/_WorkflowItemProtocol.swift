//
//  _WorkflowItemProtocol.swift
//  SwiftCurrent
//
//  Created by Tyler Thompson on 2/23/22.
//  Copyright © 2022 WWT and Tyler Thompson. All rights reserved.
//  

import SwiftUI
import SwiftCurrent

@available(iOS 14.0, macOS 11, tvOS 14.0, watchOS 7.0, *)
public protocol _WorkflowItemProtocol: View where F: FlowRepresentable & View, Wrapped: View, Content: View {
    associatedtype F
    associatedtype Wrapped
    associatedtype Content
}
