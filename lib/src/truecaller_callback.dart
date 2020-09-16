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
