# truecaller_sdk

<p align="center">
<img src="https://raw.githubusercontent.com/truecaller/flutter-sdk/tc/images/truecaller_logo.png" height="200">
</p>

Flutter plugin that uses [Truecaller's Android SDK](https://docs.truecaller.com/truecaller-sdk/) to provide mobile number verification service to verify Truecaller users.

This plugin currently supports **only Android** at the moment. **v0.0.2 & above** will allow you to verify both Truecaller as well as non-Truecaller users on your application. (**v0.0.1** only allows you to verify users who have Truecaller Android app on their device and are logged-in).
Verification via Truecaller SDK enables you to quickly verify/signup/login your users using their mobile number.

For more details, please refer [here](https://docs.truecaller.com/truecaller-sdk/android/implementing-user-flow-for-your-app)

## Steps to integrate

### 1. Update `pubspec.yaml`:
Include the latest truecaller_sdk in your `pubspec.yaml`
```yaml
dependencies:
  ...
  truecaller_sdk: ^0.0.2
  ...
```
### 2. Generate App key and add it to `AndroidManifest.xml`:
* [Register](https://developer.truecaller.com/sign-up) for Truecaller's developer account, or [login](https://developer.truecaller.com/login) to your existing developer account.
* Refer to the [official documentation](https://docs.truecaller.com/truecaller-sdk/android/generating-app-key) for generating app key.
* Open your [AndroidManifest.xml](/example/android/app/src/main/AndroidManifest.xml) under /android module and add a `meta-data` element to the `application` element with your app key:
```xml
<application>  
...  
<activity>  
.. </activity>

<meta-data android:name="com.truecaller.android.sdk.PartnerKey" android:value="PASTE_YOUR_PARTNER_KEY_HERE"/>  
...  
</application>  
```

### 3. Make changes to `MainActivity.kt`:
* Head to the [MainActivity.kt](/example/android/app/src/main/kotlin/com/example/truecaller_sdk_example/MainActivity.kt) under /android module
* SDK requires the use of a `FragmentActivity` as opposed to `Activity`, so extend your `MainActivity.kt` with `FlutterFragmentActivity`.
* Override function `configureFlutterEngine(flutterEngine: FlutterEngine)` in your `MainActivity.kt`:
```kotlin
class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
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
Permissions are mandatory only if you are initializing the SDK with `TruecallerSdkScope.SDK_OPTION_WITH_OTP` in order to verify the non-Truecaller users.

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

To read more about different scenarios for user verifications, [click here](https://docs.truecaller.com/truecaller-sdk/android/user-flows-for-verification-truecaller-+-non-truecaller-users).

## Example 1 (to verify only Truecaller users having Truecaller app on their device)

```dart
// This Example is valid for truecaller_sdk 0.0.1 onwards 

//Import package
import 'package:truecaller_sdk/truecaller_sdk.dart';

//Step 1: Initialize the SDK with SDK_OPTION_WITHOUT_OTP
TruecallerSdk.initializeSDK(sdkOptions: TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP);

//Step 2: Check if SDK is usable
bool isUsable = await TruecallerSdk.isUsable;

//Step 3: If isUsable is true, you can call getProfile to show consent screen to verify user's number
isUsable ? TruecallerSdk.getProfile : print("***Not usable***");

//OR you can also replace Step 2 and Step 3 directly with this  
TruecallerSdk.isUsable.then((isUsable) {
 isUsable ? TruecallerSdk.getProfile : print("***Not usable***");
});
                   
//Step 4: Be informed about the TruecallerSdk.getProfile callback result(success, failure, verification)
StreamSubscription streamSubscription = TruecallerSdk.streamCallbackData.listen((truecallerSdkCallback) {
  switch (truecallerSdkCallback.result) {
    case TruecallerSdkCallbackResult.success:
      print("First Name: ${truecallerSdkCallback.profile.firstName}");
      print("Last Name: ${truecallerSdkCallback.profile.lastName}");
      break;
    case TruecallerSdkCallbackResult.failure:
      print("Error code : ${truecallerSdkCallback.error.code}");
      break;
    case TruecallerSdkCallbackResult.verification:
      print("Verification Required!!");
      break;
    default:
      print("Invalid result");
  }
});

//Step 5: Dispose streamSubscription
@override
void dispose() {
  if (streamSubscription != null) {
    streamSubscription.cancel();
  }
  super.dispose();
}
```

## Example 2 (to verify both Truecaller users (Example 1) and non-Truecaller users via manual verification)

```dart
// This Example is valid for truecaller_sdk 0.0.2 onwards 

//Import package
import 'package:truecaller_sdk/truecaller_sdk.dart';

//Step 1: Initialize the SDK with SDK_OPTION_WITH_OTP
TruecallerSdk.initializeSDK(sdkOptions: TruecallerSdkScope.SDK_OPTION_WITH_OTP);

//Step 2: Call getProfile to show consent screen to verify user's number
//NOTE: isUsable will always return TRUE when using SDK_OPTION_WITH_OTP, so you can also call
//getProfile directly
TruecallerSdk.isUsable.then((isUsable) {
 isUsable ? TruecallerSdk.getProfile : print("***Not usable***");
});
                   
//Step 3: Be informed about the TruecallerSdk.getProfile callback result via [streamCallbackData] stream 
//result could be either of (success, failure, verification)
StreamSubscription streamSubscription = TruecallerSdk.streamCallbackData.listen((truecallerSdkCallback) {
  switch (truecallerSdkCallback.result) {
    case TruecallerSdkCallbackResult.success:
    //If Truecaller user and has Truecaller app on his device, you'd directly get the Profile
      print("First Name: ${truecallerSdkCallback.profile.firstName}");
      print("Last Name: ${truecallerSdkCallback.profile.lastName}");
      break;
    case TruecallerSdkCallbackResult.failure:
      print("Error code : ${truecallerSdkCallback.error.code}");
      break;
    case TruecallerSdkCallbackResult.verification:
      //If the callback comes here, it indicates that user has to be manually verified, so follow step 4
      //You'd receive nullable error which can be used to determine user action that led to verification 
      print("Manual Verification Required!! ${truecallerSdkCallback.error != null ? 
            truecallerSdkCallback.error.code : ""}");
      break;
    default:
      print("Invalid result");
  }
});

//Step 4: Initiate manual verification by asking user for his number
TruecallerSdk.requestVerification(phoneNumber: "PHONE_NUMBER");

//Step 5: Be informed about the TruecallerSdk.requestVerification callback result via [streamCallbackData] stream
//result could be either of (missedCallInitiated, missedCallReceived, otpInitiated, otpReceived, 
//verifiedBefore, verificationComplete, exception)
StreamSubscription streamSubscription = TruecallerSdk.streamCallbackData.listen((truecallerSdkCallback) {
  switch (truecallerSdkCallback.result) {
    case TruecallerSdkCallbackResult.missedCallInitiated:
      //Number Verification would happen via Missed call, so you can show a loader till you receive the call
      //You'd also receive ttl (in seconds) that determines time left to complete the user verification
      //Once TTL expires, you need to start from step 4. So you can either ask the user to input another number
      //or you can also auto-retry the verification on the same number by giving a retry button
      print("${truecallerUserCallback.ttl}");
      break;
    case TruecallerSdkCallbackResult.missedCallReceived:
      //Missed call received and now you can complete the verification as mentioned in step 6a
      break;
    case TruecallerSdkCallbackResult.otpInitiated:
      //Number Verification would happen via OTP
      //You'd also receive ttl (in seconds) that determines time left to complete the user verification
      //Once TTL expires, you need to start from step 4. So you can either ask the user to input another number
      //or you can also auto-retry the verification on the same number by giving a retry button
      print("${truecallerUserCallback.ttl}");
      break;
    case TruecallerSdkCallbackResult.otpReceived:
      //OTP received and now you can complete the verification as mentioned in step 6b
      //If SMS Retriever hashcode is configured on Truecaller's developer dashboard, get the OTP from callback
      print("${truecallerUserCallback.otp}");
      break;
    case TruecallerSdkCallbackResult.verificationComplete:
      //Number verification has been completed successfully and you can get the accessToken from callback
      print("${truecallerUserCallback.accessToken}");
      break;
    case TruecallerSdkCallbackResult.verifiedBefore:
      //Number has already been verified before, hence no need to verify. Retrieve the Profile data from callback
      print("${truecallerUserCallback.profile.firstName}");
      print("${truecallerUserCallback.profile.lastName}");
      print("${truecallerUserCallback.profile.accessToken}");
      break;
    case TruecallerSdkCallbackResult.exception:
      //Handle the exception
      print("${truecallerUserCallback.exception.code}, ${truecallerUserCallback.exception.message}");
      break;
    default:
      print("Invalid result");
  }
});

//Step 6: Complete user verification
//6a: If Missed call has been received on the same device, call this method with user's name
TruecallerSdk.verifyMissedCall("FIRST_NAME", "LAST_NAME");

//6b: If OTP has been initiated OR received on any device, call this method with the user's name & OTP received
TruecallerSdk.verifyOtp("FIRST_NAME", "LAST_NAME", "OTP");

//Step 7: Dispose streamSubscription
@override
void dispose() {
  if (streamSubscription != null) {
    streamSubscription.cancel();
  }
  super.dispose();
}
```

##### NOTE #####
* For details on different kinds of errorCodes, refer [here](https://docs.truecaller.com/truecaller-sdk/android/integrating-with-your-app/handling-error-scenarios).
* For details on different kinds of exceptions, refer [here](https://docs.truecaller.com/truecaller-sdk/android/integrating-with-your-app/verifying-non-truecaller-users/verificationcallback).
* For details on Server Side Response Validation, refer [here](https://docs.truecaller.com/truecaller-sdk/android/server-side-response-validation).
* For sample implementations, head over to [example](example) module.

## Customization Options

### Language
To customise the profile consent screen in any of the supported Indian languages, add the following line before calling `TruecallerSdk.getProfile`:
```dart
/// initialize the SDK and check isUsable first before calling this method
/// Default value is "en" i.e English
TruecallerSdk.setLocale("hi") // this sets the language to Hindi
```

### Dark Theme
You can also set the Dark Theme for consent screen by adding the following line before calling `TruecallerSdk.getProfile`:
```dart
/// initialize the SDK and check isUsable first before calling this method
TruecallerSdk.setDarkTheme 
```

##### Note
Dark Theme is not applicable for `TruecallerSdkScope.CONSENT_MODE_BOTTOMSHEET`

### Consent screen UI
You can customize the consent screen UI using the options available in class `TruecallerSdkScope` under `scope_options.dart` and pass them while initializing the SDK.

```dart
  /// [sdkOptions] determines whether you want to use the SDK for verifying - 
  /// 1. [TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP] i.e only Truecaller users
  /// 2. [TruecallerSdkScope.SDK_OPTION_WITH_OTP] i.e both Truecaller and Non-Truecaller users
  ///
  /// NOTE: In truecaller_sdk 0.0.1, only
  /// [TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP] is supported
  /// In truecaller_sdk 0.0.2 and onwards, both
  /// [TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP] and [TruecallerSdkScope.SDK_OPTION_WITH_OTP] are supported
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
          int buttonTextColor})
```

By default, `initializeSDK()` has default argument values for all the arguments except the `sdkOptions` which is a required argument, so if you
 don't pass any explicit values to the other arguments, this method will initialize the SDK with default values as above.

##### Note
For list of supported locales and details on different kinds of customizations, refer [here](https://docs.truecaller.com/truecaller-sdk/android/integrating-with-your-app/customisation-1)


## License

[`truecaller_sdk` is MIT-licensed](LICENSE).
