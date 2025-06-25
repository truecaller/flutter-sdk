## 1.0.1

* Update Android Gradle Plugin (AGP) and Kotlin Gradle Plugin (KGP) to versions 8.8.2 and 2.0.21, respectively.
* The compileSdk and targetSdk updated to version 35.
* Fix the namespace issue.
* Migrate to Flutter's v2 embedding due to the removal of PluginRegistry.Registrar
* Migrate to the Plugin DSL for Flutter's Gradle plugins

## 1.0.0

#### Breaking change

* Flutter plugin supporting OAuth flow and manual verification flow.
* Based on Truecaller's OAuth SDK for Android version [3.0.0](https://docs.truecaller.com/truecaller-sdk/android/oauth-sdk-3.0)

## 0.1.2

* Updated Flutter channel to stable version 3.3.0
* Updated Android Gradle Plugin to 7.2.2 and Kotlin to 1.7.0
* Fixed a bug related to type mismatch

## 0.1.1

* Flutter plugin for Truecaller SDK based on Truecaller's Android SDK 2.7.0
* TruecallerSdk.requestVerification() would now throw a PlatformException in case an invalid number is supplied to it.

## 0.1.0

* Migrated the plugin and example to support null safety

## 0.0.4

* Flutter plugin for Truecaller SDK based on Truecaller's Android SDK 2.6.0
* More optimisations, bug fixes and support for targetSdkVersion 30

## 0.0.3

* Flutter plugin for Truecaller SDK based on Truecaller's Android SDK 2.5.0
* A new error with code = 15 has been added to handle a rare device specific ActivityNotFound Exception
* Enhanced the plugin to automatically clear the resources taken up by SDK when its no longer needed to save memory
* Updated name validations to handle common scenarios during `non-truecaller verification` flow.
  The first name and last name values to be passed need to follow below mentioned rules :
    - The strings need to contains at least 1 alphabet, and cannot be completely comprised of numbers or special characters
    - String length should be less than 128 characters
    - First name is a mandatory field, last name can be empty (but non-nullable)
* Time out exceptions have been removed for OTP and Missed Call from `non-truecaller verification` flow. Use TTL value returned by the stream callback to
handle the time out logic at your own end which can be retrieved from `TruecallerUserCallback.ttl` when `TruecallerSdkCallback.result` equals
`TruecallerSdkCallbackResult.missedCallInitiated` or `TruecallerSdkCallbackResult.otpInitiated`. This means that as soon as you initiate the number
verification flow by OTP or Missed call, you will receive a TTL value which you can use appropriately to show a countdown timer and once it expires you
need to restart the verification process.

## 0.0.2

* Flutter plugin for Truecaller SDK based on Truecaller's Android SDK 2.4.0
* Only supports Android at the moment
* Supports verification of both Truecaller and Non-Truecaller users
* TTL is now exposed to partners when OTP or Missed Call is initiated so that partners are aware of time left to complete the user verification and can take
 an appropriate action once TTL expires.
* Optional nullable Error is passed in case of **`TruecallerSdkCallbackResult.verification`** which can be used to determine user action which led to initiating
 manual verification like whether the user pressed on the `footer CTA` on the verification screen OR the `system back button`.

 ## 0.0.1

 * Flutter plugin for Truecaller SDK based on Truecaller's Android SDK 2.3.0
 * Only supports Android at the moment
 * Only supports verification of Truecaller users at the moment