package com.truecallersdk

class Constants {
    companion object {
        //scope options
        const val SDK_OPTION = "sdkOptions";
        const val CONSENT_MODE = "consentMode";
        const val CONSENT_TITLE = "consentTitleOptions";
        const val FOOTER_TYPE = "footerType";
        const val LOGIN_TEXT_PRE = "loginTextPrefix";
        const val LOGIN_TEXT_SUF = "loginTextSuffix";
        const val CTA_TEXT_PRE = "ctaTextPrefix";
        const val PP_URL = "privacyPolicyUrl";
        const val TOS_URL = "termsOfServiceUrl";
        const val BTN_SHAPE = "buttonShapeOptions";
        const val BTN_CLR = "buttonColor";
        const val BTN_TXT_CLR = "buttonTextColor";
        const val LOCALE = "locale";

        //callback data
        const val RESULT = "result";
        const val DATA = "data";

        //tc callback
        const val SUCCESS = "success"
        const val FAILURE = "failure"
        const val VERIFICATION = "verification"

        //non-tc callback
        const val MISSED_CALL_INITIATED = "missedCallInitiated"
        const val MISSED_CALL_RECEIVED = "missedCallReceived"
        const val OTP_INITIATED = "otpInitiated"
        const val OTP_RECEIVED = "otpReceived"
        const val VERIFIED_BEFORE = "verifiedBefore"
        const val VERIFICATION_COMPLETE = "verificationComplete"
        const val EXCEPTION = "exception"

        //non-tc values
        const val PH_NO = "ph"
        const val FIRST_NAME = "fname"
        const val LAST_NAME = "lname"
        const val OTP = "otp"
    }
}