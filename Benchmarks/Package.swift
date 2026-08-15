// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "InlineStringBenchmark",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(path: "../"),
        .package(
            url: "https://github.com/ordo-one/package-benchmark",
            .upToNextMajor(from: "1.0.0")
        ),
    ],
    targets: [
        .executableTarget(
            name: "InlineStringBenchmark",
            dependencies: [
                .product(
                    name: "Benchmark",
                    package: "package-benchmark"
                ),
                .product(
                    name: "InlineString",
                    package: "InlineString"
                ),
            ],
            path: "InlineStringBenchmark",
            plugins: [
                .plugin(
                    name: "BenchmarkPlugin",
                    package: "package-benchmark"
                )
            ]
        )
    ]
)
