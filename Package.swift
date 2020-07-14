// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "screenrecorder",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .executable(
            name: "screenrecorder",
            targets: ["screenrecorder"]),
    ],
    dependencies: [
        .package(url:"https://github.com/apple/swift-argument-parser", .exact("0.2.0")),
    ],
    targets: [
        .target(
            name: "screenrecorder",
            dependencies: [
                 .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "ScreenRecorder/"
        )
    ]
)
