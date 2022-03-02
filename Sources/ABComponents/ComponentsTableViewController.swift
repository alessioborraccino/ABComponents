//
//  ExampleViewController.swift
//
//
//  Created by Alessio Borraccino on 28.02.22.
//

import Foundation
import UIKit

public enum TableViewLayoutMode {
    case constrainedToSuperView
    case unconstrained
}

open class ComponentsTableViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private lazy var tableViewDataSourceManager: ComponentDataSourceManager = {
        return ComponentDataSourceManager(tableView: tableView)
    }()

    var tableViewInsets: UIEdgeInsets = .zero
    var tableViewLayoutMode: TableViewLayoutMode = .constrainedToSuperView

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.tableViewInsets = .zero
        self.tableViewLayoutMode = .constrainedToSuperView
    }

    public init(tableViewInsets: UIEdgeInsets = .zero, layoutMode: TableViewLayoutMode = .constrainedToSuperView) {
        super.init(nibName: nil, bundle: nil)
        self.tableViewInsets = tableViewInsets
        self.tableViewLayoutMode = layoutMode
    }

    public func updateView(with tableBody: [ComponentRowModel]) {
        tableViewDataSourceManager.updateRows(tableBody)
    }
}

extension ComponentsTableViewController {
    private func setupTableView() {
        view.addSubview(tableView)
        if tableViewLayoutMode == .constrainedToSuperView {
            tableView.constrainEdgesToSuperview(with: tableViewInsets)
        }
    }
}

extension HasComponentTableView where Self: ComponentsTableViewController {
    public func updateView() {
        updateView(with: tableBody)
    }
}
