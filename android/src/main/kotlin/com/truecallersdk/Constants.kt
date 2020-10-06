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
        const val COUNTRY_ISO = "ci"
        const val FIRST_NAME = "fname"
        const val LAST_NAME = "lname"
        const val OTP = "otp"
    }
}