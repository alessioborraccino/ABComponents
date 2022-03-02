//
//  ButtonStyle.swift
//  
//
//  Created by Alessio Borraccino on 01.03.22.
//

import Foundation
import UIKit

public enum ButtonStyle {
    case primary
    case secondary
    case text

    public var borderWidth: CGFloat {
        switch self {
            case .primary:
                return 0
            case .secondary:
                return 2.0
            case .text:
                return 0
        }
    }

    public var normalBorderColor: UIColor? {
        switch self {
            case .primary:
                return .white
            case .secondary:
                return .black
            case .text:
                return nil
        }
    }

    public var selectedBorderColor: UIColor? {
        switch self {
            case .primary:
                return .darkGray
            case .secondary:
                return .darkGray
            case .text:
                return nil
        }
    }

    public var normalBackgroundColor: UIColor {
        switch self {
            case .primary:
                return .blue
            case .secondary:
                return .white
            case .text:
                return .clear
        }
    }

    public var selectedBackgroundColor: UIColor {
        switch self {
            case .primary:
                return .blue.withAlphaComponent(0.5)
            case .secondary:
                return normalBackgroundColor
            case .text:
                return normalBackgroundColor
        }
    }

    public var normalStyle: FontType {
        switch self {
            case .primary:
                return FontType.bodyMedium.colored(.white).aligned(.center)
            case .secondary:
                return FontType.bodyMedium.colored(.darkText).aligned(.center)
            case .text:
                return FontType.bodyMedium.colored(.darkText).aligned(.center)
        }
    }

    public var selectedStyle: FontType {
        switch self {
            case .primary:
                return normalStyle
            case .secondary:
                return FontType.bodyMedium.colored(.darkText.withAlphaComponent(0.5)).aligned(.center)
            case .text:
                return FontType.bodyMedium.colored(.darkText.withAlphaComponent(0.5)).aligned(.center)
        }
    }
}
