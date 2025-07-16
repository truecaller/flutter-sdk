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

//Disclaimer should be manually shown while using iOS flutter SDK.
public class Controller: UIViewController, TCTrueSDKViewDelegate { }

public class SwiftTruecallerSdkPlugin: NSObject,
                                       FlutterPlugin {
    private var mainChannel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    
    private var controller = Controller()
    
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
            trueSdk.viewDelegate = controller
            result(true)
        case .isUsable:
            result(trueSdk.isSupported())
        case .requestVerification:
            requestVerification(call: call,
                                result: result)
            result(true)
        case .verifyOtp:
            verifyOtpAndName(call: call,
                             result: result)
        case .setDarkTheme,
                .setLocale,
                .verifyMissedCall:
            result(Constants.Error.methodNotImplemented)
            result(true)
        case .getProfile:
            trueSdk.requestTrueProfile()
            result(true)
        case .none:
            result(Constants.Error.methodNotImplemented)
        }
    }
    
    private func requestVerification(call: FlutterMethodCall,
                                     result: @escaping FlutterResult) {
        switch getVerificationArguments(from: call) {
        case .success(let arguments):
            trueSdk.requestVerification(forPhone: arguments.phoneNumber,
                                        countryCode: arguments.isoCountryCode)
        case .failure(let error):
            result(error)
        }
    }
    
    private typealias VerificationArguments = (phoneNumber: String, isoCountryCode: String)
    
    private func getVerificationArguments(from call: FlutterMethodCall) -> Result<VerificationArguments, Error> {
        guard let arguments = call.arguments as? [String: Any] else {
            return .failure(TCError(code: TCTrueSDKErrorCode.badRequest,
                                    description: Constants.ErrorDescription.unableToParseArguments))
        }
        guard let phone = arguments[Constants.Arguments.phone] as? String else {
            return .failure(TCError(code: TCTrueSDKErrorCode.badRequest,
                                    description: Constants.ErrorDescription.phoneNumberEmpty))
        }
        
        let countryCode = arguments[Constants.Arguments.countryCode] as? String
        ?? Constants.CountryCode.india
        return .success((phone,countryCode))
    }
    
    private func verifyOtpAndName(call: FlutterMethodCall,
                                  result: @escaping FlutterResult) {
        switch getCodeAndNames(from: call) {
        case .success(let arguments):
            trueSdk.verifySecurityCode(arguments.code,
                                       andUpdateFirstname: arguments.firstName,
                                       lastName: arguments.lastname)
        case .failure(let error):
            result(error)
        }
    }
    
    private typealias CodeAndName = (firstName: String, lastname: String, code: String)
    
    private func getCodeAndNames(from call: FlutterMethodCall) -> Result<CodeAndName, Error> {
        guard let arguments = call.arguments as? [String: Any] else {
            return .failure(TCError(code: TCTrueSDKErrorCode.badRequest,
                                    description: Constants.ErrorDescription.unableToParseArguments))
        }
        guard let code = arguments[Constants.Arguments.otp] as? String else {
            return .failure(TCError(code: TCTrueSDKErrorCode.badRequest,
                                    description: Constants.ErrorDescription.otpEmpty))
        }
        
        guard let firstName = arguments[Constants.Arguments.firstName] as? String else {
            return .failure(TCError(code: TCTrueSDKErrorCode.badRequest,
                                    description: Constants.ErrorDescription.firstNameEmpty))
        }
        
        let lastName =  arguments[Constants.Arguments.lastName] as? String ?? ""
        return .success((firstName, lastName, code))
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
    
    public func verificationStatusChanged(to verificationState: TCVerificationState) {
        var map = [String: Any]()
        map[Constants.String.result] = verificationState.rawValue
        switch verificationState {
        case .otpInitiated:
            map[Constants.String.data] = trueSdk.tokenTtl()
        case .otpReceived,
                .verifiedBefore:
            break
        case .verificationComplete:
            map[Constants.String.data] = trueSdk.accessTokenForOTPVerification
        @unknown default:
            break
        }
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
        eventSink?(map)
    }
}
