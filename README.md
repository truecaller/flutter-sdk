# truecaller_sdk

<p align="center">
<img src="https://raw.githubusercontent.com/truecaller/flutter-sdk/tc/images/truecaller_logo.png" height="200">
</p>

Flutter plugin that uses [Truecaller's OAuth SDK for Android](https://docs.truecaller.com/truecaller-sdk/) based on OAuth 2.0 which is the industry-standard protocol for authorization.

For more details, please refer [here](https://docs.truecaller.com/truecaller-sdk/android/oauth-sdk-3.0/implementing-user-flow-for-your-app)

## Steps to integrate

### 1. Update `pubspec.yaml`:
Include the latest truecaller_sdk in your `pubspec.yaml`
```yaml
dependencies:
  ...
  truecaller_sdk: ^1.0.0
  ...
```
### 2. Generate Client Id and add it to `AndroidManifest.xml`:
* [Register](https://sdk-console-noneu.truecaller.com/) to create your business account and manage OAuth projects .
* Refer to the [official documentation](https://docs.truecaller.com/truecaller-sdk/android/oauth-sdk-3.0/integration-steps/generating-client-id) for
generating client id.
* Open your [AndroidManifest.xml](/example/android/app/src/main/AndroidManifest.xml) under /android module and add a `meta-data` element to the `application`
 element with your client id:
```xml
<application>  
...  
<activity>  
.. </activity>

<meta-data android:name="com.truecaller.android.sdk.ClientId" android:value="PASTE_YOUR_CLIENT_ID_HERE"/>
...  
</application>  
```

### 3. Make changes to `MainActivity.kt`:
* Head to the [MainActivity.kt](/example/android/app/src/main/kotlin/com/example/truecaller_sdk_example/MainActivity.kt) under /android module
* SDK requires the use of a `FragmentActivity` as opposed to `Activity`, so extend your `MainActivity.kt` with `FlutterFragmentActivity`.
* Override the two functions `configureFlutterEngine(flutterEngine: FlutterEngine)` and `getBackgroundMode()` in your `MainActivity.kt`:
```kotlin
class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    override fun getBackgroundMode(): FlutterActivityLaunchConfigs.BackgroundMode {
        return FlutterActivityLaunchConfigs.BackgroundMode.transparent
    }
}
```
* Update `launchMode` of `MainActivity.kt` to `singleTask` in `AndroidManifest.xml` :
```xml
<application>  
...  
<activity android:name=".MainActivity"
          android:launchMode="singleTask">
.. </activity>
...  
</application>  
```

### 4. Add required Permissions to `AndroidManifest.xml`:
Permissions are mandatory only if you are initializing the SDK with `TcSdkOptions.OPTION_VERIFY_ALL_USERS` in order to verify the users manually.

For Android 8 and above :
```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
<uses-permission android:name="android.permission.READ_CALL_LOG"/>
<uses-permission android:name="android.permission.ANSWER_PHONE_CALLS"/>
```

For Android 7 and below :
```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
<uses-permission android:name="android.permission.READ_CALL_LOG"/>
<uses-permission android:name="android.permission.CALL_PHONE"/>
```

These permissions are required for the SDK to be able to automatically detect the drop call and complete the verification flow.

To read more about different scenarios for user verifications, [click here](https://docs.truecaller.com/truecaller-sdk/android/oauth-sdk-3.0/scenarios-for-all-user-verifications-truecaller-and-non-truecaller-users).

## Example 1 (to verify only Truecaller users having Truecaller app on their device)

```dart

//Import package
import 'package:truecaller_sdk/truecaller_sdk.dart';

//Step 1: Initialize the SDK with OPTION_VERIFY_ONLY_TC_USERS
TcSdk.initializeSDK(sdkOption: TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS);

//Step 2: Check if SDK is usable on that device, otherwise fall back to any other login alternative
bool isUsable = await TcSdk.isOAuthFlowUsable;

//Step 3: If isUsable is true, then do the following before you can invoke the OAuth consent screen -
//3.1: Set a unique OAuth state and store that state in your session so that you can match it with the state received from the authorization server to prevent
//any request forgery attacks.
//3.2: Set the OAuth scopes that you'd want to request from the user. You can either ask all of them together or a subset of it.
//3.3: Generate a random code verifier either yourself or using the SDK method as shown below. Store the code verifier in the current session since it would
//be required later to generate the access token.
//3.4: Generate code challenge using the code verifier from the previous step
//3.5 Set the code challenge
//3.6 Finally, after setting all of the above, invoke the consent screen by calling getAuthorizationCode
TcSdk.isOAuthFlowUsable.then((isOAuthFlowUsable) {
    if (isOAuthFlowUsable) {
        oAuthState = "some_unique_uuid" //store the state to use later
        TcSdk.setOAuthState(oAuthState); //3.1
        TcSdk.setOAuthScopes(['profile', 'phone', 'openid']); //3.2
        TcSdk.generateRandomCodeVerifier.then((codeVerifier) { //3.3
            TcSdk.generateCodeChallenge(codeVerifier).then((codeChallenge) { //3.4
                if (codeChallenge != null) {
                    this.codeVerifier = codeVerifier; //store the code verifier to use later
                    TcSdk.setCodeChallenge(codeChallenge); //3.5
                    TcSdk.getAuthorizationCode; //3.6
                } else {
                    print("***Code challenge NULL. Device not supported***");
                }
            });
        });
    } else {
        print("***Not usable***");
    }
}
                   
//Step 4: Be informed about the TcSdk.getAuthorizationCode callback result(success, failure, verification)
StreamSubscription streamSubscription = TcSdk.streamCallbackData.listen((tcSdkCallback) {
  switch (tcSdkCallback.result) {
    case TcSdkCallbackResult.success:
      TcOAuthData tcOAuthData = tcSdkCallback.tcOAuthData!;
      String authorizationCode = tcOAuthData.authorizationCode; //use this along with codeVerifier generated in step 3.3 to generate an access token
      String stateReceivedFromServer = tcOAuthData.state; //match it with what you set in step 3.1
      List<dynamic> scopesGranted = tcOAuthData.scopesGranted; //list of scopes granted by the user
      break;
    case TcSdkCallbackResult.failure:
      //Handle the failure
      int errorCode = tcSdkCallback.error!.code;
      String message = tcSdkCallback.error!.message;
      break;
    case TcSdkCallbackResult.verification:
    // won't receive this callback if initializing SDK with sdkOption as TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS
      print("Verification Required!!");
      break;
    default:
      print("Invalid result");
  }
});

//Step 5: Dispose streamSubscription
@override
void dispose() {
  streamSubscription?.cancel();
  super.dispose();
}
```

//Step 4a
Using the “code verifier” from step 3.3, and the “authorization code” received in success callback of step 4, you need to make a network call to
Truecaller’s backend so as to [fetch the access token](https://docs.truecaller.com/truecaller-sdk/android/oauth-sdk-3.0/integration-steps/integrating-with-your-backend/fetching-user-token)

//Step 4b
Make a network call to [fetch the userInfo](https://docs.truecaller.com/truecaller-sdk/android/oauth-sdk-3.0/integration-steps/integrating-with-your-backend/fetching-user-profile) using access token from step 4a. The response would be corresponding to the scopes granted by the user.

## Example 2 (to verify both Truecaller users (Example 1) and non-Truecaller users via manual verification)

```dart

//Import package
import 'package:truecaller_sdk/truecaller_sdk.dart';

//Step 1: Initialize the SDK with SDK_OPTION_WITH_OTP
TcSdk.initializeSDK(sdkOption: TcSdkOptions.OPTION_VERIFY_ALL_USERS);

//Follow steps 2 and 3 from Example 1

//Step 4: Be informed about the TcSdk.getAuthorizationCode callback result(success, failure, verification)
StreamSubscription streamSubscription = TcSdk.streamCallbackData.listen((tcSdkCallback) {
  switch (tcSdkCallback.result) {
    case TcSdkCallbackResult.success:
      TcOAuthData tcOAuthData = tcSdkCallback.tcOAuthData!;
      String authorizationCode = tcOAuthData.authorizationCode; // use this along with codeVerifier generated in step 3.3 to generate an access token
      String stateReceivedFromServer = tcOAuthData.state; // match it with what you set in step 3.1
      List<dynamic> scopesGranted = tcOAuthData.scopesGranted;
      break;
    case TcSdkCallbackResult.failure:
      //Handle the failure
      int errorCode = tcSdkCallback.error!.code;
      String message = tcSdkCallback.error!.message;
      break;
    case TcSdkCallbackResult.verification:
      //If the callback comes here, it indicates that user has to be manually verified, so follow step 5
      //You'd receive nullable error which can be used to determine user action that led to manual verification
      int errorCode = tcSdkCallback.error!.code;
      String message = tcSdkCallback.error!.message;
      print("Verification Required!!");
      break;
    default:
      print("Invalid result");
  }
});

//Step 5: Initiate manual verification by asking user for his number only if you receive callback result as
//TcSdkCallbackResult.verification in the previous step.
//Please ensure proper validations are in place so as to send a valid phone number string to the below method,
//otherwise an exception would be thrown.
//Also, request the required permissions from the user and ensure they are granted before calling this method.
TcSdk.requestVerification(phoneNumber: "PHONE_NUMBER");

//Step 6: Be informed about the TcSdk.requestVerification callback result via [streamCallbackData] stream
//result could be either of (missedCallInitiated, missedCallReceived, otpInitiated, otpReceived, 
//verifiedBefore, verificationComplete, exception)
StreamSubscription streamSubscription = TcSdk.streamCallbackData.listen((tcSdkCallback) {
  switch (tcSdkCallback.result) {
    case TcSdkCallbackResult.missedCallInitiated:
      //Number Verification would happen via Missed call, so you can show a loader till you receive the call
      //You'd also receive ttl (in seconds) that determines time left to complete the user verification
      //Once TTL expires, you need to start from step 5. So you can either ask the user to input another number
      //or you can also auto-retry the verification on the same number by giving a retry button
      String? ttl = tcSdkCallback.ttl;
      //You'd also receive a request nonce whose value would be same as the State that you set in step 3.1
      String requestNonce = tcSdkCallback.requestNonce;
      break;
    case TcSdkCallbackResult.missedCallReceived:
      //Missed call received and now you can complete the verification as mentioned in step 7a
      break;
    case TcSdkCallbackResult.otpInitiated:
      //Number Verification would happen via OTP
      //You'd also receive ttl (in seconds) that determines time left to complete the user verification
      //Once TTL expires, you need to start from step 5. So you can either ask the user to input another number
      //or you can also auto-retry the verification on the same number by giving a retry button
      String? ttl = tcSdkCallback.ttl;
      //You'd also receive a request nonce whose value would be same as the State that you set in step 3.1
      String requestNonce = tcSdkCallback.requestNonce;
      break;
    case TcSdkCallbackResult.otpReceived:
      //OTP received and now you can complete the verification as mentioned in step 7b
      //If SMS Retriever hashcode is configured on Truecaller's developer dashboard, get the OTP from callback
      String? otp = tcSdkCallback.otp;
      break;
    case TcSdkCallbackResult.verificationComplete:
      //Number verification has been completed successfully and you can get the accessToken from callback
      String? token = tcSdkCallback.accessToken;
      //You'd also receive a request nonce whose value would be same as the State that you set in step 3.1
      String requestNonce = tcSdkCallback.requestNonce;
      break;
    case TcSdkCallbackResult.verifiedBefore:
      //Number has already been verified before, hence no need to verify. Retrieve the Profile data from callback
      String firstName = tcSdkCallback.profile!.firstName;
      String? lastName = tcSdkCallback.profile!.lastName;
      String phNo = tcSdkCallback.profile!.phoneNumber;
      String? token = tcSdkCallback.profile!.accessToken;
      //You'd also receive a request nonce whose value would be same as the State that you set in step 3.1
      String requestNonce = tcSdkCallback.profile!.requestNonce;
      break;
    case TcSdkCallbackResult.exception:
      //Handle the exception
      int exceptionCode = tcSdkCallback.exception!.code;
      String exceptionMsg = tcSdkCallback.exception!.message;
      break;
    default:
      print("Invalid result");
  }
});

//Step 7: Complete user verification
//7a: If Missed call has been received successfully, i.e. if you received callback result as
// TcSdkCallbackResult.missedCallReceived in the previous step call this method with user's name
TcSdk.verifyMissedCall(firstName: "FIRST_NAME", lastName: "LAST_NAME");

//7b: If OTP has been initiated, show user an input OTP screen where they can enter the OTP.
//If the OTP is received on the same device, and you've configured the SMS Retriever, you can prefill the OTP which
//you'd receive if the callback result is TcSdkCallbackResult.otpReceived, and call this method with user's name
//Otherwise, if OTP is not auto-read or if the OTP is received on any other device, call this method with the user's name
//and OTP entered by the user.
TcSdk.verifyOtp(firstName: "FIRST_NAME", lastName: "LAST_NAME", otp: "OTP");

//Step 7: Dispose streamSubscription
@override
void dispose() {
  streamSubscription?.cancel();
  super.dispose();
}
```

As mentioned in Step 6 above, when `TcSdkCallbackResult` equals `TcSdkCallbackResult.missedCallInitiated` or `TcSdkCallbackResult.otpInitiated`, you will receive an additional parameter for the time to live i.e TTL (in seconds) which is passed as String extra and can be retrieved from
the callback using `tcSdkCallback.ttl`. This value determines amount of time left to complete the user verification. You can use this value to show
a waiting message to your user before they can retry for another attempt i.e fresh verification for same number cannot be re-initiated till the TTL expires.
Once the TTL expires, you need to start the verification process again from step 5.

##### NOTE #####
* For details on different kinds of errorCodes, refer [here](https://docs.truecaller.com/truecaller-sdk/android/oauth-sdk-3.0/integration-steps/handling-error-scenarios).
* For details on different kinds of exceptions, refer [here](https://docs.truecaller.com/truecaller-sdk/android/oauth-sdk-3.0/integration-steps/non-truecaller-user-verification/trueexception).
* For details on Server Side Response Validation, refer [here](https://docs.truecaller.com/truecaller-sdk/android/oauth-sdk-3.0/integration-steps/non-truecaller-user-verification/server-side-validation).
* For sample implementations, head over to [example](example) module.

## Customization Options

### Language
To customise the consent screen in any of the supported Indian languages, add the following line before calling `TcSdk.getAuthorizationCode`:
```dart
/// initialize the SDK and check isUsable first before calling this method
/// Default value is "en" i.e English
TcSdk.setLocale("hi") // this sets the language to Hindi
```

### Consent screen UI
You can customize the consent screen UI using the options available in class `TcSdkOptions` under `scope_options.dart` and pass them while initializing the SDK.

```dart
  /// [sdkOption] determines whether you want to use the SDK for verifying -
  /// 1. [TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS] i.e only Truecaller users
  /// 2. [TcSdkOptions.OPTION_VERIFY_ALL_USERS] i.e both Truecaller and Non-Truecaller users
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
            int? buttonTextColor})
```

By default, `initializeSDK()` has default argument values for all the arguments except the `sdkOption` which is a required argument, so if you
 don't pass any explicit values to the other arguments, this method will initialize the SDK with default values as above.

##### Note
For list of supported locales and details on different kinds of customizations, refer [here](https://docs.truecaller.com/truecaller-sdk/android/oauth-sdk-3.0/integration-steps/customisation)

##### Support
For any technical/flow related questions, please feel free to reach out via our [support channel](https://developer.truecaller.com/support) for a fast and dedicated response.

## License

[`truecaller_sdk` is MIT-licensed](LICENSE).
