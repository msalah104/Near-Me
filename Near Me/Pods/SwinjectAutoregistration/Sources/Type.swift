//
//  Type.swift
//  SwinjectAutoregistration
//
//  Created by Tomas Kohout on 21/01/2017.
//  Copyright © 2017 Swinject Contributors. All rights reserved.
//

import Foundation

class TypeIdentifier: CustomStringConvertible {
    var name: String
    var genericTypes: [Type]
    var subTypeIdentifier: TypeIdentifier?

    init(name: String, genericTypes: [Type] = [], subTypeIdentifier: TypeIdentifier? = nil) {
        self.name = name
        self.genericTypes = genericTypes
        self.subTypeIdentifier = subTypeIdentifier
    }

    var description: String {
        let generics = genericTypes.count > 0 ? "<\(genericTypes.map { "\($0)" }.joined(separator: ", "))>" : ""
        let subType = subTypeIdentifier.flatMap { ".\($0)" } ?? ""
        return "\(name)" + generics + subType
    }
}

extension TypeIdentifier: Equatable {
    static func == (lhs: TypeIdentifier, rhs: TypeIdentifier) -> Bool {
        return lhs.name == rhs.name && lhs.genericTypes == rhs.genericTypes && lhs.subTypeIdentifier == rhs.subTypeIdentifier
    }
}

indirect enum Type: CustomStringConvertible {
    case closure(parameters: [Type], returnType: Type, throws: Bool)
    case identifier(TypeIdentifier)
    case tuple([Type])
    case protocolComposition([TypeIdentifier])

    var description: String {
        switch self {
        case let .closure(parameters, returnType, `throws`):
            return "(\(parameters.map { "\($0)" }.joined(separator: ", "))) \(`throws` ? "throws " : "")-> \(returnType)"
        case let .identifier(identifier):
            return "\(identifier)"
        case let .tuple(types):
            return "(\(types.map { "\($0)" }.joined(separator: ", ")))"
        case let .protocolComposition(types):
            return types.map { "\($0)" }.joined(separator: " & ")
        }
    }
}

extension Type: Equatable {
    static func == (lhs: Type, rhs: Type) -> Bool {
        switch (lhs, rhs) {
        case let (.closure(lparams, lreturn, lthrows), .closure(rparams, rreturn, rthrows)):
            return lparams == rparams && lreturn == rreturn && lthrows == rthrows
        case let (.identifier(lidentifier), .identifier(ridentifier)):
            return lidentifier == ridentifier
        case let (.tuple(ltuple), .tuple(rtuple)):
            return ltuple == rtuple
        case let (.protocolComposition(lprotocols), .protocolComposition(rprotocols)):
            return lprotocols == rprotocols
        default:
            return false
        }
    }
}
