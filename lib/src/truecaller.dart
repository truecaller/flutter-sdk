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

class TruecallerSdk {
  static const MethodChannel _methodChannel =
  const MethodChannel('tc_method_channel');
  static const EventChannel _eventChannel =
  const EventChannel('tc_event_channel');
  static Stream<TruecallerSdkCallback>? _callbackStream;

  /// This method has to be called before anything else. It initializes the SDK with the
  /// customizable options which are all optional and have default values as set below in the method
  ///
  /// [sdkOptions] determines whether you want to use the SDK for verifying -
  /// 1. [TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP] i.e only Truecaller users
  /// 2. [TruecallerSdkScope.SDK_OPTION_WITH_OTP] i.e both Truecaller and Non-truecaller users
  ///
  /// NOTE: In truecaller_sdk 0.0.1, only
  /// [TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP] is supported
  /// In truecaller_sdk 0.0.2 and onwards, both [TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP] and
  /// [TruecallerSdkScope.SDK_OPTION_WITH_OTP] are supported
  /// [consentMode] determines which kind of consent screen you want to show to the user.
  /// [consentTitleOptions] is applicable only for [TruecallerSdkScope.CONSENT_MODE_POPUP]
  /// and [TruecallerSdkScope.CONSENT_MODE_FULLSCREEN] and it sets the title prefix
  /// [footerType] determines the footer button text. You can set it to
  /// [TruecallerSdkScope.FOOTER_TYPE_NONE] if you don't want to show any footer button
  /// There are some customization options applicable only for [TruecallerSdkScope.CONSENT_MODE_BOTTOMSHEET]
  /// which are following -
  /// [loginTextPrefix] determines prefix text in login sentence
  /// [loginTextSuffix] determines suffix text in login sentence
  /// [ctaTextPrefix] determines prefix text in login button
  /// [privacyPolicyUrl] to set your own privacy policy url
  /// [termsOfServiceUrl] to set your own terms of service url
  /// [buttonShapeOptions] to set login button shape
  /// [buttonColor] to set login button color
  /// [buttonTextColor] to set login button text color
  static initializeSDK(
      {required int sdkOptions,

        int footerType: TruecallerSdkScope.FOOTER_TYPE_SKIP,
        int loginTextPrefix: TruecallerSdkScope.LOGIN_TEXT_PREFIX_TO_GET_STARTED,
        String privacyPolicyUrl: "",
        String termsOfServiceUrl: "",
        int buttonShapeOptions: TruecallerSdkScope.BUTTON_SHAPE_ROUNDED,
        int? buttonColor,
        int? buttonTextColor}) async =>
      await _methodChannel.invokeMethod('initiateSDK', {
        "sdkOptions": sdkOptions,
        "footerType": footerType,
        "loginTextPrefix": loginTextPrefix,
        "privacyPolicyUrl": privacyPolicyUrl,
        "termsOfServiceUrl": termsOfServiceUrl,
        "buttonShapeOptions": buttonShapeOptions,
        "buttonColor": buttonColor,
        "buttonTextColor": buttonTextColor,
      });

  /// Once you initialise the Truecaller SDK using the [initializeSDK] method, and if you are using
  /// the SDK for verification of only Truecaller users ( by setting the sdkOptions scope as
  /// [TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP], you can check if the Truecaller app is
  /// present on the user's device or whether the user has a valid account state or not by using
  /// the following method
  static Future<dynamic> get isUsable async =>
      _methodChannel.invokeMethod('isUsable');

  /// After checking [isUsable], you can show the Truecaller profile verification dialog
  /// anywhere in your app flow by calling the following method
  /// The result will be returned asynchronously via [streamCallbackData] stream
  static get getProfile async =>
      await _methodChannel.invokeMethod('getProfile');

