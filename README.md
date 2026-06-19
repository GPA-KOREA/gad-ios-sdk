# GAD iOS SDK

GPA KOREA **GAD 오퍼월** iOS SDK 연동 가이드

- GAD 오퍼월 사이트에 앱 등록은 [GAD 미디어 설정하기](https://github.com/GPA-KOREA/gad-sample-android/blob/master/guide_media.md#gad-%EB%AF%B8%EB%94%94%EC%96%B4-%EC%84%A4%EC%A0%95%ED%95%98%EA%B8%B0) 페이지를 참고 바랍니다.
- API 문서는 [GAD API DOCUMENT](https://github.com/GPA-KOREA/gad-sample-android/blob/main/api-doc.md#gad-api-document), [CPA 연동](https://github.com/GPA-KOREA/gad-sample-android/blob/master/guide_cpa.md#gad-cpa-%EC%97%B0%EB%8F%99-%EA%B0%80%EC%9D%B4%EB%93%9C) 페이지를 참고 바랍니다.

- 최소 버전: **iOS 14.5+**
- 외부 의존성 **0** — Apple 시스템 프레임워크만 사용 (UIKit / Foundation / SafariServices / StoreKit / PhotosUI / CoreText / Security)
- 배포 형태: **XCFramework 바이너리** (SPM / CocoaPods)

---

## 설치

### Swift Package Manager (권장)

Xcode → **File ▸ Add Package Dependencies…** 에 아래 URL 입력:

```
https://github.com/GPA-KOREA/gad-ios-sdk
```

또는 `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/GPA-KOREA/gad-ios-sdk", from: "0.1.10")
]
```

### CocoaPods

```ruby
pod 'GadSDK', '~> 0.1.10'
```

```bash
pod install --repo-update
```

---

## 빠른 시작

- `mediaKey`: GAD 오퍼월에서 발급받은 매체 키
- `userId`: 매체의 고유 사용자 식별자 (**최대 48자**). 동일 사용자는 항상 동일한 값을 사용해야 적립이 정확히 추적됩니다.
- 모든 API 는 메인 스레드에서 호출하세요.

### UIKit

```swift
import GadSDK

// 1. 초기화
Gad.initialize(mediaKey: "YOUR_MEDIA_KEY", userId: "USER_ID")

// 2. 광고 목록 표시 (self: 현재 UIViewController)
Gad.showAdList(from: self)
```

### SwiftUI

SDK 화면은 UIKit 기반이라 현재 화면의 `UIViewController` 가 필요합니다.
버튼에서 `openOfferwall()` 을 호출하세요. (`openOfferwall()` 과 `extension` 은 View `struct` **바깥**, 파일 최상위에 둡니다.)

```swift
import SwiftUI
import UIKit
import GadSDK

struct ContentView: View {
    var body: some View {
        Button("오퍼월 열기") {
            openOfferwall()
        }
    }
}

@MainActor
func openOfferwall() {
    guard let presenter = UIApplication.shared.connectedScenes
        .compactMap({ $0 as? UIWindowScene })
        .first(where: { $0.activationState == .foregroundActive })?
        .windows.first(where: \.isKeyWindow)?
        .rootViewController?.topMost else { return }

    Gad.initialize(mediaKey: "YOUR_MEDIA_KEY", userId: "USER_ID")
    Gad.showAdList(from: presenter)
}

private extension UIViewController {
    var topMost: UIViewController {
        var vc = self
        while let presented = vc.presentedViewController { vc = presented }
        return vc
    }
}
```

---

## 광고 참여 흐름

1. 사용자가 광고 목록에서 캠페인 선택 → 상세 화면
2. **참여하기** → 랜딩페이지 이동
3. 미션 수행 후 앱 복귀
   - **CPI**: 상세 화면에서 **적립 요청** 버튼 표시 → 설치 확인 후 서버에 적립 요청
   - **그 외**: 즉시 또는 검수 후 적립 처리
  
- 광고 참여를 완료하면 [미디어에 등록된 URL로 포스트백](https://github.com/GPA-KOREA/gad-sample-android/blob/master/guide_media.md#%EB%AF%B8%EB%94%94%EC%96%B4-%EC%97%B0%EB%8F%99-%EC%A0%95%EB%B3%B4-%EC%9E%85%EB%A0%A5%ED%95%98%EA%B8%B0)을 전송합니다.
- 링크 : [포스트백 API DOCUMENT](https://github.com/GPA-KOREA/gad-sample-android/blob/master/api-doc.md#%ED%8F%AC%EC%8A%A4%ED%8A%B8%EB%B0%B1)

---

## 개인정보 / 권한

- `PrivacyInfo.xcprivacy` 가 SDK 번들에 포함되어 있습니다 (IDFV / UserDefaults 사유 명시).
- 별도 권한 요청 없음 (이미지 첨부는 PHPicker 사용 — 권한 불필요).

---

문의: jayce@gpakorea.com
