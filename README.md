# GAD iOS SDK

GPA KOREA **GAD 오퍼월** iOS SDK **0.9.0** 연동 가이드입니다.

- 최소 지원: **iOS 14.5+**
- 배포: XCFramework 바이너리, Swift Package Manager / CocoaPods
- 외부 의존성 없음: Apple 시스템 프레임워크 사용
- [현재 iOS SDK 가이드](https://developers-staging.gpakorea.com/developers/guide/sdk/ios) · [스테이징 시작하기](https://developers-staging.gpakorea.com/developers) · [테스트 방법](https://developers-staging.gpakorea.com/developers/guide/testing)

SDK 설치·빌드와 샘플 앱 실행은 계정이나 미디어키 없이 가능합니다. **SDK 초기화와 광고 목록 조회**에는 스테이징 콘솔에서 발급한 **iOS · SDK 테스트 매체 키**와 매체 앱의 테스트 사용자 ID가 필요합니다. 앱 사용자에게 GAD 계정 로그인은 필요하지 않습니다. 매체사 개발자는 가이드의 시작하기에 따라 계정과 테스트 매체 키를 준비하세요.

## 설치: 0.9.0 고정

### Swift Package Manager (권장)

Xcode → **File ▸ Add Package Dependencies…** 에 아래 URL을 입력하고 **Exact Version: 0.9.0**을 선택합니다. 앱 타깃에 `GadSDK` 제품을 추가하세요.

```text
https://github.com/GPA-KOREA/gad-ios-sdk
```

`Package.swift`로 관리한다면:

```swift
dependencies: [
    .package(url: "https://github.com/GPA-KOREA/gad-ios-sdk", exact: "0.9.0")
]
```

### CocoaPods

CocoaPods trunk에는 등록돼 있지 않습니다. `Podfile`에 0.9.0 태그의 podspec 주소를 직접 지정합니다.

```ruby
pod 'GadSDK', :podspec => 'https://raw.githubusercontent.com/GPA-KOREA/gad-ios-sdk/0.9.0/GadSDK.podspec'
```

```bash
pod install
```

## 실행 가능한 스테이징 샘플

이 저장소의 [Examples/GadSample](Examples/GadSample)에는 Xcode 프로젝트와 공유 스킴이 포함돼 있습니다. XcodeGen 등 별도 프로젝트 생성 도구는 필요하지 않습니다.

1. 저장소를 복제하고 `Examples/GadSample/GadSample.xcodeproj`를 Xcode에서 엽니다.
2. `GadSample` 스킴과 iOS 시뮬레이터를 선택합니다. Xcode가 **공개 SPM 저장소의 정확한 0.9.0**과 바이너리를 받도록 기다립니다.
3. Run을 누릅니다. 키 없이 첫 화면이 열리며, 실행만으로 SDK를 초기화하거나 광고 목록을 요청하지 않습니다.
4. 본인의 **iOS SDK 스테이징 미디어키**와 매체 앱의 테스트 사용자 ID를 입력하고 **스테이징 SDK 초기화**를 누릅니다.
5. **광고 목록 열기**를 누르고 SDK 목록·상세의 `STAGING` 표식을 확인합니다.

샘플의 환경은 `.staging`으로 고정돼 있습니다. 실제 키나 개인 사용자 ID는 프로젝트·소스에 넣지 마세요. 상세한 빌드·테스트 명령은 [샘플 README](Examples/GadSample/README.md)를 참고하세요.

## 빠른 시작

모든 SDK API는 메인 스레드(`@MainActor`)에서 호출합니다. `userId`는 **매체 앱의 고유 사용자 ID, 최대 48자**이며 같은 사용자에게 항상 같은 값을 사용합니다.

초기화는 앱의 사용자 로그인 직후 한 곳에서 합니다. 광고 목록을 열 때마다 다시 초기화하지 않습니다. 아래 인자는 앱의 설정과 로그인 결과로 전달하세요.

```swift
import UIKit
import GadSDK

@MainActor
func setupGad(mediaKey: String, userId: String) {
    Gad.initialize(mediaKey: mediaKey, userId: userId, environment: .staging)
}

@MainActor
func openOfferwall(from presenter: UIViewController) {
    Gad.showAdList(from: presenter)
}
```

UIKit에서는 현재 `UIViewController`를 넘깁니다. SwiftUI에서는 현재 표시 중인 UIKit `UIViewController`를 찾아 넘기는 방법을 [iOS 가이드](https://developers-staging.gpakorea.com/developers/guide/sdk/ios#show)에서 확인하세요.

**환경 인자를 생략한 `Gad.initialize(mediaKey:userId:)`는 운영(`.production`)으로 연결됩니다.** 스테이징으로 초기화한 뒤 환경 없는 초기화를 다시 호출하면 운영으로 바뀝니다. 초기화는 한 곳에서 환경을 명시하세요. 운영 전환 시에는 운영용 iOS SDK 미디어키와 `.production`을 함께 지정하고, 출시 빌드에서 스테이징 설정을 제거하세요.

## 완료·포스트백 시험 준비

수신 서버가 없다면 먼저 **목록·상세 화면까지** 확인하세요. 참여·완료와 포스트백 수신을 시험하려면 다음 순서로 준비합니다.

1. 매체사 개발팀이 HTTPS 포스트백 수신 서버를 준비합니다.
2. 스테이징 콘솔의 해당 **iOS · SDK 테스트 매체**에 콜백 URL을 등록합니다.
3. GPA KOREA에 콜백 호스트 허용을 요청하고, 콘솔에서 **허용됨**을 확인합니다.
4. 그 뒤 테스트 광고에 참여·완료하고 매체사 서버에서 포스트백 수신을 확인합니다.

**콜백 URL 없이 완료한 건은 나중에 URL을 등록해도 자동 재발송되지 않습니다.** 완료한 광고에는 같은 사용자·기기로 다시 참여할 수 없습니다. 포스트백 본문과 중복 지급 방지는 [포스트백 규격](https://developers-staging.gpakorea.com/developers/guide/postback), 시험 절차는 [테스트 방법](https://developers-staging.gpakorea.com/developers/guide/testing)을 따르세요.

스테이징 설치형 광고는 설치할 실제 앱이 없어 참여까지만 확인하며, 미션형 완료 검증은 제공하지 않습니다. CPS 테스트 광고는 안내 화면까지 확인하는 시험용이며 실제 결제·구매확정·취소·적립을 처리하지 않습니다. 스테이징은 예고 없이 중단될 수 있습니다.

[서버 API 직접 연동 레퍼런스는 준비 중](https://developers-staging.gpakorea.com/developers/guide/api)입니다. 이 문서와 샘플은 **네이티브 iOS SDK 연동**을 다룹니다.

## 개인정보·권한

SDK에는 `PrivacyInfo.xcprivacy`가 포함돼 있습니다. IDFA를 수집하지 않아 SDK 때문에 ATT 요청이 필요하지 않습니다. 기기 ID(IDFV 또는 키체인의 UUID), 매체가 넘긴 사용자 ID, 고객센터 문의 회신용 이메일이 SDK의 개인정보 항목에 포함됩니다. App Store Connect 설정은 [현재 iOS 가이드의 개인정보 항목](https://developers-staging.gpakorea.com/developers/guide/sdk/ios#privacy)을 확인하세요.

문의: [jyi4@gpakorea.com](mailto:jyi4@gpakorea.com)