  /// Once you call [getProfile], you can listen to this stream to determine the result of the
  /// action taken by the user.
  /// [TruecallerSdkCallbackResult.success] means the result is successful and you can now fetch
  /// the user's profile from [TruecallerSdkCallback.profile]
  /// [TruecallerSdkCallbackResult.failure] means the result is failure and you can now fetch
  /// the result of failure from [TruecallerSdkCallback.error]
  /// [TruecallerSdkCallbackResult.verification] will be returned only when using
  /// [TruecallerSdkScope.SDK_OPTION_WITH_OTP] which indicates to verify the user
  /// manually, so this is not applicable for truecaller_sdk 0.0.1
  static Stream<TruecallerSdkCallback> get streamCallbackData {
    if (_callbackStream == null) {
      _callbackStream = _eventChannel
          .receiveBroadcastStream()
          .map<TruecallerSdkCallback>((value) {
        TruecallerSdkCallback callback = new TruecallerSdkCallback();
        var resultHashMap = HashMap<String, String>.from(value);
        final String? result = resultHashMap["result"];
        switch (result.enumValue()) {
          case TruecallerSdkCallbackResult.success:
            callback.result = TruecallerSdkCallbackResult.success;
            _insertProfile(callback, resultHashMap["data"]!);
            break;
          case TruecallerSdkCallbackResult.failure:
            callback.result = TruecallerSdkCallbackResult.failure;
            _insertError(callback, resultHashMap["data"]);
            break;
          case TruecallerSdkCallbackResult.verification:
            callback.result = TruecallerSdkCallbackResult.verification;
            _insertError(callback, resultHashMap["data"]);
            break;
          case TruecallerSdkCallbackResult.missedCallInitiated:
            callback.result = TruecallerSdkCallbackResult.missedCallInitiated;
            callback.ttl = resultHashMap["data"];
            break;
          case TruecallerSdkCallbackResult.missedCallReceived:
            callback.result = TruecallerSdkCallbackResult.missedCallReceived;
            break;
          case TruecallerSdkCallbackResult.otpInitiated:
            callback.result = TruecallerSdkCallbackResult.otpInitiated;
            callback.ttl = resultHashMap["data"];
            break;
          case TruecallerSdkCallbackResult.otpReceived:
            callback.result = TruecallerSdkCallbackResult.otpReceived;
            callback.otp = resultHashMap["data"];
            break;
          case TruecallerSdkCallbackResult.verifiedBefore:
            callback.result = TruecallerSdkCallbackResult.verifiedBefore;
            _insertProfile(callback, resultHashMap["data"]!);
            break;
          case TruecallerSdkCallbackResult.verificationComplete:
            callback.result = TruecallerSdkCallbackResult.verificationComplete;
            callback.accessToken = resultHashMap["data"];
            break;
          case TruecallerSdkCallbackResult.exception:
            callback.result = TruecallerSdkCallbackResult.exception;
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

  static _insertProfile(TruecallerSdkCallback callback, String data) {
    Map profileMap = jsonDecode(data);
    TruecallerUserProfile profile = TruecallerUserProfile.fromJson(profileMap as Map<String, dynamic>);
    callback.profile = profile;
  }

  static _insertError(TruecallerSdkCallback callback, String? data) {
    // onVerificationRequired has nullable error, hence null check
    if (data != null &&
        data.trim().isNotEmpty &&
        data.trim().toLowerCase() != "null") {
      Map errorMap = jsonDecode(data);
      TruecallerError truecallerError =
      TruecallerError.fromJson(errorMap as Map<String, dynamic>);
      callback.error = truecallerError;
    }
  }

  /// To customise the look and feel of the verification consent screen as per your app theme, add
  /// the following lines before calling the [getProfile] method.
  /// NOTE: It's not applicable for [TruecallerSdkScope.CONSENT_MODE_BOTTOMSHEET]
  static get setDarkTheme async =>
      await _methodChannel.invokeMethod('setDarkTheme');

  /// To customise the profile dialog in any of the supported Indian languages, add the
  /// following lines before calling the [getProfile] method with [locale] of your choice.
  /// NOTE: Default value is en
  static setLocale(String locale) async =>
      await _methodChannel.invokeMethod('setLocale', {"locale": locale});

  /// This method will initiate manual verification of [phoneNumber] asynchronously for Indian
  /// numbers only so that's why default countryISO is set to "IN".
  /// The result will be returned asynchronously via [streamCallbackData] stream
  /// Check [TruecallerSdkCallbackResult] to understand the different verifications states.
  /// This method may lead to verification with a SMS Code (OTP) or verification with a CALL,
  /// or if the user is already verified on the device, will get the call back as
  /// [TruecallerSdkCallbackResult.verifiedBefore] in [streamCallbackData]
  static requestVerification(
      {required String phoneNumber, String countryISO: "IN"}) async =>
      await _methodChannel.invokeMethod(
          'requestVerification', {"ph": phoneNumber, "ci": countryISO});

  /// Call this method after [requestVerification] to complete the verification if the number has
  /// to be verified with a missed call.
  /// i.e call this method only when you receive [TruecallerSdkCallbackResult.missedCallReceived]
  /// in [streamCallbackData].
  /// To complete verification, it is mandatory to pass [firstName] and [lastName] of the user
  static verifyMissedCall(
      {required String firstName, required String lastName}) async =>
      await _methodChannel.invokeMethod(
          'verifyMissedCall', {"fname": firstName, "lname": lastName});

  /// Call this method after [requestVerification] to complete the verification if the number has
  /// to be verified with an OTP.
  /// i.e call this method when you receive either [TruecallerSdkCallbackResult.otpInitiated] or
  /// [TruecallerSdkCallbackResult.otpReceived] in [streamCallbackData].
  /// To complete verification, it is mandatory to pass [firstName] and [lastName] of the user
  /// with the [otp] code received over SMS
  static verifyOtp(
      {required String firstName,
        required String lastName,
        required String otp}) async =>
      await _methodChannel.invokeMethod(
          'verifyOtp', {"fname": firstName, "lname": lastName, "otp": otp});
}
