//
//  File.swift
//  
//
//  Created by Alessio Borraccino on 01.03.22.
//

import Foundation
import UIKit

public enum Layout {
    static var horizontalPadding: CGFloat = 20
    static var verticalPadding: CGFloat = 25
}

extension UIEdgeInsets {
    public static var noBottom = UIEdgeInsets(top: Layout.verticalPadding, left: Layout.horizontalPadding, bottom: 0, right: Layout.horizontalPadding)
    public static var onlySides = UIEdgeInsets(top: 0, left: Layout.horizontalPadding, bottom: 0, right: Layout.horizontalPadding)
    public static var noTop = UIEdgeInsets(top: 0, left: Layout.horizontalPadding, bottom: Layout.verticalPadding, right: Layout.horizontalPadding)
    public static var everywhere = UIEdgeInsets(top: Layout.verticalPadding, left: Layout.horizontalPadding, bottom: Layout.verticalPadding, right: Layout.horizontalPadding)
    public static var onlyTop = UIEdgeInsets(top: Layout.verticalPadding, left: 0, bottom: 0, right: 0)
}

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
