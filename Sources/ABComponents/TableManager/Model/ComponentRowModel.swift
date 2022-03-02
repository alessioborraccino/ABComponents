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

import UIKit 

public enum ComponentRowModel {
    case spacer(SpacerCellModel)
    case labelList(LabelListCellModel)
    case labelledText(LabelledTextCellModel)
    case image(ImageCellModel)
    case button(ButtonCellModel)

    static func make<CM: CellModel & ExpressibleAsComponentRowModel>(_ cellModel: CM) -> ComponentRowModel {
        return cellModel.makeRowModel()
    }
}

extension ComponentRowModel: RowModel {

    public var instanceCellIdentifier: String {
        switch self {
            case .spacer(let model):
                return model.instanceCellIdentifier
            case .button(let model):
                return model.instanceCellIdentifier
            case .labelList(let model):
                return model.instanceCellIdentifier
            case .image(let model):
                return model.instanceCellIdentifier
            case .labelledText(let model):
                return model.instanceCellIdentifier
        }
    }

    public static func == (lhs: ComponentRowModel, rhs: ComponentRowModel) -> Bool {
        switch (lhs, rhs) {
            case (.spacer(let lhsModel), .spacer(let rhsModel)):
                return lhsModel == rhsModel
            case (.labelList(let lhsModel), .labelList(let rhsModel)):
                return lhsModel == rhsModel
            case (.button(let lhsModel), .button(let rhsModel)):
                return lhsModel == rhsModel
            case (.image(let lhsModel), .image(let rhsModel)):
                return lhsModel == rhsModel
            case (.labelledText(let lhsModel), .labelledText(let rhsModel)):
                return lhsModel == rhsModel
            default:
                return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
            case .spacer(let model):
                hasher.combine(model)
            case .labelList(let model):
                hasher.combine(model)
            case .button(let model):
                hasher.combine(model)
            case .image(let model):
                hasher.combine(model)
            case .labelledText(let model):
                hasher.combine(model)
        }
    }
}

public protocol ExpressibleAsComponentRowModel {
    func makeRowModel() -> ComponentRowModel
}

extension ComponentRowModel: ExpressibleAsComponentRowModel {
    public func makeRowModel() -> ComponentRowModel {
        self
    }
}

public extension TableManagerDataSource {

    func makeComponentCell(with componentRowModel: ComponentRowModel, in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch componentRowModel {
            case .spacer(let model):
                return buildCell(identifiedBy: model.instanceCellIdentifier, viewBuilder: SpacerView(), cellModel: model, in: tableView, at: indexPath)
            case .labelList(let model):
                return buildCell(identifiedBy: model.instanceCellIdentifier, viewBuilder: LabelListView(), cellModel: model, in: tableView, at: indexPath)
            case .image(let model):
                return buildCell(identifiedBy: model.instanceCellIdentifier, viewBuilder: UIImageView(), cellModel: model, in: tableView, at: indexPath)
            case .button(let model):
                return buildCell(identifiedBy: model.instanceCellIdentifier, viewBuilder: ButtonView(), cellModel: model, in: tableView, at: indexPath)
            case .labelledText(let model):
                return buildCell(identifiedBy: model.instanceCellIdentifier, viewBuilder: LabelledTextView(), cellModel: model, in: tableView, at: indexPath)
        }
    }

    private func buildCell<View: UIView & ViewModelConfigurable, CM: CellModel>(identifiedBy identifier: String,
                                                                                viewBuilder: @autoclosure () -> View,
                                                                                cellModel: CM,
                                                                                in tableView: UITableView,
                                                                                at indexPath: IndexPath) -> UITableViewCell where View.ViewModel == CM.ViewModel {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        let view = viewBuilder()
        cell.contentView.addSubview(view)
        cell.configure(subView: view, with: cellModel)
        return cell
    }
}
