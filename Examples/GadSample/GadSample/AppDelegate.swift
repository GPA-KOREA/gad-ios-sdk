import UIKit
import GadSDK

@main
@MainActor
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = SampleViewController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

@MainActor
final class SampleViewController: UIViewController {
    private let mediaKeyField = UITextField()
    private let userIDField = UITextField()
    private let initializeButton = UIButton(type: .system)
    private let openButton = UIButton(type: .system)
    private let statusLabel = UILabel()
    private var isInitialized = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let title = label("GAD iOS 0.9.0", style: .title1)
        let environment = label("환경: STAGING (.staging)", style: .headline)
        environment.accessibilityIdentifier = "environment"
        let explanation = label(
            "키 없이 빌드·실행할 수 있습니다. 스테이징 콘솔의 iOS · SDK 미디어키와 매체 앱의 테스트 사용자 ID를 입력한 뒤 초기화하세요. 앱 사용자에게 GAD 로그인은 필요하지 않습니다.",
            style: .body
        )

        configure(mediaKeyField, placeholder: "iOS SDK 스테이징 미디어키", identifier: "mediaKey")
        mediaKeyField.isSecureTextEntry = true
        configure(userIDField, placeholder: "매체 앱의 테스트 사용자 ID (최대 48자)", identifier: "userID")

        initializeButton.setTitle("1. 스테이징 SDK 초기화", for: .normal)
        initializeButton.accessibilityIdentifier = "initialize"
        initializeButton.addTarget(self, action: #selector(initializeSDK), for: .touchUpInside)

        openButton.setTitle("2. 광고 목록 열기", for: .normal)
        openButton.accessibilityIdentifier = "openOfferwall"
        openButton.isEnabled = false
        openButton.addTarget(self, action: #selector(openOfferwall), for: .touchUpInside)

        statusLabel.font = .preferredFont(forTextStyle: .body)
        statusLabel.adjustsFontForContentSizeCategory = true
        statusLabel.numberOfLines = 0
        statusLabel.accessibilityIdentifier = "status"
        statusLabel.text = "아직 초기화하지 않았습니다. 앱 실행만으로 SDK를 호출하지 않습니다."

        let scope = label(
            "수신 서버가 준비되지 않았다면 목록·상세까지만 확인하세요. 참여·완료 전에 매체사의 HTTPS 콜백 URL을 등록하고 콘솔에서 ‘허용됨’을 확인하세요. 실제 키나 개인 사용자 ID를 소스에 넣지 마세요.",
            style: .footnote
        )
        scope.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [
            title, environment, explanation, mediaKeyField, userIDField,
            initializeButton, openButton, statusLabel, scope
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        let scroll = UIScrollView()
        scroll.keyboardDismissMode = .onDrag
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(stack)
        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -24),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -48),
            mediaKeyField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            userIDField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }

    private func configure(_ field: UITextField, placeholder: String, identifier: String) {
        field.placeholder = placeholder
        field.accessibilityIdentifier = identifier
        field.accessibilityLabel = placeholder
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.spellCheckingType = .no
        field.clearButtonMode = .whileEditing
        field.addTarget(self, action: #selector(credentialsChanged), for: .editingChanged)
    }

    private func label(_ text: String, style: UIFont.TextStyle) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: style)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }

    @objc private func credentialsChanged() {
        isInitialized = false
        initializeButton.isEnabled = true
        openButton.isEnabled = false
        statusLabel.text = "입력값이 바뀌었습니다. 스테이징 SDK를 초기화하세요."
    }

    @objc private func initializeSDK() {
        guard !isInitialized else { return }
        let mediaKey = (mediaKeyField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let userID = (userIDField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !mediaKey.isEmpty else {
            statusLabel.text = "iOS SDK 스테이징 미디어키를 입력하세요. SDK를 호출하지 않았습니다."
            return
        }
        guard !userID.isEmpty, userID.count <= 48 else {
            statusLabel.text = "매체 앱의 테스트 사용자 ID를 1~48자로 입력하세요. SDK를 호출하지 않았습니다."
            return
        }

        view.endEditing(true)
        // Keep initialization in one place. The overload without environment uses production.
        Gad.initialize(mediaKey: mediaKey, userId: userID, environment: .staging)
        isInitialized = true
        initializeButton.isEnabled = false
        openButton.isEnabled = true
        statusLabel.text = "스테이징 설정을 전달했습니다. 광고 목록에서 STAGING 표식과 키의 유효성을 확인하세요."
    }

    @objc private func openOfferwall() {
        guard isInitialized else { return }
        Gad.showAdList(from: self)
    }
}
