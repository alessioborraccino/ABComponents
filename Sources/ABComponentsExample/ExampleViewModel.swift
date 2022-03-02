//
//  File.swift
//  
//
//  Created by Alessio Borraccino on 02.03.22.
//

import Foundation
import ABComponents
import UIKit

final class ExampleViewModel {

    weak var view: ExampleViewController?
    private(set) var isPrimary: Bool = true

    var entries: [String] {
        if isPrimary {
            return ["Berlin", "Bruxelles"]
        } else {
            return ["Berlin", "Rome", "Bruxelles"]
        }
    }

    func onFirstButtonTap() {
        isPrimary.toggle()
        view?.updateView()
    }
}
