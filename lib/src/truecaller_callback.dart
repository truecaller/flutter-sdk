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

import 'truecaller.dart';

/// callback stream that gets returned from [TruecallerSdk.streamCallbackData]
class TruecallerSdkCallback {
  late TruecallerSdkCallbackResult result;

  //for tc-flow

  /// received when [result] equals [TruecallerSdkCallbackResult.failure] or
  /// [result] equals [TruecallerSdkCallbackResult.verification]
  /// It indicates reason why truecaller user verification failed
  TruecallerError? error;

  //for tc-flow and non-tc flow
  /// received when [result] equals [TruecallerSdkCallbackResult.success] or
  /// [result] equals [TruecallerSdkCallbackResult.verifiedBefore]
  TruecallerUserProfile? profile;

  //** for non-tc flow **//

  /// received when [result] equals [TruecallerSdkCallbackResult.otpReceived]
  String? otp;

  /// received when [result] equals [TruecallerSdkCallbackResult.verificationComplete]
  /// It can be used for server-side response validation
  String? accessToken;

  /// TTL(in sec) received when [result] equals either [TruecallerSdkCallbackResult.otpInitiated]
  /// or [result] equals [TruecallerSdkCallbackResult.missedCallInitiated]
  /// It indicates time left to complete the user verification process
  String? ttl;

  /// received when [result] equals [TruecallerSdkCallbackResult.exception]
  /// It indicates reason why non-truecaller user verification failed
  TruecallerException? exception;
}

/// enum with callback results that corresponds to the [TruecallerSdkCallback.result]
enum TruecallerSdkCallbackResult {
  //tc user callback results
  success,
  failure,
  verification,

  //non-tc user callback results
  missedCallInitiated,
  missedCallReceived,
  otpInitiated,
  otpReceived,
  verifiedBefore,
  verificationComplete,
  exception
}

/// extension method that converts String to corresponding enum value
extension EnumParser on String? {
  TruecallerSdkCallbackResult? enumValue() {
    return TruecallerSdkCallbackResult.values.firstWhere((element) =>
        element.toString().split(".")[1].toLowerCase() == this!.toLowerCase());
  }
}

/// user profile that corresponds to [TruecallerSdkCallback.profile]
class TruecallerUserProfile {
  String authorizationCode;
  String? state;
  String codeVerifier;

  /// get the [TruecallerUserProfile] values from Json
  TruecallerUserProfile.fromJson(Map<String, dynamic> map)
      : authorizationCode = map['authorizationCode'],
        codeVerifier = map['codeVerifier'],
        state = map['state'];
}

/// error that corresponds to [TruecallerSdkCallback.error]
class TruecallerError {
  late int code;
  late String? message;

  /// get the [TruecallerError] values from Json
  TruecallerError.fromJson(Map<String, dynamic> map) {
    code = map['errorCode'];
    message = map['errorMessage'];
  }
}

/// exception that corresponds to [TruecallerSdkCallback.exception]
class TruecallerException {
  late int code;
  late String message;

  /// get the [TruecallerException] values from Json
  TruecallerException.fromJson(Map<String, dynamic> map) {
    code = map['mExceptionType'];
    message = map['mExceptionMessage'];
  }

  @override
  String toString() {
    return "$code : $message";
  }
}
