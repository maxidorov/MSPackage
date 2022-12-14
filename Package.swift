// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MSPackage",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "MSPackage",
            targets: ["MSPackage"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            from: "0.40.2"),
        .package(
            url: "https://github.com/apphud/ApphudSDK",
            from: "2.8.8")
    ],
    targets: [
        .target(
            name: "MSPackage",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(
                    name: "ApphudSDK",
                    package: "ApphudSDK")
            ],
            path: "Sources/"),
    ]
)
