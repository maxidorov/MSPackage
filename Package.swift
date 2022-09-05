// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MSPackage",
    products: [
        .library(
            name: "MSPackage",
            targets: ["MSPackage"]
        ),
    ],
    dependencies: [
        .package(
            name: "swift-composable-architecture",
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "0.39.1"
        )
    ],
    targets: [
        .target(
            name: "MSPackage",
            dependencies: ["swift-composable-architecture"],
            path: "Sources/"
        ),
    ]
)
