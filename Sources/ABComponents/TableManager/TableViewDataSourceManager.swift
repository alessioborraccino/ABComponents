//  = BSD 3-Clause License
//  
//  Copyright (c) 2020, D4L Data4Life gGmbH
//  All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  
//  * Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  
//  * Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//  
//  * Neither the name of the copyright holder nor the names of its
//  contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Foundation
import UIKit
import SwiftUI
enum MonoSection: Hashable {
    case oneSection
}

open class TableManagerDataSource<R: RowModel>: NSObject, UITableViewDataSource {
    public var rows: [R] = []

    public func dequeueCell<Cell: UITableViewCell>(of type: Cell.Type = Cell.self, for model: R, in tableView: UITableView, at indexPath: IndexPath) -> Cell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: model.instanceCellIdentifier, for: indexPath) as? Cell else {
            fatalError("Should always return a cell")
        }
        return cell
    }

    open func makeCell(in tableView: UITableView, with model: R, at indexPath: IndexPath) -> UITableViewCell {
        fatalError("override this to make model")
    }

    // MARK: - UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        return makeCell(in: tableView, with: row, at: indexPath)
    }

    func makeDiffable(for tableView: UITableView) -> UITableViewDiffableDataSource<MonoSection, R> {
        let dataSource = UITableViewDiffableDataSource<MonoSection, R>(tableView: tableView) { (tableView, indexPath, rowModel) -> UITableViewCell in
            return self.makeCell(in: tableView, with: rowModel, at: indexPath)
        }
        dataSource.defaultRowAnimation = .fade
        return dataSource
    }
}

public class TableViewDataSourceManager<R: RowModel>: NSObject {

    private let tableView: UITableView
    private let dataSource: TableManagerDataSource<R>
    private var diffableDataSource: UITableViewDataSource?

    public init(tableView: UITableView, dataSource: TableManagerDataSource<R>) {
        self.tableView = tableView
        self.dataSource = dataSource
        super.init()
        self.diffableDataSource = dataSource.makeDiffable(for: tableView)
    }

    public func updateRows(_ rows: [R], animated: Bool = true) {
        register(rows)
        dataSource.rows = rows
        guard let diffableDataSource = diffableDataSource as? UITableViewDiffableDataSource<MonoSection, R> else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<MonoSection, R>()
        snapshot.appendSections([MonoSection.oneSection])
        snapshot.appendItems(rows, toSection: .oneSection)
        let isTableEmpty = diffableDataSource.snapshot().itemIdentifiers.isEmpty
        diffableDataSource.apply(snapshot, animatingDifferences: isTableEmpty ? false : animated)
        tableView.layoutIfNeeded()
    }

    private func register(_ rows: [R]) {
        for rowModel in rows {
            tableView.register(rowModel.cellClass, forCellReuseIdentifier: rowModel.instanceCellIdentifier)
        }
    }

    func row(at indexPath: IndexPath) -> R {
        dataSource.rows[indexPath.row]
    }
}

final class ComponentDataSource: TableManagerDataSource<ComponentRowModel> {
    override func makeCell(in tableView: UITableView, with model: ComponentRowModel, at indexPath: IndexPath) -> UITableViewCell {
        return makeComponentCell(with: model, in: tableView, at: indexPath)
    }
}

public final class ComponentDataSourceManager: TableViewDataSourceManager<ComponentRowModel> {
    public init(tableView: UITableView) {
        super.init(tableView: tableView, dataSource: ComponentDataSource())
    }
}

public protocol HasComponentTableView {
    var tableBody: [ComponentRowModel] { get }
}
