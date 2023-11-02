/*
 * TRUECALLER SDK COPYRIGHT, TRADEMARK AND LICENSE NOTICE
 *
 * Copyright © 2015-Present, True Software Scandinavia AB. All rights reserved.
 *
 * Truecaller and Truecaller SDK are registered trademark of True Software Scandinavia AB.
 *
 * In accordance with the Truecaller SDK Agreement available
 * here (https://developer.truecaller.com/Truecaller-sdk-product-license-agreement-RoW.pdf)
 * accepted and agreed between You and Your respective Truecaller entity, You are granted a
 * limited, non-exclusive, non-sublicensable, non-transferable, royalty-free, license to use the
 * Truecaller SDK Product in object code form only, solely for the purpose of using
 * the Truecaller SDK Product with the applications and APIs provided by Truecaller.
 *
 * THE TRUECALLER SDK PRODUCT IS PROVIDED BY THE COPYRIGHT HOLDER AND AUTHOR “AS IS”,
 * WITHOUT WARRANTY OF ANY KIND,EXPRESS OR IMPLIED,INCLUDING BUT NOT LIMITED
 * TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
 * SOFTWARE QUALITY,PERFORMANCE,DATA ACCURACY AND NON-INFRINGEMENT. IN NO
 * EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES OR
 * OTHER LIABILITY INCLUDING BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION: HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THE TRUECALLER SDK PRODUCT OR THE USE
 * OR OTHER DEALINGS IN THE TRUECALLER SDK PRODUCT, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE. AS A RESULT, BY INTEGRATING THE TRUECALLER SDK
 * PRODUCT YOU ARE ASSUMING THE ENTIRE RISK AS TO ITS QUALITY AND PERFORMANCE.
 */

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'scope_options.dart';
import 'truecaller_callback.dart';

class TcSdk {
  static const MethodChannel _methodChannel =
      const MethodChannel('tc_method_channel');
  static const EventChannel _eventChannel =
      const EventChannel('tc_event_channel');
  static Stream<TcSdkCallback>? _callbackStream;

  /// This method has to be called before anything else. It initializes the SDK with the
  /// customizable options which are all optional and have default values as set below in the method
  ///
  /// [sdkOption] determines whether you want to use the SDK for verifying -
  /// 1. [TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS] i.e only Truecaller users
  /// 2. [TcSdkOptions.OPTION_VERIFY_ALL_USERS] i.e both Truecaller and Non-Truecaller users
  ///
  /// [consentHeadingOption] determines the heading of the consent screen.
  /// [ctaText] determines prefix text in login/primary button
  /// [footerType] determines the footer button/secondary button text.
  /// [buttonShapeOption] to set login button shape
  /// [buttonColor] to set login button color
  /// [buttonTextColor] to set login button text color
  static initializeSDK(
          {required int sdkOption,
          int consentHeadingOption = TcSdkOptions.SDK_CONSENT_HEADING_LOG_IN_TO,
          int footerType = TcSdkOptions.FOOTER_TYPE_ANOTHER_MOBILE_NO,
          int ctaText = TcSdkOptions.CTA_TEXT_PROCEED,
          int buttonShapeOption = TcSdkOptions.BUTTON_SHAPE_ROUNDED,
          int? buttonColor,
          int? buttonTextColor}) async =>
      await _methodChannel.invokeMethod('initializeSDK', {
        "sdkOption": sdkOption,
        "consentHeadingOption": consentHeadingOption,
        "footerType": footerType,
        "ctaText": ctaText,
        "buttonShapeOption": buttonShapeOption,
        "buttonColor": buttonColor,
        "buttonTextColor": buttonTextColor,
      });

  /// Once you initialise the Truecaller SDK using the [initializeSDK] method, and if you are using
  /// the SDK for verification of only Truecaller users ( by setting the sdkOptions scope as
  /// [TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS], you can check if the Truecaller app is
  /// present on the user's device and whether the user has a valid account state or not and
  /// whether the OAuth flow is supported or not using the following method
  static Future<dynamic> get isOAuthFlowUsable async =>
      _methodChannel.invokeMethod('isOAuthFlowUsable');

  /// After checking [isUsable], you can invoke Truecaller's OAuth consent screen dialog
  /// in your app flow by calling the following method
  /// The result will be returned asynchronously via [streamCallbackData] stream
  static get getAuthorizationCode async =>
      await _methodChannel.invokeMethod('getAuthorizationCode');

