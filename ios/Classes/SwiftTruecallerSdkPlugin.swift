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
    
    init(with registrar: FlutterPluginRegistrar) {
        super.init()
        
        addMainChannel(registrar: registrar)
        addEventChannel(registrar: registrar)
        registrar.addApplicationDelegate(self)
    }
    
    private func addMainChannel(registrar: FlutterPluginRegistrar) {
        mainChannel = FlutterMethodChannel(name: "tc_method_channel",
                                           binaryMessenger: registrar.messenger())
        guard let mainChannel = mainChannel else {
            return
        }
        registrar.addMethodCallDelegate(self, channel: mainChannel)
    }
    
    private func addEventChannel(registrar: FlutterPluginRegistrar) {
        eventChannel = FlutterEventChannel(name: "tc_event_channel",
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
            result("Method not implemented")
        case .getProfile:
            trueSdk.requestTrueProfile()
        case .none:
            result("Method not implemented")
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
        map["result"] = "success"
        map["data"] = profile.toDict.tojsonString
        eventSink?(map)
    }
    
    public func didReceive(_ profileResponse: TCTrueProfileResponse) {
        var map = [String: Any]()
        map["result"] = "failure"
    }
    
    public func didFailToReceiveTrueProfileWithError(_ error: TCError) {
        var map = [String: Any]()
        map["result"] = "failure"
        map["result"] = error.toDict.tojsonString
        eventSink?(error)
    }
}

// MARK: - Private Extensions -

private extension TCTrueProfileResponse {
    var toDict: [String: AnyHashable] {
        var dict = [String: AnyHashable]()
        dict["payload"] = payload
        dict["signature"] = signature
        dict["signatureAlgorithm"] = signatureAlgorithm
        dict["requestNonce"] = requestNonce
        return dict
    }
}

private extension TCTrueProfile {
    var toDict: [String: AnyHashable] {
        var dict = [String: AnyHashable]()
        dict["firstName"] = firstName
        dict["lastName"] = lastName
        dict["isVerified"] = isVerified
        dict["isAmbassador"] = isAmbassador
        dict["phoneNumber"] = phoneNumber
        dict["countryCode"] = countryCode
        dict["street"] = street
        dict["city"] = city
        dict["facebookID"] = facebookID
        dict["twitterID"] = twitterID
        dict["email"] = email
        dict["url"] = url
        dict["avatarURL"] = avatarURL
        dict["jobTitle"] = jobTitle
        dict["companyName"] = companyName
        dict["requestTime"] = requestTime
        dict["genderValue"] = gender.rawValue
        return dict
    }
}

private extension TCError {
    var toDict: [String: AnyHashable] {
        var dict = [String: AnyHashable]()
        dict["code"] = getCode()
        dict["message"] = description
        return dict
    }
}

private extension Dictionary {
    var tojsonString: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}
