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

public struct LabelledText: Hashable {
    public var insets: UIEdgeInsets = .zero
    public let leftImage: UIImage?
    public let text: StyledString
    public let rightImage: UIImage?
    public let onTap: (() -> Void)?

    static public func == (lhs: LabelledText, rhs: LabelledText) -> Bool {
        return lhs.insets == rhs.insets
        && lhs.leftImage == rhs.leftImage
        && lhs.text == rhs.text
        && lhs.rightImage == rhs.rightImage
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(insets)
        hasher.combine(leftImage)
        hasher.combine(text)
        hasher.combine(rightImage)
    }

    public init(insets: UIEdgeInsets = .zero, leftImage: UIImage? = nil, text: StyledString, rightImage: UIImage? = nil, onTap: (() -> Void)? = nil) {
        
        self.insets = insets
        self.leftImage = leftImage
        self.text = text
        self.rightImage = rightImage
        self.onTap = onTap
    }
}

public struct LabelledTextCellModel: CellModel, ExpressibleAsComponentRowModel {
    public var viewModel: LabelledText
    public var insets: UIEdgeInsets = .zero
    public var cardStyle: CardStyle = .none

    public init(viewModel: LabelledText, insets: UIEdgeInsets = .zero, cardStyle: CardStyle = .none) {
        self.viewModel = viewModel
        self.insets = insets
        self.cardStyle = cardStyle
    }

    public func makeRowModel() -> ComponentRowModel {
        .labelledText(self)
    }
}

extension LabelledText: ExpressibleAsCellModel {
    public func makeCellModel(insets: UIEdgeInsets = .zero, cardStyle: CardStyle = .whiteCornered(.none)) -> LabelledTextCellModel {
        return LabelledTextCellModel(viewModel: self, insets: insets, cardStyle: cardStyle)
    }
}

final class LabelledTextView: UIView, ViewModelConfigurable {

    private lazy var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onViewTap))
    private var onTap: (() -> Void)?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
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
}

// MARK: - Setup views
extension LabelledTextView {
    
    /**
     Setup views
     */
    private func setupViews() {
        addGestureRecognizer(tapGesture)
        
        addSubview(stackView)
        stackView.constrainEdgesToSuperview()
        
        stackView.addArrangedSubview(leftImageView)
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(rightImageView)
        
        leftImageView.constrainWidth(to: 44, with: .required)
        leftImageView.constrainHeight(greaterThanOrEqualTo: 44, with: .required)
        rightImageView.constrainWidth(to: 44, with: .required)
        rightImageView.constrainHeight(greaterThanOrEqualTo: 44, with: .required)

    }
}

extension LabelledTextView {
    func configure(with viewModel: LabelledText) {
        if let leftImage = viewModel.leftImage {
            leftImageView.image = leftImage
            leftImageView.isHidden = false
        } else {
            leftImageView.image = nil
            leftImageView.isHidden = true
        }
        
        if let rightImage = viewModel.rightImage {
            rightImageView.image = rightImage
            rightImageView.isHidden = false
        } else {
            rightImageView.image = nil
            rightImageView.isHidden = true
        }

        textLabel.set(viewModel.text)
        textLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        textLabel.setContentHuggingPriority(.required, for: .vertical)
        addBehaviour(viewModel.onTap)
    }

    private func addBehaviour(_ behaviour: (() -> Void)?) {
        onTap = behaviour
        tapGesture.isEnabled = onTap != nil
    }
}

// MARK: - Actions
extension LabelledTextView {
    @objc func onViewTap() {
        onTap?()
    }
}
