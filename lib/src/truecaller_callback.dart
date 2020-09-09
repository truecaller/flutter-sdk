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

class TruecallerSdkCallback {
  TruecallerSdkCallbackResult result;
  TruecallerUserProfile profile;
  TruecallerError error;
}

enum TruecallerSdkCallbackResult { success, failure, verification }

extension EnumParser on String {
  TruecallerSdkCallbackResult enumValue() {
    return TruecallerSdkCallbackResult.values.firstWhere(
        (element) => element.toString().split(".")[1].toLowerCase() == this.toLowerCase(),
        orElse: () => null);
  }
}

class TruecallerUserProfile {
  String firstName;
  String lastName;
  String phoneNumber;
  String gender;
  String street;
  String city;
  String zipcode;
  String countryCode;
  String facebookId;
  String twitterId;
  String email;
  String url;
  String avatarUrl;
  bool isTrueName;
  bool isAmbassador;
  String companyName;
  String jobTitle;
  String payload;
  String signature;
  String signatureAlgorithm;
  String requestNonce;
  bool isSimChanged;
  String verificationMode;
  int verificationTimestamp;
  String userLocale;
  String accessToken;

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

class TruecallerError {
  int code;
  String message;

  TruecallerError.fromJson(Map<String, dynamic> map) {
    code = map['mErrorType'];
    message = map['message'];
  }
}
