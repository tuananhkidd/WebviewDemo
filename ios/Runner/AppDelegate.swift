import Flutter
import UIKit

/// App entry point that also registers the native MethodChannel.
///
/// Receives the API result (a todo title) from Dart and shows it as a native
/// toast-style overlay on iOS (UIKit has no built-in Toast, so we render a
/// lightweight auto-dismissing label).
@main
@objc class AppDelegate: FlutterAppDelegate {

  // Must match AppConstants.nativeChannel on the Dart side.
  private let channelName = "com.example.webview_demo/native"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: channelName,
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "showToast":
        let args = call.arguments as? [String: Any]
        let message = args?["message"] as? String ?? ""
        self?.showToast(message: message)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Renders a simple auto-dismissing toast at the bottom of the screen.
  private func showToast(message: String) {
    guard let window = self.window else { return }

    let label = PaddedLabel()
    label.text = message
    label.numberOfLines = 0
    label.textAlignment = .center
    label.textColor = .white
    label.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    label.font = UIFont.systemFont(ofSize: 14)
    label.layer.cornerRadius = 10
    label.clipsToBounds = true
    label.alpha = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    window.addSubview(label)

    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: window.centerXAnchor),
      label.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -40),
      label.leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: 24),
      label.trailingAnchor.constraint(lessThanOrEqualTo: window.trailingAnchor, constant: -24),
    ])

    UIView.animate(withDuration: 0.3, animations: { label.alpha = 1 }) { _ in
      UIView.animate(withDuration: 0.3, delay: 2.5, options: [], animations: {
        label.alpha = 0
      }) { _ in
        label.removeFromSuperview()
      }
    }
  }
}

/// UILabel subclass that adds internal padding around its text.
private class PaddedLabel: UILabel {
  private let inset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)

  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: inset))
  }

  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(
      width: size.width + inset.left + inset.right,
      height: size.height + inset.top + inset.bottom
    )
  }
}
