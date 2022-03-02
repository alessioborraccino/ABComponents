//
//  ExampleViewController.swift
//  
//
//  Created by Alessio Borraccino on 28.02.22.
//

import Foundation
import UIKit
import ABComponents

final class ExampleViewController: ComponentsTableViewController, HasComponentTableView {

    private var model: ExampleViewModel

    init(model: ExampleViewModel) {
        self.model = model
        super.init(tableViewInsets: .onlySides)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        updateView()
    }

    var tableBody: [ComponentRowModel] {
        makeRows {
            Spacer.paddingSeparator(id: "topPadding")
                .makeCellModel()
            LabelList("Test".styled(.title.aligned(.center)))
                .makeCellModel()
                .insets(.noBottom)
                .cardStyle(.whiteCornered(.top))
            Spacer.tableSeparator(id: "testAndIcon")
                .makeCellModel()
                .insets(.onlyTop)
                .cardStyle(.whiteCornered(.none))
            Picture(contentMode: .scaleAspectFit,
                    image: UIImage(named: "Notes",
                                   in: Bundle.module,
                                   with: .none))
                .makeCellModel()
                .insets(.everywhere)
                .cardStyle(.whiteCornered(.none))
            LabelList(
                "Very long text so that the label goes on different lines, that is if you feel like reading so much",
                "Another Test as a table headline".styled(.bodyMedium.aligned(.center)))
                .makeCellModel()
                .insets(.noTop)
                .cardStyle(.whiteCornered(.none))
            for entry in model.entries {
                LabelledText(leftImage: UIImage(named: "Notes",
                                                in: Bundle.module,
                                                with: .none),
                             text: entry.styled(.body))
                    .makeCellModel()
                    .insets(.onlySides)
                Spacer(id: "\(entry) entry", length: 5, backgroundColor: .white)
                    .makeCellModel()
            }
            Spacer(id: "bottomTable", length: Layout.verticalPadding, backgroundColor: .white)
                .makeCellModel()
                .cardStyle(.whiteCornered(.bottom))

            Spacer.paddingSeparator(id: "Table button")
                .makeCellModel()
            let firstButtonStyle = model.isPrimary ? ButtonStyle.primary : ButtonStyle.secondary
            Button(style: firstButtonStyle, title: "Test") { [ unowned self] in

                model.onFirstButtonTap()
            }.makeCellModel()
                .insets(.everywhere)
                .cardStyle(.whiteCornered(.all))
            Spacer.paddingSeparator(id: "bottomTable")
                .makeCellModel()
        }
    }
}

#if DEBUG
import SwiftUI
extension ExampleViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ExampleViewController {
        let model = ExampleViewModel()
        let view = ExampleViewController(model: model)
        model.view = view
        return view
    }

    func updateUIViewController(_ uiViewController: ExampleViewController,
                                context: Context) {
    }
}

struct ExampleViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let model = ExampleViewModel()
        let view = ExampleViewController(model: model)
        model.view = view
        return view
    }
}
#endif
