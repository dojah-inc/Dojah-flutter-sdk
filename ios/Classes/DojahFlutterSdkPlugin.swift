import Flutter
import UIKit
import DojahWidget

// MARK: - Navigation Delegate
class DojahNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    var onDidShow: (UIViewController) -> Void = { _ in }

    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        onDidShow(viewController)
    }

    func setOnDidShow(_ onDidShow: @escaping (UIViewController) -> Void) {
        self.onDidShow = onDidShow
    }
}

// MARK: - Plugin
public class DojahFlutterSdkPlugin: NSObject, FlutterPlugin {

    private let navDelegate = DojahNavigationControllerDelegate()
    private var prevController: UIViewController?
    private var flutterResult: FlutterResult?
    private weak var modalNavController: UINavigationController?

    // ✅ SAFE REGISTRATION
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "dojah_kyc_sdk_flutter",
            binaryMessenger: registrar.messenger()
        )
        let instance = DojahFlutterSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

    }
    
    private func resolveSdkResult() {
        let vStatus = DojahWidgetSDK.getVerificationResultStatus()
        let status = vStatus.isEmpty ? "closed" : vStatus

        self.flutterResult?(status)
        self.prevController = nil

        self.modalNavController?.dismiss(animated: true)
        self.modalNavController = nil
    }

    // MARK: - Method Handler
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.flutterResult = result

        switch call.method {
        case "launch-dojah":

            guard let rootVC = getRootViewController() else {
                result(FlutterError(code: "NAV_ERROR",
                                    message: "No root view controller found",
                                    details: nil))
                return
            }

            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGUMENTS",
                                    message: "Arguments are not valid",
                                    details: nil))
                return
            }

            let widgetId = args["widget_id"] as? String
            let referenceId = args["reference_id"] as? String
            let email = args["email"] as? String
            let extraUserData = args["extra_user_data"] as? [String: Any]

            guard let validWidgetId = widgetId else {
                result("widget_id can't be null")
                return
            }

            // ✅ CREATE MODAL NAV CONTROLLER
            let dojahNavController = UINavigationController()
            dojahNavController.modalPresentationStyle = .fullScreen
            self.modalNavController = dojahNavController

            // ✅ PRESENT MODALLY
            rootVC.present(dojahNavController, animated: true)

            // ✅ TRACK DOJAH FLOW SAFELY
            navDelegate.setOnDidShow { [weak self] vc in
                guard let self = self else { return }
                let vcName = String(describing: vc)
                
                print("Dojah result status 123: \(vcName)")
                
                if !vcName.contains("DojahWidget") {
                    resolveSdkResult()
                }
                else if vcName.contains("DojahWidget.DJDisclaimer"),
                        self.prevController != nil {
                    self.modalNavController?.popToRootViewController(animated: false)
                }
                else if !vcName.contains("DojahWidget.SDKInitViewController") {
                    self.prevController = vc
                } else {
                    resolveSdkResult()
                }
            }

            dojahNavController.delegate = navDelegate

            // ✅ DETECT MODAL DISMISSAL (FOR CANCEL)
            dojahNavController.presentationController?.delegate = self

            // ✅ SAFE SDK INIT
            DojahWidgetSDK.initialize(
                widgetID: validWidgetId,
                referenceID: referenceId,
                emailAddress: email,
                extraUserData: mapToExtraUserData(from: extraUserData),
                source: "ios_flutter",
                navController: dojahNavController
            )

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Scene-Safe Root Controller Getter
    private func getRootViewController() -> UIViewController? {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first(where: { $0.isKeyWindow }) {
            return window.rootViewController
        }
        return nil
    }
}

// MARK: - Modal Dismissal Handling
extension DojahFlutterSdkPlugin: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        let vStatus = DojahWidgetSDK.getVerificationResultStatus()
        let status = vStatus.isEmpty ? "closed" : vStatus
        flutterResult?(status)
        flutterResult = nil
        modalNavController = nil
    }
}

// MARK: - Data Mapping Helpers
func mapToExtraUserData(from dictionary: [String: Any]?) -> ExtraUserData? {
    guard let extraUserData = dictionary else { return nil }
    return ExtraUserData(
        userData: mapToUserBioData(from: extraUserData["userData"] as? [String: Any]),
        govData: mapToExtraGovData(from: extraUserData["govData"] as? [String: Any]),
        govId: mapToExtraGovIdData(from: extraUserData["govId"] as? [String: Any]),
        location: mapToExtraLocationData(from: extraUserData["location"] as? [String: Any]),
        businessData: mapToExtraBusinessData(from: extraUserData["businessData"] as? [String: Any]),
        address: extraUserData["address"] as? String,
        metadata: extraUserData["metadata"] as? [String: Any]
    )
}

func mapToUserBioData(from dictionary: [String: Any]?) -> UserBioData? {
    guard let userData = dictionary else { return nil }
    return UserBioData(
        firstName: userData["first_name"] as? String,
        lastName: userData["last_name"] as? String,
        dob: userData["dob"] as? String,
        email: userData["email"] as? String
    )
}

func mapToExtraGovData(from dictionary: [String: Any]?) -> ExtraGovData? {
    guard let govData = dictionary else { return nil }
    return ExtraGovData(
        bvn: govData["bvn"] as? String,
        dl: govData["dl"] as? String,
        nin: govData["nin"] as? String,
        vnin: govData["vnin"] as? String
    )
}

func mapToExtraGovIdData(from dictionary: [String: Any]?) -> ExtraGovIdData? {
    guard let govId = dictionary else { return nil }
    return ExtraGovIdData(
        national: govId["national"] as? String,
        passport: govId["passport"] as? String,
        dl: govId["dl"] as? String,
        voter: govId["voter"] as? String,
        nin: govId["nin"] as? String,
        others: govId["others"] as? String
    )
}

func mapToExtraLocationData(from dictionary: [String: Any]?) -> ExtraLocationData? {
    guard let location = dictionary else { return nil }
    return ExtraLocationData(
        longitude: location["longitude"] as? String,
        latitude: location["latitude"] as? String
    )
}

func mapToExtraBusinessData(from dictionary: [String: Any]?) -> ExtraBusinessData? {
    guard let businessData = dictionary else { return nil }
    return ExtraBusinessData(
        cac: businessData["cac"] as? String
    )
}
