//
//  ComponentRowBuilder.swift
//  
//
//  Created by Alessio Borraccino on 28.02.22.
//

import Foundation

@resultBuilder
public struct ComponentRowBuilder {

    public static func buildExpression(_ expression: ExpressibleAsComponentRowModel) -> [ComponentRowModel] {
        [expression.makeRowModel()]
    }
    public static func buildBlock() -> [ComponentRowModel] { [] }
    public static func buildBlock(_ element: Never) -> [ComponentRowModel] {}

    public static func buildBlock(_ rowModel: ExpressibleAsComponentRowModel) -> [ComponentRowModel] {
        [rowModel.makeRowModel()]
    }
    public static func buildBlock(_ rowModels: [ExpressibleAsComponentRowModel]) -> [ComponentRowModel] {
        rowModels.map { $0.makeRowModel() }
    }
    public static func buildBlock(_ rowModels: ExpressibleAsComponentRowModel...) -> [ComponentRowModel] {
        rowModels.map { $0.makeRowModel() }
    }
    public static func buildBlock(_ rowModels: [ExpressibleAsComponentRowModel]...) -> [ComponentRowModel] {
        rowModels.flatMap { $0 } .map { $0.makeRowModel() }
    }

    public static func buildOptional(_ rowModel: ExpressibleAsComponentRowModel?) -> [ComponentRowModel] {
        guard let value = rowModel else {
            return []
        }
        return [value.makeRowModel()]
    }
    public static func buildEither(first: [ExpressibleAsComponentRowModel]) -> [ComponentRowModel] {
        first.map { $0.makeRowModel() }
    }

    public static func buildEither(second: [ExpressibleAsComponentRowModel]) -> [ComponentRowModel] {
        second.map { $0.makeRowModel() }
    }
    public static func buildArray(_ rowModels: [[ExpressibleAsComponentRowModel]]) -> [ComponentRowModel] {
        rowModels.flatMap { $0 }.map { $0.makeRowModel() }
    }
}

public func makeRows(@ComponentRowBuilder builder: () -> [ComponentRowModel]) -> [ComponentRowModel] {
    builder()
}
