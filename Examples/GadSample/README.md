# GadSample — iOS 0.9.0 staging

UIKit 기반 최소 샘플입니다. **iOS 14.5 이상**을 지원하며 공개 [gad-ios-sdk](https://github.com/GPA-KOREA/gad-ios-sdk)의 **정확한 0.9.0**을 SPM으로 사용합니다. 로컬 SDK 소스나 대체 바이너리를 사용하지 않습니다.

## Xcode에서 실행

1. `GadSample.xcodeproj`를 엽니다. 프로젝트 생성 도구는 필요하지 않습니다.
2. `GadSample` 공유 스킴과 설치된 iOS 시뮬레이터를 선택합니다.
3. 패키지 다운로드가 끝나면 Run을 누릅니다. 계정·미디어키 없이 빌드하고 첫 화면을 실행할 수 있습니다.

샘플을 실행해도 SDK를 자동 호출하지 않습니다. 처음에는 두 입력칸이 비어 있고 광고 목록 버튼이 비활성입니다. 본인의 **iOS · SDK 스테이징 미디어키**와 **매체 앱의 테스트 사용자 ID(1~48자)**를 입력한 뒤 초기화하고 목록 버튼을 누르세요. 환경은 `.staging`으로 고정되어 있습니다. 앱 사용자에게 GAD 계정 로그인은 필요하지 않습니다.

키나 개인 사용자 ID를 소스·프로젝트·공유 스킴에 넣지 마세요. 입력값이 바뀌면 다시 초기화해야 광고 목록을 열 수 있습니다. 초기화 코드의 위치와 호출 순서는 `GadSample/AppDelegate.swift`를 참고하세요.

## 명령행 빌드·테스트

Xcode와 iOS 시뮬레이터 런타임이 설치된 Mac에서, 이 디렉터리를 기준으로 실행합니다. SDK 패키지와 바이너리 다운로드에는 인터넷 연결이 필요합니다.

```bash
xcodebuild -resolvePackageDependencies -project GadSample.xcodeproj -scheme GadSample
xcodebuild -project GadSample.xcodeproj -scheme GadSample \
  -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/GadSampleDerivedData CODE_SIGNING_ALLOWED=NO build
```

키 없는 첫 실행과 빈 키의 초기화 차단을 검증하는 UI 테스트가 있습니다. 본인 Mac에 설치된 시뮬레이터 이름을 `name=`에 사용하세요.

```bash
xcodebuild -project GadSample.xcodeproj -scheme GadSample \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -derivedDataPath /tmp/GadSampleDerivedData CODE_SIGNING_ALLOWED=NO test
```

실기기 실행은 개인 개발 팀과 서명 설정이 필요합니다. 키 없는 시뮬레이터 검증에는 서명 계정이 필요하지 않습니다.

## 시험 범위

수신 서버가 없다면 **목록·상세까지만** 확인하세요. 참여·완료 전에 매체사 HTTPS 수신 서버를 준비하고, 해당 iOS SDK 테스트 매체에 콜백 URL을 등록하여 호스트 상태가 **허용됨**인지 확인해야 합니다. URL 없이 완료한 건은 나중에 등록해도 자동 재발송되지 않습니다.

설치형 테스트 광고는 참여까지만 확인하며 실제 설치·미션 완료 검증은 제공하지 않습니다. CPS 시험은 안내 화면까지이며 실제 구매·구매확정·취소·적립을 처리하지 않습니다. 서버 API 직접 연동 레퍼런스는 준비 중입니다.

최신 절차: [iOS SDK](https://developers-staging.gpakorea.com/developers/guide/sdk/ios) · [포스트백](https://developers-staging.gpakorea.com/developers/guide/postback) · [테스트 방법](https://developers-staging.gpakorea.com/developers/guide/testing)

문의: [jyi4@gpakorea.com](mailto:jyi4@gpakorea.com)
