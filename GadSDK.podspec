Pod::Spec.new do |s|
  s.name             = 'GadSDK'
  s.version          = '0.1.11'
  s.summary          = 'GAD Offerwall iOS SDK'
  s.description      = <<-DESC
    GPA KOREA 의 GAD 오퍼월을 iOS 앱에 통합하기 위한 SDK.
    API 기반 캠페인 (CPI / CPA / CPS 등) 지원. XCFramework 바이너리 배포.
  DESC
  s.homepage         = 'https://github.com/GPA-KOREA/gad-ios-sdk'
  s.license          = { :type => 'Proprietary', :text => 'Copyright (c) GPA KOREA' }
  s.author           = { 'GPA KOREA' => 'gad@gpakorea.com' }

  s.ios.deployment_target = '14.5'
  s.swift_version    = '5.9'

  # GitHub Release 에 업로드된 xcframework zip 을 받아 vendored framework 로 사용.
  # 폰트 / PrivacyInfo 리소스는 xcframework 내부 번들에 포함되어 있음.
  s.source = {
    :http => 'https://github.com/GPA-KOREA/gad-ios-sdk/releases/download/0.1.11/GadSDK.xcframework.zip'
  }
  s.vendored_frameworks = 'GadSDK.xcframework'

  s.frameworks = 'UIKit', 'Foundation', 'SafariServices', 'StoreKit', 'PhotosUI', 'CoreText', 'Security'
end
