//
//  Comparable.swift
//  iOSCSS
//
//  Created by Tyler Thompson on 11/11/18.
//  Copyright © 2018 Tyler Thompson. All rights reserved.
//

import Foundation
extension LinkedList where Value: Comparable {
    public func sort() {
        guard first?.next != nil else { return }
        first = LinkedList(mergeSort(first, by: { $0 <= $1 })).first
    }

    public func sorted() -> LinkedList<Value> {
        return LinkedList(mergeSort(first, by: { $0 <= $1 }))
    }

    /// max: Returns the maximum value in the comparable LinkedList
    /// - Returns: The maximum concrete value in the LinkedList or nil if there is none
    public func max() -> Value? {
        guard var max = first?.value else { return nil }
        forEach { max = Swift.max(max, $0.value) }
        return max
    }

    /// min: Returns the minimum value in the comparable LinkedList
    /// - Returns: The minimum concrete value in the LinkedList or nil if there is none
    public func min() -> Value? {
        guard var min = first?.value else { return nil }
        forEach { min = Swift.min(min, $0.value) }
        return min
    }
}
