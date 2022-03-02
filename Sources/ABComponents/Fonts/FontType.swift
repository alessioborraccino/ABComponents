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

public struct FontType: Hashable {
    public let weight: UIFont.Weight
    public let style: UIFont.TextStyle
    public let isItalic: Bool
    public let size: CGFloat
    public let color: UIColor
    public let alignment: NSTextAlignment
}

// MARK: - Defaults
public extension FontType {
    static var title = FontType(weight: .medium, style: .title1, isItalic: false, size: 28, color: .darkText, alignment: .left)
    static var title2 = FontType(weight: .medium, style: .title2, isItalic: false, size: 22, color: .darkText, alignment: .left)
    static var title3 = FontType(weight: .medium, style: .title3, isItalic: false, size: 20, color: .darkText, alignment: .left)
    static var headline = FontType(weight: .regular, style: .headline, isItalic: false, size: 17, color: .darkText, alignment: .left)
    static var headlineMedium = FontType(weight: .medium, style: .headline, isItalic: false, size: 17, color: .darkText, alignment: .left)
    static var body = FontType(weight: .regular, style: .body, isItalic: false, size: 15, color: .darkText, alignment: .left)
    static var bodyMedium = FontType(weight: .medium, style: .body, isItalic: false, size: 15, color: .darkText, alignment: .left)
    static var caption2 = FontType(weight: .regular, style: .caption2, isItalic: false, size: 13, color: .darkText, alignment: .left)
    static var caption1 = FontType(weight: .regular, style: .caption1, isItalic: false, size: 12, color: .darkText, alignment: .left)
}

/// If each screen has its own variation, we can easily start with the base ones and tweak them with these modifiers.
/// Eg. label.styled(.regular.sized(13).italicized)
public extension FontType {
    func sized(_ newSize: CGFloat) -> FontType {
        return FontType(weight: weight, style: style, isItalic: isItalic, size: newSize, color: color, alignment: alignment)
    }
    func weighted(_ newWeight: UIFont.Weight) -> FontType {
        return FontType(weight: newWeight, style: style, isItalic: isItalic, size: size, color: color, alignment: alignment)
    }
    func italicized(_ newItalicStatus: Bool = true) -> FontType {
        return FontType(weight: weight, style: style, isItalic: newItalicStatus, size: size, color: color, alignment: alignment)
    }
    func colored(_ newColor: UIColor) -> FontType {
        return FontType(weight: weight, style: style, isItalic: isItalic, size: size, color: newColor, alignment: alignment)
    }
    func styled(_ newStyle: UIFont.TextStyle) -> FontType {
        return FontType(weight: weight, style: newStyle, isItalic: isItalic, size: size, color: color, alignment: alignment)
    }
    func aligned(_ newAlignment: NSTextAlignment) -> FontType {
        return FontType(weight: weight, style: style, isItalic: isItalic, size: size, color: color, alignment: newAlignment)
    }
}

extension FontType {
    public func font(with builder: UIFontBuilder = HelveticaFontBuilder(), usingSizeCategory: Bool = true) -> UIFont {
        builder.makeFont(with: self, usingSizeCategory: usingSizeCategory)
    }
}
