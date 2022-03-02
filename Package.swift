// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ABComponents",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ABComponents",
            targets: ["ABComponents"]),
        .library(
            name: "ABComponentsExample",
            targets: ["ABComponentsExample"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ABComponents",
            dependencies: [],
            path: "Sources/ABcomponents"),
        .target(
            name: "ABComponentsExample",
            dependencies: ["ABComponents"],
            path: "Sources/ABComponentsExample",
            resources: [.process("Resources")]),
    ]
)
