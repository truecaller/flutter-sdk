/*
 * Truecaller SDK Copyright notice and License
 *
 * Copyright (c) 2015-present, True Software Scandinavia AB. All rights reserved.
 *
 * In accordance with the separate agreement executed between You and Your respective
 * Truecaller entity, You are granted a limited, non-exclusive, non-sublicensable,
 * non-transferrable, royalty-free, license to use the Truecaller SDK Product in object code
 * form only, solely for the purpose of using the Truecaller SDK Product with the
 * applications and API's provided by Truecaller.
 *
 * THE TRUECALLER SDK PRODUCT IS PROVIDED WITHOUT WARRANTY OF ANY
 * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, SOFTWARE QUALITY
 * PERFORMANCE, DATA ACCURACY AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE TRUECALLER SDK PRODUCT OR THE USE
 * OR OTHER DEALINGS IN THE TRUE SDK PRODUCT. AS A RESULT, THE TRUECALLER SDK
 * PRODUCT IS PROVIDED "AS IS" AND BY INTEGRATING THE TRUECALLER SDK PRODUCT
 * YOU ARE ASSUMING THE ENTIRE RISK AS TO ITS QUALITY AND PERFORMANCE.
 */

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'scope_options.dart';
import 'truecaller_callback.dart';

class TruecallerSdk {
  static const MethodChannel _methodChannel = const MethodChannel('tc_method_channel');
  static const EventChannel _eventChannel = const EventChannel('tc_event_channel');

  /// This method has to be called before anything else. It initializes the SDK with the
  /// customizable options which are all optional and have default values as set below in the method
  ///
  /// [sdkOptions] determines whether you want to use the SDK for verifying -
  /// 1. [TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP] i.e only Truecaller users
  /// 2. [TruecallerSdkScope.SDK_OPTION_WITH_OTP] i.e both Truecaller and Non-truecaller users
  ///
  /// NOTE: As of truecaller_sdk 0.0.1, only
  /// [TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP] is supported
  ///
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
          {@required int sdkOptions,
          int consentMode: TruecallerSdkScope.CONSENT_MODE_BOTTOMSHEET,
          int consentTitleOptions: TruecallerSdkScope.SDK_CONSENT_TITLE_GET_STARTED,
          int footerType: TruecallerSdkScope.FOOTER_TYPE_SKIP,
          int loginTextPrefix: TruecallerSdkScope.LOGIN_TEXT_PREFIX_TO_GET_STARTED,
          int loginTextSuffix: TruecallerSdkScope.LOGIN_TEXT_SUFFIX_PLEASE_LOGIN,
          int ctaTextPrefix: TruecallerSdkScope.CTA_TEXT_PREFIX_USE,
          String privacyPolicyUrl: "",
          String termsOfServiceUrl: "",
          int buttonShapeOptions: TruecallerSdkScope.BUTTON_SHAPE_ROUNDED,
          int buttonColor,
          int buttonTextColor}) async =>
      await _methodChannel.invokeMethod('initiateSDK', {
        "sdkOptions": sdkOptions,
        "consentMode": consentMode,
        "consentTitleOptions": consentTitleOptions,
        "footerType": footerType,
        "loginTextPrefix": loginTextPrefix,
        "loginTextSuffix": loginTextSuffix,
        "ctaTextPrefix": ctaTextPrefix,
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
  static Future<bool> get isUsable async => _methodChannel.invokeMethod('isUsable');

  /// After checking [isUsable], you can show the Truecaller profile verification dialog
  /// anywhere in your app flow by calling the following method
  static get getProfile async => await _methodChannel.invokeMethod('getProfile');

  /// Once you call [getProfile], you can listen to this stream to determine the result of the
  /// action taken by the user.
  /// [TruecallerSdkCallbackResult.success] means the result is successful and you can now fetch
  /// the user's profile from [TruecallerSdkCallback.profile]
  /// [TruecallerSdkCallbackResult.failure] means the result is failure and you can now fetch
  /// the result of failure from [TruecallerSdkCallback.error]
  /// [TruecallerSdkCallbackResult.verification] will be returned only when using
  /// [TruecallerSdkScope.SDK_OPTION_WITH_OTP] which indicates to verify the user
  /// manually, so this is not applicable for truecaller_sdk 0.0.1
  static Stream<TruecallerSdkCallback> get streamCallbackData =>
      _eventChannel.receiveBroadcastStream().map((event) {
        TruecallerSdkCallback callback = new TruecallerSdkCallback();
        var resultHashMap = HashMap<String, String>.from(event);
        switch (resultHashMap["result"].enumValue()) {
          case TruecallerSdkCallbackResult.success:
            callback.result = TruecallerSdkCallbackResult.success;
            Map profileMap = jsonDecode(resultHashMap["data"]);
            TruecallerUserProfile truecallerUserProfile =
                TruecallerUserProfile.fromJson(profileMap);
            callback.profile = truecallerUserProfile;
            break;
          case TruecallerSdkCallbackResult.failure:
            callback.result = TruecallerSdkCallbackResult.failure;
            Map errorMap = jsonDecode(resultHashMap["data"]);
            TruecallerError truecallerError = TruecallerError.fromJson(errorMap);
            callback.error = truecallerError;
            break;
          case TruecallerSdkCallbackResult.verification:
            callback.result = TruecallerSdkCallbackResult.verification;
            break;
          default:
            throw ArgumentError('${resultHashMap["result"]} is not a valid result');
        }
        return callback;
      });

  /// To customise the look and feel of the verification consent screen as per your app theme, add
  /// the following lines before calling the [getProfile] method.
  /// NOTE: It's not applicable for [TruecallerSdkScope.CONSENT_MODE_BOTTOMSHEET]
  static get setDarkTheme async => await _methodChannel.invokeMethod('setDarkTheme');

  /// To customise the profile dialog in any of the supported Indian languages, add the
  /// following lines before calling the [getProfile] method with [locale] of your choice.
  /// NOTE: Default value is en
  static setLocale(String locale) async =>
      await _methodChannel.invokeMethod('setLocale', {"locale": locale});
}
