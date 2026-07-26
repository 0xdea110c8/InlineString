// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InlineString",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "InlineString",
            targets: ["InlineString"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/google/swift-benchmark.git",
            from: "0.1.0"
        )
    ],
    targets: [
        .target(
            name: "InlineString"
        ),
        .testTarget(
            name: "InlineStringTests",
            dependencies: ["InlineString"]
        ),
        .executableTarget(
            name: "InlineStringBenchmarks",
            dependencies: [
                "InlineString",
                .product(
                    name: "Benchmark",
                    package: "swift-benchmark"
                )
            ]
        ),
    ]
)
