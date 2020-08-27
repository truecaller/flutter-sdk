# truecaller_sdk

Flutter plugin that uses [Truecaller's Android SDK](https://docs.truecaller.com/truecaller-sdk/) to provide mobile number verification service to verify Truecaller users.

This plugin currently supports **only Android** and can be used to verify **only the Truecaller users** at the moment. Since these users have already verified mobile number, verification via Truecaller SDK enables you to quickly verify/signup/login your users using their mobile number - without the need for SMS based OTP, and at the time same lets you capture their mapped user profile.

For more details, please refer [here](https://docs.truecaller.com/truecaller-sdk/android/implementing-user-flow-for-your-app)

## Steps to integrate

### 1. Update `pubspec.yaml`:
Include the latest truecaller_sdk in your `pubspec.yaml`
```yaml
dependencies:
  ...
  truecaller_sdk: ^0.0.1
  ...
```
### 2. Generate App key and add it to `AndroidManifest.xml`:
* [Register](https://developer.truecaller.com/sign-up) for Truecaller's developer account, or [login](https://developer.truecaller.com/login) to your existing developer account.
* Refer to the [official documentation](https://docs.truecaller.com/truecaller-sdk/android/generating-app-key) for generating app key.
* Open your `AndroidManifest.xml` under /android module and add a `meta-data` element to the `application` element with your app key:
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
* Head to the `MainActivity.kt` under /android module
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

## Example

```dart
// Import package
import 'package:truecaller_sdk/truecaller_sdk.dart';

//Step 1: Initialize the SDK
TruecallerSdk.initializeSDK();

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
    super.dispose();
    if (streamSubscription != null) {
      streamSubscription.cancel();
    }
  }
```

##### NOTE #####
* For details on different kinds of errorCodes, refer [here](https://docs.truecaller.com/truecaller-sdk/android/integrating-with-your-app/handling-error-scenarios).
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
          {int sdkOptions: TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP,
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

By default, `initializeSDK()` has default argument values set as above, so if you don't pass any explicit values to it, it will initialize the SDK with these scope options.

##### Note
For list of supported locales and details on different kinds of customizations, refer [here](https://docs.truecaller.com/truecaller-sdk/android/integrating-with-your-app/customisation-1)
