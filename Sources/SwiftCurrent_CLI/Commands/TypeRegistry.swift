//
//  TypeRegistry.swift
//  SwiftCurrent
//
//  Created by Tyler Thompson on 3/29/22.
//  Copyright © 2022 WWT and Tyler Thompson. All rights reserved.
//  

import Foundation
import ArgumentParser
import SwiftSyntax

struct TypeRegistry: ParsableCommand {
    fileprivate static let conformance: StaticString = "WorkflowDecodable"

    @Argument(help: "The path to a directory containing swift source files with types conforming to \(Self.conformance)")
    var pathOrSourceCode: Either<URL, String>

    @Option(help: "The path to write the generated code to")
    var output: String?

    mutating func run() throws {
        let irGenerator = IRGenerator()
        let files = try irGenerator.getFiles(from: pathOrSourceCode)

        let conformingTypes = irGenerator.findTypesConforming(to: "\(Self.conformance)", in: files).filter(\.isConcreteType)
        let types = conformingTypes.map { "\($0.name).self" }

        let code =
            """
            import SwiftCurrent

            public struct SwiftCurrentTypeRegistry: FlowRepresentableAggregator {
                public var types: [WorkflowDecodable.self] = [\(types.joined(separator: ","))]
            }

            extension JSONDecoder {
                /// Convenience method to decode an ``AnyWorkflow`` from Data.
                public func decodeWorkflow(from data: Data) throws -> AnyWorkflow {
                    try decodeWorkflow(withAggregator: SwiftCurrentTypeRegistry(), from: data)
                }
            }
            """

        if let output = output {
            try code.write(toFile: output, atomically: true, encoding: .utf8)
        } else {
            print(code)
        }
    }
}
