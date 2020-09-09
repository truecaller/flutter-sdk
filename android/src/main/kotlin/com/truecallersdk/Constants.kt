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
        const val SUCCESS = "success"
        const val FAILURE = "failure"
        const val VERIFICATION = "verification"
    }
}