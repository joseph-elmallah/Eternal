// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Eternal",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "Eternal",
            targets: ["Eternal"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Eternal",
            dependencies: []),
        .testTarget(
            name: "EternalTests",
            dependencies: ["Eternal"]),
    ]
)
