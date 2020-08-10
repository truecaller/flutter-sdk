import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'truecaller_user_callback.dart';
import 'constants.dart';

class TruecallerSdk {
  static const MethodChannel _methodChannel = const MethodChannel('tc_method_channel');
  static const EventChannel _eventChannel = const EventChannel('tc_event_channel');

  static initiateSDK(
          {int sdkOptions: FlutterTruecallerSdkScope.SDK_OPTION_WITHOUT_OTP,
          int consentMode: FlutterTruecallerSdkScope.CONSENT_MODE_BOTTOMSHEET,
          int consentTitleOptions: FlutterTruecallerSdkScope.SDK_CONSENT_TITLE_GET_STARTED,
          int footerType: FlutterTruecallerSdkScope.FOOTER_TYPE_SKIP,
          int loginTextPrefix: FlutterTruecallerSdkScope.LOGIN_TEXT_PREFIX_TO_GET_STARTED,
          int loginTextSuffix: FlutterTruecallerSdkScope.LOGIN_TEXT_SUFFIX_PLEASE_LOGIN,
          int ctaTextPrefix: FlutterTruecallerSdkScope.CTA_TEXT_PREFIX_USE,
          String privacyPolicyUrl: "",
          String termsOfServiceUrl: "",
          int buttonShapeOptions: FlutterTruecallerSdkScope.BUTTON_SHAPE_ROUNDED,
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

  static Stream<TruecallerUserCallback> get streamData =>
      _eventChannel.receiveBroadcastStream().map((event) {
        TruecallerUserCallback callback = new TruecallerUserCallback();
        var resultHashMap = HashMap<String, String>.from(event);
        switch (resultHashMap["result"]) {
          case "success":
            callback.result = TruecallerUserCallbackResult.success;
            Map profileMap = jsonDecode(resultHashMap["data"]);
            TruecallerUserProfile truecallerUserProfile =
                TruecallerUserProfile.fromJson(profileMap);
            callback.profile = truecallerUserProfile;
            break;
          case "failure":
            callback.result = TruecallerUserCallbackResult.failure;
            Map errorMap = jsonDecode(resultHashMap["data"]);
            TruecallerError truecallerError = TruecallerError.fromJson(errorMap);
            callback.error = truecallerError;
            break;
          case "verification":
            callback.result = TruecallerUserCallbackResult.verification;
            break;
          default:
            throw ArgumentError('${resultHashMap["result"]} is not a valid result');
        }
        return callback;
      });

  static get getProfile async => await _methodChannel.invokeMethod('getProfile');

  static Future<bool> get isUsable async => _methodChannel.invokeMethod('isUsable');

  static get setDarkTheme async => await _methodChannel.invokeMethod('setDarkTheme');

  static setLocale(String locale) async =>
      await _methodChannel.invokeMethod('setLocale', {"locale": locale});
}
