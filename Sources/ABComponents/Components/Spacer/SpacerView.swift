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
import CoreGraphics

public struct Spacer: Hashable {
    public let identifier: String
    public let length: CGFloat
    public var backgroundColor: UIColor

    public init(id identifier: String = UUID().uuidString, length: CGFloat, backgroundColor: UIColor = .clear) {
        self.identifier = identifier
        self.length = length
        self.backgroundColor = backgroundColor
    }
}

extension Spacer: ExpressibleByFloatLiteral, ExpressibleAsCellModel {
    public init(floatLiteral value: FloatLiteralType) {
        self.identifier = UUID().uuidString
        self.length = CGFloat(value)
        self.backgroundColor = .clear 
    }

    public func makeCellModel(insets: UIEdgeInsets = .zero, cardStyle: CardStyle = .none) -> SpacerCellModel {
        SpacerCellModel(length: length, backgroundColor: backgroundColor)
    }
}

public struct SpacerCellModel: CellModel {
    public var viewModel: Spacer
    public var insets: UIEdgeInsets = .zero
    public var cardStyle: CardStyle = .none

    public init(viewModel: Spacer, insets: UIEdgeInsets = .zero, cardStyle: CardStyle = .none) {
        self.viewModel = viewModel
        self.insets = insets
        self.cardStyle = cardStyle
    }
}

extension SpacerCellModel: ExpressibleAsComponentRowModel {
    public func makeRowModel() -> ComponentRowModel {
        .spacer(self)
    }
}

extension SpacerCellModel: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.viewModel = Spacer(floatLiteral: value)
    }
    
    init(length value: CGFloat, backgroundColor: UIColor = .clear) {
        self.viewModel = Spacer(length: value, backgroundColor: backgroundColor)
    }
}

final class SpacerView: UIView, ViewModelConfigurable {
    private let heightView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }

    func configure(with model: Spacer) {
        heightView.constrainEdgesToSuperview()
        heightView.constrainHeight(to: model.length, with: .defaultHigh)
        heightView.backgroundColor = model.backgroundColor
    }

    private func addSubviews() {
        addSubview(heightView)
        heightView.constrainEdgesToSuperview()
        heightView.constrainHeight(to: 0, with: .defaultLow)
    }
}
