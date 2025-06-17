import Flutter
import UIKit
import DojahWidget


class DojahNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    var onDidShow: (UIViewController) -> Void = { _ in }
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        print("Did show: \(viewController)")
        onDidShow(viewController)
    }

    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        print("Will show: \(viewController)")
    }
    
    func setOnDidShow(_ onDidShow: @escaping (UIViewController) -> Void) {
        self.onDidShow = onDidShow
    }
}

public class DojahFlutterSdkPlugin: NSObject, FlutterPlugin {
    
    let navDelegate = DojahNavigationControllerDelegate()
    
    var prevController:UIViewController? = nil
    
    
    var result: FlutterResult?
    
 
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
    
        
    
        switch call.method {
        case "launch-dojah":
            
            guard let rootNavController = getRootViewController() as? UINavigationController  else {
                result(FlutterError(code: "NAV_ERROR", message: "Root view controller is not a navigation controller", details: nil))
                return
            }

            print("b4 setOnDidShow")

            
            
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Arguments are not valid", details: nil))
                return
            }
            
            let widgetId = args["widget_id"] as? String
            let referenceId = args["reference_id"] as? String
            let email = args["email"] as? String
            
            let extraUserData = args["extra_user_data"] as? [String: Any]
           
            if(widgetId == nil){
                result("widget_id can't be null")
                return
            }

            navDelegate.setOnDidShow { vc in
                print("onDidShow: \(vc)")
                //return result from DojahWidget once verification
                //is done,failed or cancel
                if(!String(describing:vc).contains("DojahWidget")){
                    let vStatus = DojahWidgetSDK.getVerificationResultStatus()
                    let status = if(vStatus.isEmpty){  "closed"} else {vStatus}
                    if(self.result != nil){
                        self.result!(status)
                    }
                    self.prevController = nil
                }else if(String(describing:vc).contains("DojahWidget.DJDisclaimer")
                         && self.prevController != nil){
                    rootNavController.popToRootViewController(animated: false)
                }else if(!String(describing:vc).contains("DojahWidget.SDKInitViewController")){
                    self.prevController = vc
                }
            }
            
            rootNavController.delegate = navDelegate

            
            DojahWidgetSDK.initialize(widgetID: widgetId!, referenceID: referenceId, emailAddress:email, extraUserData: mapToExtraUserData(from: extraUserData),navController: rootNavController)
            
//            result("widgetId is: \(widgetId ?? "")")
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "dojah_kyc_sdk_flutter", binaryMessenger: registrar.messenger())
        let instance = DojahFlutterSdkPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // Step 4: Ensure we are modifying the UI on the main thread
        // Safely get the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? FlutterAppDelegate else {
            print("AppDelegate is not of type FlutterAppDelegate")
            return
        }
        
        // Check if the root view controller is already a UINavigationController
        if let navigationController = appDelegate.window?.rootViewController as? UINavigationController {
            // If it is, do nothing (already set up)
            print("UINavigationController is already set up")

        } else {
            // If not, create a new UINavigationController with FlutterViewController as the root
            let flutterViewController = appDelegate.window?.rootViewController as? FlutterViewController ?? FlutterViewController()
            let navigationController = UINavigationController(rootViewController: flutterViewController)
            
            // Hide the navigation bar if desired
            navigationController.isNavigationBarHidden = true
            
            // Assign the navigation controller as the root view controller
            appDelegate.window?.rootViewController = navigationController
            appDelegate.window?.makeKeyAndVisible()
        }
        
    }
    
    private func getRootViewController() -> UIViewController? {
        // Safely get the root view controller (compatible with iOS 13+)
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first(where: { $0.isKeyWindow })
            return window?.rootViewController
        } else {
            // Fallback for earlier iOS versions
            return UIApplication.shared.keyWindow?.rootViewController
        }
    }
}

// Helper function to convert [String: Any] to ExtraUserData
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

// Mapping functions for each sub-struct
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
