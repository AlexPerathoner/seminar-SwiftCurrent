//
//  MockOrchestrationResponder.swift
//  
//
//  Created by Tyler Thompson on 11/25/20.
//

import Foundation
import Workflow

class MockOrchestrationResponder: OrchestrationResponder {
    var launchCalled = 0
    var lastTo: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetadata)?
    func launch(to: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetadata)) {
        lastTo = to
        launchCalled += 1
    }

    var proceedCalled = 0
    var lastFrom: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetadata)?
    var lastCompletion:(() -> Void)?
    func proceed(to: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetadata),
                 from: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetadata)) {
        lastTo = to
        lastFrom = from
        proceedCalled += 1
    }

    var backUpCalled = 0
    func backUp(from: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetadata), to: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetadata)) {
        lastFrom = from
        lastTo = to
        backUpCalled += 1
    }

    var abandonCalled = 0
    var lastWorkflow: AnyWorkflow?
    var lastOnFinish:(() -> Void)?
    func abandon(_ workflow: AnyWorkflow, animated: Bool, onFinish: (() -> Void)?) {
        lastWorkflow = workflow
        lastOnFinish = onFinish
        abandonCalled += 1
    }
}
