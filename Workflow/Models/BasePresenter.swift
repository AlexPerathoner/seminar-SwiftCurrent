//
//  BasePresenter.swift
//  Workflow
//
//  Created by Tyler Thompson on 8/29/19.
//  Copyright © 2019 Tyler Tompson. All rights reserved.
//

import Foundation
open class BasePresenter<T> {
    public typealias ViewType = T
    
    required public init() { }
}
