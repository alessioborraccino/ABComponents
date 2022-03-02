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

public protocol UIFontBuilder {
    func makeFont(with type: FontType, usingSizeCategory: Bool) -> UIFont
}

public struct HelveticaFontBuilder: UIFontBuilder {

    public init() {}
    
    public func makeFont(with type: FontType, usingSizeCategory: Bool = true) -> UIFont {
        let helveticaFont: UIFont?
        switch (type.weight, type.isItalic) {
            case (.black, false):
                helveticaFont = UIFont(name: "HelveticaNeue-Black", size: type.size)
            case (.bold, false):
                helveticaFont = UIFont(name: "HelveticaNeue-Bold", size: type.size)
            case (.light, false):
                helveticaFont = UIFont(name: "HelveticaNeue-Light", size: type.size)
            case (.medium, false):
                helveticaFont = UIFont(name: "HelveticaNeue-Medium", size: type.size)
            case (.regular, false):
                helveticaFont = UIFont(name: "HelveticaNeue", size: type.size)
            case (.thin, false):
                helveticaFont = UIFont(name: "HelveticaNeue-Thin", size: type.size)
            case (.ultraLight, false):
                helveticaFont = UIFont(name: "HelveticaNeue-UltraLight", size: type.size)
            case (.black, true):
                helveticaFont = UIFont(name: "HelveticaNeue-BlackItalic", size: type.size)
            case (.bold, true):
                helveticaFont = UIFont(name: "HelveticaNeue-BoldItalic", size: type.size)
            case (.light, true):
                helveticaFont = UIFont(name: "HelveticaNeue-LightItalic", size: type.size)
            case (.medium, true):
                helveticaFont = UIFont(name: "HelveticaNeue-MediumItalic", size: type.size)
            case (.regular, true):
                helveticaFont = UIFont(name: "HelveticaNeue-Italic", size: type.size)
            case (.thin, true):
                helveticaFont = UIFont(name: "HelveticaNeue-ThinItalic", size: type.size)
            case (.ultraLight, true):
                helveticaFont = UIFont(name: "HelveticaNeue-UltraLightItalic", size: type.size)
            default:
                fatalError("Font is not available")
        }

        guard let font = helveticaFont else {
            fatalError("Font is not available")
        }

        if usingSizeCategory {
            return UIFontMetrics(forTextStyle: type.style).scaledFont(for: font)
        } else {
            return font
        }
    }
}
