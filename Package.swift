// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CTCoreData",
    defaultLocalization: "en",
    products: [
        .library(
            name: "CTCoreData",
            targets: ["CTCoreData"]),
    ],
    targets: [
        .target(
            name: "CTCoreData"),
        .testTarget(
            name: "CTCoreDataTests",
            dependencies: ["CTCoreData"]),
    ]
)