  /// Once you call [getAuthorizationCode], you can listen to this stream to determine the result of the
  /// action taken by the user.
  /// [TcSdkCallbackResult.success] means the result is successful and you can now fetch
  /// the user's access token using the authorization code from [TcSdkCallback.tcOAuthData]
  /// [TcSdkCallbackResult.failure] means the result is failure and you can now fetch
  /// the result of failure from [TcSdkCallback.error]
  /// [TcSdkCallbackResult.verification] will be returned only when using
  /// [TcSdkOptions.OPTION_VERIFY_ALL_USERS] which indicates to verify the user manually
  static Stream<TcSdkCallback> get streamCallbackData {
    if (_callbackStream == null) {
      _callbackStream =
          _eventChannel.receiveBroadcastStream().map<TcSdkCallback>((value) {
        TcSdkCallback callback = new TcSdkCallback();
        var resultHashMap = HashMap<String, String>.from(value);
        final String? result = resultHashMap["result"];
        switch (result.enumValue()) {
          case TcSdkCallbackResult.success:
            callback.result = TcSdkCallbackResult.success;
            _insertOAuthData(callback, resultHashMap["data"]!);
            break;
          case TcSdkCallbackResult.failure:
            callback.result = TcSdkCallbackResult.failure;
            _insertError(callback, resultHashMap["data"]);
            break;
          case TcSdkCallbackResult.verification:
            callback.result = TcSdkCallbackResult.verification;
            _insertError(callback, resultHashMap["data"]);
            break;
          case TcSdkCallbackResult.missedCallInitiated:
            callback.result = TcSdkCallbackResult.missedCallInitiated;
            CallbackData data = _insertData(callback, resultHashMap["data"]!);
            callback.ttl = data.ttl;
            callback.requestNonce = data.requestNonce;
            break;
          case TcSdkCallbackResult.missedCallReceived:
            callback.result = TcSdkCallbackResult.missedCallReceived;
            break;
          case TcSdkCallbackResult.otpInitiated:
            callback.result = TcSdkCallbackResult.otpInitiated;
            CallbackData data = _insertData(callback, resultHashMap["data"]!);
            callback.ttl = data.ttl;
            callback.requestNonce = data.requestNonce;
            break;
          case TcSdkCallbackResult.otpReceived:
            callback.result = TcSdkCallbackResult.otpReceived;
            CallbackData data = _insertData(callback, resultHashMap["data"]!);
            callback.otp = data.otp;
            break;
          case TcSdkCallbackResult.verifiedBefore:
            callback.result = TcSdkCallbackResult.verifiedBefore;
            CallbackData data = _insertData(callback, resultHashMap["data"]!);
            _insertProfile(callback, data.profile!);
            break;
          case TcSdkCallbackResult.verificationComplete:
            callback.result = TcSdkCallbackResult.verificationComplete;
            CallbackData data = _insertData(callback, resultHashMap["data"]!);
            callback.accessToken = data.accessToken;
            callback.requestNonce = data.requestNonce;
            break;
          case TcSdkCallbackResult.exception:
            callback.result = TcSdkCallbackResult.exception;
            Map exceptionMap = jsonDecode(resultHashMap["data"]!);
            TruecallerException exception = TruecallerException.fromJson(
                exceptionMap as Map<String, dynamic>);
            callback.exception = exception;
            break;
          default:
            throw PlatformException(
                code: "1010",
                message: "${resultHashMap["result"]} is not a valid result");
        }
        return callback;
      });
    }
    return _callbackStream!;
  }

  static CallbackData _insertData(TcSdkCallback callback, String data) {
    Map dataMap = jsonDecode(data);
    return CallbackData.fromJson(dataMap as Map<String, dynamic>);
  }

  static _insertOAuthData(TcSdkCallback callback, String data) {
    Map oAuthDataMap = jsonDecode(data);
    TcOAuthData tcOAuthData =
        TcOAuthData.fromJson(oAuthDataMap as Map<String, dynamic>);
    callback.tcOAuthData = tcOAuthData;
  }

  static _insertProfile(TcSdkCallback callback, String data) {
    Map profileMap = jsonDecode(data);
    TruecallerUserProfile profile =
        TruecallerUserProfile.fromJson(profileMap as Map<String, dynamic>);
    callback.profile = profile;
  }

