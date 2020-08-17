class TruecallerUserCallback {
  TruecallerUserCallbackResult result;
  TruecallerUserProfile profile;
  TruecallerError error;
}

enum TruecallerUserCallbackResult { success, failure, verification, missedCallInitiated,
  missedCallReceived, otpInitiated, otpReceived, verifiedBefore, verificationComplete, exception}

extension EnumParser on String {
  TruecallerUserCallbackResult enumValue() {
    return TruecallerUserCallbackResult.values.firstWhere(
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
