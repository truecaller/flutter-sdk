import UIKit
import Flutter
import truecaller_sdk
import TrueSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        TCTrueSDK.sharedManager().setup(withAppKey: "I7ViZ490028736bba408881687123b4cec49f",
                                        appLink: "https://si9f1dc18a1d0041efa219162d27d1c865.truecallerdevs.com")
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