  static _insertError(TcSdkCallback callback, String? data) {
    // onVerificationRequired has nullable error, hence null check
    if (data != null &&
        data.trim().isNotEmpty &&
        data.trim().toLowerCase() != "null") {
      Map errorMap = jsonDecode(data);
      TcOAuthError tcOAuthError =
          TcOAuthError.fromJson(errorMap as Map<String, dynamic>);
      callback.error = tcOAuthError;
    }
  }

  /// This utility method generates a random code verifier string using SecureRandom as the
  /// source of entropy with 64 as the default entropy quantity.
  /// You can either generate your own code verifier or use this utility method to generate one
  /// for you.
  /// NOTE: Store the code verifier in the current session since it would be required later
  /// to generate the access token.
  static Future<dynamic> get generateRandomCodeVerifier async =>
      _methodChannel.invokeMethod('generateRandomCodeVerifier');

  /// This utility method produces a code challenge from the supplied code verifier[codeVerifier]
  /// using SHA-256 as the challenge method and Base64 as encoding if the system supports it.
  /// NOTE: All Android devices should ideally support SHA-256 and Base64, but in rare case if
  /// the doesn't, then this method would return null meaning that you can’t proceed further.
  /// Please ensure to have a null safe check for such cases.
  static Future<dynamic> generateCodeChallenge(String codeVerifier) async =>
      _methodChannel.invokeMethod(
          'generateCodeChallenge', {"codeVerifier": codeVerifier});

  /// Set your own code challenge or use the utility method [generateRandomCodeVerifier] to generate
  /// one for you and set it via [codeChallenge] to this method
  /// Set it before calling [getAuthorizationCode]
  static setCodeChallenge(String codeChallenge) async => await _methodChannel
      .invokeMethod('setCodeChallenge', {"codeChallenge": codeChallenge});

  /// Set the list of scopes to be requested using [scopes].
  /// Set it before calling [getAuthorizationCode]
  static setOAuthScopes(List<String> scopes) async =>
      await _methodChannel.invokeMethod('setOAuthScopes', {"scopes": scopes});

  /// Set a unique state parameter [oAuthState] & store it in the current session to use it later in the
  /// onSuccess() callback method of the [TcOAuthCallback] to match if the state received from the
  /// authorization server is the same as set here to prevent request forgery attacks.
  /// Set it before calling [getAuthorizationCode]
  static setOAuthState(String oAuthState) async => await _methodChannel
      .invokeMethod('setOAuthState', {"oAuthState": oAuthState});

  /// Customise the consent screen dialog in any of the supported Indian languages by supplying
  /// [locale] to the method.
  /// NOTE: Default value is en
  /// Set it before calling [getAuthorizationCode]
  static setLocale(String locale) async =>
      await _methodChannel.invokeMethod('setLocale', {"locale": locale});

  /// This method will initiate manual verification of [phoneNumber] asynchronously for Indian
  /// numbers only so that's why default countryISO is set to "IN".
  /// The result will be returned asynchronously via [streamCallbackData] stream
  /// Check [TcSdkCallbackResult] to understand the different verifications states.
  /// This method may lead to verification with a SMS Code (OTP) or verification with a CALL,
  /// or if the user is already verified on the device, will get the call back as
  /// [TcSdkCallbackResult.verifiedBefore] in [streamCallbackData]
  static requestVerification(
          {required String phoneNumber, String countryISO = "IN"}) async =>
      await _methodChannel.invokeMethod(
          'requestVerification', {"ph": phoneNumber, "ci": countryISO});

  /// Call this method after [requestVerification] to complete the verification if the number has
  /// to be verified with a missed call.
  /// i.e call this method only when you receive [TcSdkCallbackResult.missedCallReceived]
  /// in [streamCallbackData].
  /// To complete verification, it is mandatory to pass [firstName] and [lastName] of the user
  static verifyMissedCall(
          {required String firstName, required String lastName}) async =>
      await _methodChannel.invokeMethod(
          'verifyMissedCall', {"fname": firstName, "lname": lastName});

  /// Call this method after [requestVerification] to complete the verification if the number has
  /// to be verified with an OTP.
  /// i.e call this method when you receive either [TcSdkCallbackResult.otpInitiated] or
  /// [TcSdkCallbackResult.otpReceived] in [streamCallbackData].
  /// To complete verification, it is mandatory to pass [firstName] and [lastName] of the user
  /// with the [otp] code received over SMS
  static verifyOtp(
          {required String firstName,
          required String lastName,
          required String otp}) async =>
      await _methodChannel.invokeMethod(
          'verifyOtp', {"fname": firstName, "lname": lastName, "otp": otp});
}
