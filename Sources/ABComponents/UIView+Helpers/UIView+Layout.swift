//
//  File.swift
//  
//
//  Created by Alessio Borraccino on 28.02.22.
//

import UIKit

extension UIView {

    func constrainHeight(to height: CGFloat, with priority: UILayoutPriority = .defaultHigh) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalToConstant: height)
        constraint.priority = priority
        constraint.isActive = true
    }

    func constrainHeight(greaterThanOrEqualTo height: CGFloat, with priority: UILayoutPriority = .defaultHigh) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: height)
        constraint.priority = priority
        constraint.isActive = true
    }

    func constrainWidth(to width: CGFloat, with priority: UILayoutPriority = .defaultHigh) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalToConstant: width)
        constraint.priority = priority
        constraint.isActive = true
    }

    func constrainEdges(to view: UIView, with insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right).isActive = true
    }

    func constrainEdgesToSuperview(with insets: UIEdgeInsets = .zero) {
        guard let superView = superview else { return }
        constrainEdges(to: superView, with: insets)
    }
}
