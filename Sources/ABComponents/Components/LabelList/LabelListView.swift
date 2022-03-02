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

public struct LabelList: Hashable {
    var spacing: CGFloat = 10
    var insets: UIEdgeInsets = .zero
    let texts: [StyledString]

    public init(spacing: CGFloat = 10, insets: UIEdgeInsets = .zero, texts: [StyledString]) {
        self.spacing = spacing
        self.insets = insets
        self.texts = texts
    }
}

public extension LabelList {
    init(_ strings: StyledString...) {
        self.init(texts: strings)
    }

    init(spacing: CGFloat, _ strings: StyledString...) {
        self.init(spacing: spacing, insets: .zero, texts: strings)
    }
}

extension LabelList: ExpressibleAsCellModel {
    public func makeCellModel(insets: UIEdgeInsets = .zero, cardStyle: CardStyle = .whiteCornered(.none)) -> LabelListCellModel {
        return LabelListCellModel(viewModel: self, insets: insets, cardStyle: cardStyle)
    }
}

public struct LabelListCellModel: CellModel, ExpressibleAsComponentRowModel {
    public var viewModel: LabelList
    public var insets: UIEdgeInsets = .zero
    public var cardStyle: CardStyle = .whiteCornered(.none)

    public init(viewModel: LabelList, insets: UIEdgeInsets = .zero, cardStyle: CardStyle = .whiteCornered(.none)) {
        self.viewModel = viewModel
        self.insets = insets
        self.cardStyle = cardStyle
    }

    public func makeRowModel() -> ComponentRowModel {
        .labelList(self)
    }
}

final class LabelListView: UIView {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()

    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    func setupViews() {
        addSubview(backgroundView)
        backgroundView.addSubview(stackView)
        backgroundView.constrainEdgesToSuperview()
    }
}

extension LabelListView: ViewModelConfigurable {
    func configure(with viewModel: LabelList) {
        stackView.spacing = viewModel.spacing
        stackView.constrainEdgesToSuperview(with: viewModel.insets)
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        for text in viewModel.texts {
            let label = UILabel()
            label.set(text)
            label.setContentCompressionResistancePriority(.required, for: .vertical)
            label.setContentHuggingPriority(.required, for: .vertical)
            stackView.addArrangedSubview(label)
        }
    }
}
