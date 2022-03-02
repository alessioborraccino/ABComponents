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

public struct Button: Hashable {
    public let style: ButtonStyle
    public let title: StyledString
    public var isEnabled: Bool = true
    public var onTap: () -> Void

    public init(style: ButtonStyle, title: StyledString, onTap: @escaping () -> Void, isEnabled: Bool = true) {
        self.style = style
        self.title = title
        self.isEnabled = isEnabled
        self.onTap = onTap
    }

    public static func == (lhs: Button, rhs: Button) -> Bool {
        lhs.style == rhs.style
        && lhs.title == rhs.title
        && lhs.isEnabled == rhs.isEnabled
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(style)
        hasher.combine(title)
        hasher.combine(isEnabled)
    }
}

public struct ButtonCellModel: CellModel {
    public var viewModel: Button
    public var insets: UIEdgeInsets = UIEdgeInsets(top: 25, left: 20, bottom: 25, right: 20)
    public var cardStyle: CardStyle = .whiteCornered(.bottom)

    public init(viewModel: Button, insets: UIEdgeInsets = UIEdgeInsets(top: 25, left: 20, bottom: 25, right: 20), cardStyle: CardStyle = .whiteCornered(.bottom)) {
        self.viewModel = viewModel
        self.insets = insets
        self.cardStyle = cardStyle
    }
}

extension Button: ExpressibleAsCellModel {
    public func makeCellModel(insets: UIEdgeInsets = UIEdgeInsets(top: 25, left: 20, bottom: 25, right: 20), cardStyle: CardStyle = .whiteCornered(.bottom)) -> ButtonCellModel {
        ButtonCellModel.init(viewModel: self, insets: insets, cardStyle: cardStyle)
    }
}

extension ButtonCellModel: ExpressibleAsComponentRowModel {
    public func makeRowModel() -> ComponentRowModel {
        ComponentRowModel.button(self)
    }
}

public final class ButtonView: UIView, ViewModelConfigurable {

    private struct Length {
        static let radius: CGFloat = 19.0
    }

    private var boundsObserver: NSKeyValueObservation?
    private(set) var identifier: String?
    private var onTap: (() -> Void)?

    private lazy var background: UIView = UIView()
    private lazy var titleLabel: UILabel = UILabel()
    private lazy var tapGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public var style: ButtonStyle = .primary {
        didSet {
            display(with: style, state: .normal)
        }
    }

    private var isEnabled: Bool = true {
        didSet {
            tapGestureRecognizer.isEnabled = isEnabled
            display(with: style, state: .normal)
        }
    }

    func configure(with model: Button) {
        style = model.style
        titleLabel.set(model.title)
        isEnabled = model.isEnabled
        self.onTap = model.onTap
    }

    @objc private func didTapButton(_ recognizer: UILongPressGestureRecognizer) {

        let location = recognizer.location(in: background)
        let isTouchingButton = background.point(inside: location, with: nil)
        switch recognizer.state {
        case .began:
            display(with: style, state: .selected)
        case .changed:
            if !isTouchingButton {
                display(with: style, state: .normal)
            } else {
                display(with: style, state: .selected)
            }
        case .ended:
            display(with: style, state: .normal)
            if isTouchingButton {
                onTap?()
            }
        default:
            break
        }
    }
    
    public func setTitle(_ title: String, for: UIControl.State) {
        titleLabel.text = title
    }

    public func addTarget(_ target: Any, action: Selector, for: UIControl.Event) {
        onTap = { 
            _ = (target as AnyObject).perform(action)
        }
    }
}

extension ButtonView {
    private func setup() {

        translatesAutoresizingMaskIntoConstraints = false
        background.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = Length.radius
        background.layer.cornerRadius = Length.radius
        boundsObserver = observe(\.bounds) { [unowned self] (view, _) in
            self.background.layer.cornerRadius = min(view.frame.height / 2, Length.radius)
        }

        tapGestureRecognizer.minimumPressDuration = 0
        tapGestureRecognizer.addTarget(self, action: #selector(didTapButton(_:)))

        background.addGestureRecognizer(tapGestureRecognizer)
        addSubview(background)
        background.constrainEdgesToSuperview()
        background.constrainHeight(greaterThanOrEqualTo: 40)

        background.addSubview(titleLabel)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.constrainEdgesToSuperview(with: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        titleLabel.textAlignment = .center
    }

    private func display(with style: ButtonStyle, state: UIControl.State) {
        switch state {
        case .normal:
            background.layer.borderWidth = style.borderWidth
            background.layer.borderColor = style.normalBorderColor?.cgColor
            background.backgroundColor = style.normalBackgroundColor
            titleLabel.styled(style.normalStyle)
        case .selected:
            background.layer.borderWidth = style.borderWidth
            background.layer.borderColor = style.selectedBorderColor?.cgColor
            background.backgroundColor = style.selectedBackgroundColor
            titleLabel.styled(style.selectedStyle)
        default:
            break
        }
    }
}
