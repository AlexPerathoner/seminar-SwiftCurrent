//
//  FlowPersistance.swift
//  
//
//  Created by Tyler Thompson on 11/26/20.
//  Copyright © 2021 WWT and Tyler Thompson. All rights reserved.
//

import Foundation
/**
 FlowPersistance: An extendable class that indicates how FlowRepresentables should be persisted

### Discussion:
Used when you are creating a workflow
*/
public final class FlowPersistance {
    public static var new: FlowPersistance { FlowPersistance() }

    /// default: Indicates a `FlowRepresentable` in a `Workflow` should persist in based on it's `shouldLoad` function
    public static let `default` = FlowPersistance()
    /// default: Indicates a `FlowRepresentable` in a `Workflow` who's `shouldLoad` function returns false should still be persisted so if the workflow is navigated backwards it'll be there
    public static let persistWhenSkipped = FlowPersistance()
    /// default: Indicates a `FlowRepresentable` in a `Workflow` who's `shouldLoad` function returns true should be removed from the viewstack after the workflow progresses past it
    public static let removedAfterProceeding = FlowPersistance()

    private init() { }
}

extension FlowPersistance: Equatable {
    public static func == (lhs: FlowPersistance, rhs: FlowPersistance) -> Bool {
        lhs === rhs
    }
}
