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
            url: "https://github.com/adaptyteam/AdaptySDK-iOS.git",
            from: "2.3.4")
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
                    name: "Adapty",
                    package: "AdaptySDK-iOS")
            ],
            path: "Sources/"),
    ]
)
