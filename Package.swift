// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InlineString",
    platforms: [
        .iOS(.v12),
        .macOS(.v13),
        .tvOS(.v12),
        .watchOS(.v4),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "InlineString",
            targets: ["InlineString"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/ordo-one/package-benchmark",
            .upToNextMajor(from: "1.0.0")
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
            name: "InlineStringBenchmark",
            dependencies: [
                .product(name: "Benchmark", package: "package-benchmark"),
                "InlineString"
            ],
            path: "Benchmarks/InlineStringBenchmark",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark")
            ]
        ),
    ]
)
