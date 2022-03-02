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

public enum CardStyle: Hashable {
    case none
    case whiteCornered(CardRoundedCornerStyle)
}

public enum CardRoundedCornerStyle: Hashable {
    case top
    case bottom
    case all
    case none
}

public protocol CellModel: RowModel {
    associatedtype ViewModel: Hashable
    var viewModel: ViewModel { get }
    var insets: UIEdgeInsets { get }
    var cardStyle: CardStyle { get }
    init(viewModel: ViewModel, insets: UIEdgeInsets, cardStyle: CardStyle)
}

extension CellModel {
    public var insets: UIEdgeInsets {
        return .zero
    }
    public var cardStyle: CardStyle {
        return .whiteCornered(.none)
    }

    public func insets(_ newInsets: UIEdgeInsets) -> Self {
        Self.init(viewModel: self.viewModel, insets: newInsets, cardStyle: self.cardStyle)
    }
    public func cardStyle(_ newCardStyle: CardStyle) -> Self {
        Self.init(viewModel: self.viewModel, insets: self.insets, cardStyle: newCardStyle)
    }

    public init(viewModel: ViewModel) {
        self.init(viewModel: viewModel, insets: .zero, cardStyle: .none)
    }
}

public protocol ExpressibleAsCellModel {
    associatedtype Model: CellModel where Model.ViewModel == Self
    func makeCellModel(insets: UIEdgeInsets, cardStyle: CardStyle) -> Model
}

extension ExpressibleAsCellModel {
    func makeCellModel() -> Model {
        makeCellModel(insets: .zero, cardStyle: .none)
    }
}

extension ExpressibleAsCellModel where Self: CellModel {
    func makeCellModel(insets: UIEdgeInsets, cardStyle: CardStyle) -> Self {
        return type(of: self).init(viewModel: viewModel, insets: insets, cardStyle: cardStyle)
    }
    func makeCellModel() -> Self {
        return self 
    }
}

extension UIEdgeInsets: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(top)
        hasher.combine(left)
        hasher.combine(bottom)
        hasher.combine(right)
    }
}
