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

/// callback stream that gets returned from [TcSdk.streamCallbackData]
class TcSdkCallback {
  late TcSdkCallbackResult result;

  //for tc-flow

  /// received when [result] equals [TcSdkCallbackResult.success]
  TcOAuthData? tcOAuthData;

  /// received when [result] equals [TcSdkCallbackResult.failure] or
  /// [result] equals [TcSdkCallbackResult.verification]
  /// It indicates reason why Truecaller user verification failed
  TcOAuthError? error;

  //for non-tc flow

  /// received when [result] equals [TcSdkCallbackResult.verifiedBefore]
  TruecallerUserProfile? profile;

  /// received when [result] equals [TcSdkCallbackResult.otpReceived]
  String? otp;

  /// received when [result] equals [TcSdkCallbackResult.verificationComplete]
  /// It can be used for server-side response validation
  String? accessToken;

  /// TTL(in sec) received when [result] equals either [TcSdkCallbackResult.otpInitiated]
  /// or [result] equals [TcSdkCallbackResult.missedCallInitiated]
  /// It indicates time left to complete the user verification process
  String? ttl;

  /// Request Nonce received when [result] equals either [TcSdkCallbackResult.otpInitiated]
  /// or [TcSdkCallbackResult.missedCallInitiated]
  /// or [TcSdkCallbackResult.verificationComplete]
  /// It can be used to verify whether the custom request identifier (if set) during SDK
  /// initialization is same as this one received in response which essentially assures a
  /// correlation between the request and the response
  String? requestNonce;

  /// received when [result] equals [TcSdkCallbackResult.exception]
  /// It indicates reason why non-truecaller user verification failed
  TruecallerException? exception;
}

/// enum with callback results that corresponds to the [TcSdkCallback.result]
enum TcSdkCallbackResult {
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
  TcSdkCallbackResult? enumValue() {
    return TcSdkCallbackResult.values.firstWhere((element) =>
        element.toString().split(".")[1].toLowerCase() == this!.toLowerCase());
  }
}

/// OAuth data that corresponds to [TcSdkCallback.tcOAuthData]
class TcOAuthData {
  late String authorizationCode;
  late String state;
  late List<dynamic> scopesGranted;

  /// get the [TcOAuthData] values from Json
  TcOAuthData.fromJson(Map<String, dynamic> map) {
    authorizationCode = map['authorizationCode'];
    state = map['state'];
    scopesGranted = map['scopesGranted'];
  }
}

/// user profile that corresponds to [TcSdkCallback.profile]
class TruecallerUserProfile {
  String firstName;
  String? lastName;
  String phoneNumber;
  String? gender;
  String? street;
  String? city;
  String? zipcode;
  String? countryCode;
  String? facebookId;
  String? twitterId;
  String? email;
  String? url;
  String? avatarUrl;
  bool? isTrueName;
  bool? isAmbassador;
  String? companyName;
  String? jobTitle;
  String? payload;
  String? signature;
  String? signatureAlgorithm;
  String? requestNonce;
  bool? isSimChanged;
  String? verificationMode;
  int? verificationTimestamp;
  String? userLocale;
  String? accessToken;

  /// get the [TruecallerUserProfile] values from Json
  TruecallerUserProfile.fromJson(Map<String, dynamic> map)
      : firstName = map['firstName'],
        lastName = map['lastName'],
        phoneNumber = map['phoneNumber'],
        gender = map['gender'],
        street = map['street'],
        city = map['city'],
        zipcode = map['zipcode'],
        countryCode = map['countryCode'],
        facebookId = map['facebookId'],
        twitterId = map['twitterId'],
        email = map['email'],
        url = map['url'],
        avatarUrl = map['avatarUrl'],
        isTrueName = map['isTrueName'],
        isAmbassador = map['isAmbassador'],
        companyName = map['companyName'],
        jobTitle = map['jobTitle'],
        payload = map['payload'],
        signature = map['signature'],
        signatureAlgorithm = map['signatureAlgorithm'],
        requestNonce = map['requestNonce'],
        isSimChanged = map['isSimChanged'],
        verificationMode = map['verificationMode'],
        verificationTimestamp = map['verificationTimestamp'],
        userLocale = map['userLocale'],
        accessToken = map['accessToken'];
}

/// error that corresponds to [TcSdkCallback.error]
class TcOAuthError {
  late int code;
  late String? message;

  /// get the [TruecallerError] values from Json
  TcOAuthError.fromJson(Map<String, dynamic> map) {
    code = map['errorCode'];
    message = map['errorMessage'];
  }
}

/// exception that corresponds to [TcSdkCallback.exception]
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

class CallbackData {
  late String? otp;
  late String? ttl;
  late String? accessToken;
  late String? requestNonce;
  late String? profile;

  CallbackData.fromJson(Map<String, dynamic> map) {
    otp = map['otp'];
    ttl = map['ttl'];
    accessToken = map['accessToken'];
    requestNonce = map['requestNonce'];
    profile = map['profile'];
  }
}
