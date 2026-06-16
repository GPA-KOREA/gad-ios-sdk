// swift-tools-version: 5.9
import PackageDescription

// GAD Offerwall iOS SDK — 바이너리 배포(XCFramework).
// 실제 소스는 비공개. 이 저장소는 배포 전용입니다.
//
// 버전 업데이트 시 url 의 tag 와 checksum 두 곳을 함께 갱신하세요.
let package = Package(
    name: "GadSDK",
    platforms: [
        .iOS("14.5")
    ],
    products: [
        .library(
            name: "GadSDK",
            targets: ["GadSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "GadSDK",
            url: "https://github.com/GPA-KOREA/gad-ios-sdk/releases/download/0.1.10/GadSDK.xcframework.zip",
            checksum: "af6e3e213b99c4b030a6ced450bfed9c7d25ba92c6eef37cba58dc4143cd3cce"
        )
    ]
)
