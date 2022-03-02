import Flutter
import UIKit
import TrueSDK

private enum MethodCalls: String {
    case initiateSDK
    case isUsable
    case setDarkTheme
    case setLocale
    case getProfile
    case requestVerification
    case verifyOtp
    case verifyMissedCall
}

public class SwiftTruecallerSdkPlugin: NSObject,
                                       FlutterPlugin {
    private var mainChannel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    
    private var trueSdk = TCTrueSDK.sharedManager()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        _ = SwiftTruecallerSdkPlugin(with: registrar)
    }
    
    private var trueProfileResponse: TCTrueProfileResponse?
    
    init(with registrar: FlutterPluginRegistrar) {
        super.init()
        
        addMainChannel(registrar: registrar)
        addEventChannel(registrar: registrar)
        registrar.addApplicationDelegate(self)
    }
    
    private func addMainChannel(registrar: FlutterPluginRegistrar) {
        mainChannel = FlutterMethodChannel(name: Constants.ChannelNames.methodChannel,
                                           binaryMessenger: registrar.messenger())
        guard let mainChannel = mainChannel else {
            return
        }
        registrar.addMethodCallDelegate(self, channel: mainChannel)
    }
    
    private func addEventChannel(registrar: FlutterPluginRegistrar) {
        eventChannel = FlutterEventChannel(name: Constants.ChannelNames.eventChannel,
                                           binaryMessenger: registrar.messenger())
        guard let eventChannel = eventChannel else {
            return
        }
        eventChannel.setStreamHandler(self)
    }
    
    public func handle(_ call: FlutterMethodCall,
                       result: @escaping FlutterResult) {
        let method = MethodCalls(rawValue: call.method)
        switch method {
        case .initiateSDK:
            trueSdk.delegate = self
            result(true)
        case .isUsable:
            result(trueSdk.isSupported())
        case .setDarkTheme,
                .setLocale,
                .requestVerification,
                .verifyOtp,
                .verifyMissedCall:
            result(Constants.Error.methodNotImplemented)
        case .getProfile:
            trueSdk.requestTrueProfile()
        case .none:
            result(Constants.Error.methodNotImplemented)
        }
    }
}

// MARK: - App delegate methods -

extension SwiftTruecallerSdkPlugin {
    public func application(_ application: UIApplication,
                            continue userActivity: NSUserActivity,
                            restorationHandler: @escaping ([Any]) -> Void) -> Bool {
        return TCTrueSDK.sharedManager().application(application,
                                                     continue: userActivity,
                                                     restorationHandler: restorationHandler as? ([Any]?) -> Void)
    }
    
    public func application(_ app: UIApplication,
                            open url: URL,
                            options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return TCTrueSDK.sharedManager().continue(withUrlScheme: url)
    }
}

// MARK: - FlutterStreamHandler -

extension SwiftTruecallerSdkPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?,
                         eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}

// MARK: - TCTrueSDKDelegate -

extension SwiftTruecallerSdkPlugin: TCTrueSDKDelegate {
    public func didReceive(_ profile: TCTrueProfile) {
        var map = [String: Any]()
        map[Constants.String.result] = Constants.String.success
        var data = profile.toDict
        if let response = trueProfileResponse {
            data = data.merging(response.toDict) { $1 }
            trueProfileResponse = nil
        }
        map[Constants.String.data] = data.tojsonString
        eventSink?(map)
    }
    
    public func didReceive(_ profileResponse: TCTrueProfileResponse) {
        trueProfileResponse = profileResponse
    }
    
    public func didFailToReceiveTrueProfileWithError(_ error: TCError) {
        var map = [String: Any]()
        map[Constants.String.result] = Constants.String.failure
        map[Constants.String.data] = error.toDict.tojsonString
        trueProfileResponse = nil
        eventSink?(error)
    }
}
