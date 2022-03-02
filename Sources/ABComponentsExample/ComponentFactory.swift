//
//  File.swift
//  
//
//  Created by Alessio Borraccino on 01.03.22.
//

import Foundation
import ABComponents

extension Spacer {
    static func tableSeparator(id: String = UUID().uuidString) -> Spacer {
        Spacer(id: id, length: 1.0, backgroundColor: .systemGray5)
    }
    static func paddingSeparator(id: String = UUID().uuidString) -> Spacer {
        Spacer(id: id, length: Layout.verticalPadding, backgroundColor: .systemGray5)
    }
}
