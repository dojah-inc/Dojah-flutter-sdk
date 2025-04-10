import Flutter
import UIKit
import DojahWidget


public class DojahFlutterSdkPlugin: NSObject, FlutterPlugin {
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
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "launch-dojah":
            
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Arguments are not valid", details: nil))
                return
            }
            
            let widgetId = args["widget_id"] as? String
            let referenceId = args["reference_id"] as? String
            let email = args["email"] as? String
            
            if(widgetId == nil){
                result("widget_id can't be null")
                return
            }
            
            guard let rootNavController = getRootViewController() as? UINavigationController else {
                result(FlutterError(code: "NAV_ERROR", message: "Root view controller is not a navigation controller", details: nil))
                return
            }
            
            
            DojahWidgetSDK.initialize(widgetID: widgetId!, referenceID: referenceId, emailAddress:email, navController: rootNavController)
            
            result("widgetId is: \(widgetId ?? "")")
        default:
            result(FlutterMethodNotImplemented)
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
