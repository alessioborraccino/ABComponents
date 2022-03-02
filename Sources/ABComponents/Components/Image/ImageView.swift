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

public struct Picture: Hashable {
    public let contentMode: UIView.ContentMode
    public let image: UIImage?

    public init(contentMode: UIView.ContentMode, image: UIImage?) {
        self.contentMode = contentMode
        self.image = image 
    }
}

extension Picture: ExpressibleAsCellModel {
    public func makeCellModel(insets: UIEdgeInsets = .zero, cardStyle: CardStyle = .whiteCornered(.none)) -> ImageCellModel {
        ImageCellModel(viewModel: self, insets: insets, cardStyle: cardStyle)
    }
}

public struct ImageCellModel: CellModel {
    public var viewModel: Picture
    public var insets: UIEdgeInsets = .zero
    public var cardStyle: CardStyle = .whiteCornered(.none)

    public init(viewModel: Picture, insets: UIEdgeInsets = .zero, cardStyle: CardStyle = .whiteCornered(.none)) {
        self.viewModel = viewModel
        self.insets = insets
        self.cardStyle = cardStyle
    }
}

extension ImageCellModel: ExpressibleAsComponentRowModel {
    public func makeRowModel() -> ComponentRowModel {
        .image(self)
    }
}

extension UIImageView: ViewModelConfigurable {
    func configure(with viewModel: Picture) {
        self.contentMode = viewModel.contentMode
        self.image = viewModel.image
    }
}
