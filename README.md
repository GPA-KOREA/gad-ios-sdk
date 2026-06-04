# GadSDK (iOS)

GPA KOREA **GAD 오퍼월** iOS SDK. API 기반 캠페인(CPI / CPA / CPS 등)을 매체 앱에 통합합니다.

- 최소 버전: **iOS 14.5+**
- 외부 의존성 **0** (UIKit / Foundation / SafariServices / StoreKit)
- 배포 형태: **XCFramework 바이너리** (SPM / CocoaPods)

> 이 저장소는 **배포 전용**입니다. 실제 SDK 소스는 비공개입니다.

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
    .package(url: "https://github.com/GPA-KOREA/gad-ios-sdk", from: "0.1.2")
]
```

### CocoaPods

```ruby
pod 'GadSDK', '~> 0.1.2'
```

```bash
pod install --repo-update
```

---

## 빠른 시작

```swift
import GadSDK

// 1. 초기화 (매체 발급 mediaKey + 사용자 식별 userId)
Gad.initialize(mediaKey: "YOUR_MEDIA_KEY", userId: "USER_ID")

// 2. 광고 목록 표시
Gad.showAdList(from: self)

// 타이틀을 지정하려면
Gad.showAdList(from: self, options: GadAdListOptions(title: "리워드 충전소"))
```

### 앱 재실행 시 자동 복구

```swift
// AppDelegate / 초기 화면에서
if !Gad.isValid {
    Gad.tryRestoreFromPrefs()   // 마지막 init 값으로 자동 재초기화
}
```

### 특정 광고로 직접 진입 (딥링크)

```swift
Gad.join(adKey: "AD_KEY", from: self)
```

---

## 광고 참여 흐름

1. 사용자가 광고 목록에서 캠페인 선택 → 상세 화면
2. **참여하기** → 외부 브라우저(CPA/CPS) 또는 앱스토어(CPI) 이동
3. 미션 수행 후 앱 복귀
   - **CPI / Launch**: 상세 화면에서 **적립 요청** 버튼 표시 → 설치 확인 후 서버에 적립 요청
   - **그 외**: 서버가 비동기로 적립 처리 (상세 자동 종료)

---

## 개인정보 / 권한

- `PrivacyInfo.xcprivacy` 가 SDK 번들에 포함되어 있습니다 (IDFV / UserDefaults 사유 명시).
- 별도 권한 요청 없음 (이미지 첨부는 PHPicker 사용 — 권한 불필요).

---

## 라이선스

Copyright © GPA KOREA. Proprietary.
번들 폰트(Pretendard)는 [`PRETENDARD_LICENSE.txt`](PRETENDARD_LICENSE.txt) 참조 (SIL Open Font License 1.1).

문의: gad@gpakorea.com
