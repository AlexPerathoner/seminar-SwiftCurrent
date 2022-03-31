//  swiftlint:disable:this file_name
//  DecoderExtensions.swift
//  SwiftCurrent
//
//  Created by Tyler Thompson on 1/14/22.
//  Copyright © 2022 WWT and Tyler Thompson. All rights reserved.
//

import Foundation

extension AnyWorkflow {
    struct WorkflowKVSchema: Decodable {
        let schemaVersion: AnyWorkflow.JSONSchemaVersion
        let sequence: [Sequence]
    }
}

extension JSONDecoder {
    /// Convenience method to decode an ``AnyWorkflow`` from Data.
    public func decodeWorkflow(withAggregator aggregator: FlowRepresentableAggregator, from data: Data) throws -> AnyWorkflow {
        try AnyWorkflow(spec: decode(AnyWorkflow.WorkflowKVSchema.self, from: data), aggregator: aggregator)
    }
}

extension AnyWorkflow.WorkflowKVSchema {
    fileprivate struct PlatformDecodable<T>: Decodable {
        var value: String

        static var platformKey: String {
#if os(iOS)
            return "iOS"
#elseif os(macOS) && targetEnvironment(macCatalyst)
            return "macCatalyst"
#elseif os(macOS)
            return "macOS"
#elseif os(watchOS)
            return "watchOS"
#elseif os(tvOS)
            return "tvOS"
#else
            return "*"
#endif
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let map = try? container.decode([String: String].self) {
                if let mappedValue = map[Self.platformKey] ?? map["*"] {
                    value = mappedValue
                } else {
                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "No \(String(describing: T.self)) found for platform", underlyingError: nil))
                }
            } else {
                value = try container.decode(String.self)
            }
        }
    }

    struct Sequence: Decodable {
        let flowRepresentableName: String
        let launchStyle: String?
        let flowPersistence: String?

        enum CodingKeys: String, CodingKey {
            case flowRepresentableName
            case launchStyle
            case flowPersistence
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            do {
                flowRepresentableName = try container.decode(PlatformDecodable<Never>.self, forKey: .flowRepresentableName).value
            } catch {
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "No FlowRepresentable name found for platform", underlyingError: nil))
            }

            launchStyle = try container.decodeIfPresent(PlatformDecodable<LaunchStyle>.self, forKey: .launchStyle)?.value
            flowPersistence = try container.decodeIfPresent(PlatformDecodable<FlowPersistence>.self, forKey: .flowPersistence)?.value
        }
    }
}

extension AnyWorkflow {
    convenience init(spec: AnyWorkflow.WorkflowKVSchema, aggregator: FlowRepresentableAggregator) throws {
        let typeMap = aggregator.typeMap
        self.init(Workflow<Never>())
        try spec.sequence.forEach {
            if let type = typeMap[$0.flowRepresentableName] {
                let launchStyle = try getLaunchStyle(decodable: type, from: $0)
                let flowPersistence = try getFlowPersistence(decodable: type, from: $0)
                append(type.metadataFactory(launchStyle: launchStyle) { _ in flowPersistence })
            } else {
                throw AnyWorkflow.DecodingError.invalidFlowRepresentable($0.flowRepresentableName)
            }
        }
    }

    private func getLaunchStyle(decodable: WorkflowDecodable.Type, from sequence: AnyWorkflow.WorkflowKVSchema.Sequence) throws -> LaunchStyle {
        guard let launchStyleName = sequence.launchStyle else { return .default }
        return try decodable.decodeLaunchStyle(named: launchStyleName)
    }

    private func getFlowPersistence(decodable: WorkflowDecodable.Type, from sequence: AnyWorkflow.WorkflowKVSchema.Sequence) throws -> FlowPersistence {
        guard let flowPersistenceName = sequence.flowPersistence else { return .default }
        return try decodable.decodeFlowPersistence(named: flowPersistenceName)
    }
}
