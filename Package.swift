// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "Tick",
    platforms: [
       .macOS(.v15), .iOS(.v18),
    ],
    products: [
        .library(
            name: "Tick",
            targets: ["Tick"]),
    ],
    targets: [
        .target(
            name: "Tick",
            path: "Sources/Tick"),
        .testTarget(
            name: "TickTests",
            dependencies: ["Tick"],
            path: "Tests/TickTests"
        ),
    ]
)
