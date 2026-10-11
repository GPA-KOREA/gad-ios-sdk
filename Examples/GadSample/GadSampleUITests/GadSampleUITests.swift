import XCTest

final class GadSampleUITests: XCTestCase {
    @MainActor
    func testKeylessLaunchDoesNotInitializeSDK() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["environment"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["environment"].label, "환경: STAGING (.staging)")
        XCTAssertEqual(app.secureTextFields["mediaKey"].value as? String, "iOS SDK 스테이징 미디어키")
        XCTAssertEqual(app.textFields["userID"].value as? String, "매체 앱의 테스트 사용자 ID (최대 48자)")
        XCTAssertFalse(app.buttons["openOfferwall"].isEnabled)
        XCTAssertEqual(app.staticTexts["status"].label, "아직 초기화하지 않았습니다. 앱 실행만으로 SDK를 호출하지 않습니다.")

        app.buttons["initialize"].tap()

        XCTAssertEqual(app.staticTexts["status"].label, "iOS SDK 스테이징 미디어키를 입력하세요. SDK를 호출하지 않았습니다.")
        XCTAssertFalse(app.buttons["openOfferwall"].isEnabled)
    }
}
