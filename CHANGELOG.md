## 0.0.1

* Flutter plugin for Truecaller SDK based on Truecaller's Android SDK 2.3.0
* Only supports Android at the moment
* Only supports verification of Truecaller users at the moment

## 0.0.2

* Flutter plugin for Truecaller SDK based on Truecaller's Android SDK 2.4.0
* Only supports Android at the moment
* Supports verification of both Truecaller and Non-Truecaller users
* TTL is now exposed to partners when OTP or Missed Call is initiated so that partners are aware of time left to complete the user verification and can take
 an appropriate action once TTL expires.
* Optional nullable Error is passed in case of **`TruecallerSdkCallbackResult.verification`** which can be used to determine user action which led to initiating
 manual verification like whether the user pressed on the `footer CTA` on the verification screen OR the `system back button`.