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

/// scope options that are used to customize the consent screen UI
class TruecallerSdkScope {
  static const int FOOTER_TYPE_SKIP = 1;
  static const int FOOTER_TYPE_ANOTHER_MOBILE_NO = 2;
  static const int FOOTER_TYPE_ANOTHER_METHOD = 4;
  static const int FOOTER_TYPE_MANUALLY = 8;
  static const int FOOTER_TYPE_LATER = 16;
  static const int OPTION_VERIFY_ONLY_TC_USERS = 32;
  static const int OPTION_VERIFY_ALL_USERS = 64;
  static const int BUTTON_SHAPE_ROUNDED = 128;
  static const int BUTTON_SHAPE_RECTANGLE = 256;
  static const int SDK_CONSENT_HEADING_LOG_IN_TO = 0;
  static const int SDK_CONSENT_HEADING_SIGN_UP_WITH = 1;
  static const int SDK_CONSENT_HEADING_SIGN_IN_TO = 2;
  static const int SDK_CONSENT_HEADING_VERIFY_NUMBER_WITH = 3;
  static const int SDK_CONSENT_HEADING_REGISTER_WITH = 4;
  static const int SDK_CONSENT_HEADING_GET_STARTED_WITH = 5;
  static const int SDK_CONSENT_HEADING_PROCEED_WITH = 6;
  static const int SDK_CONSENT_HEADING_VERIFY_WITH = 7;
  static const int SDK_CONSENT_HEADING_VERIFY_PROFILE_WITH = 8;
  static const int SDK_CONSENT_HEADING_VERIFY_YOUR_PROFILE_WITH = 9;
  static const int SDK_CONSENT_HEADING_VERIFY_PHONE_NO_WITH = 10;
  static const int SDK_CONSENT_HEADING_VERIFY_YOUR_NO_WITH = 11;
  static const int SDK_CONSENT_HEADING_CONTINUE_WITH = 12;
  static const int SDK_CONSENT_HEADING_COMPLETE_ORDER_WITH = 13;
  static const int SDK_CONSENT_HEADING_PLACE_ORDER_WITH = 14;
  static const int SDK_CONSENT_HEADING_COMPLETE_BOOKING_WITH = 15;
  static const int SDK_CONSENT_HEADING_CHECKOUT_WITH = 16;
  static const int SDK_CONSENT_HEADING_MANAGE_DETAILS_WITH = 17;
  static const int SDK_CONSENT_HEADING_MANAGE_YOUR_DETAILS_WITH = 18;
  static const int SDK_CONSENT_HEADING_LOGIN_TO_WITH_ONE_TAP = 19;
  static const int SDK_CONSENT_HEADING_SUBSCRIBE_TO = 20;
  static const int SDK_CONSENT_HEADING_GET_UPDATES_FROM = 21;
  static const int SDK_CONSENT_HEADING_CONTINUE_READING_ON = 22;
  static const int SDK_CONSENT_HEADING_GET_NEW_UPDATES_FROM = 23;
  static const int SDK_CONSENT_HEADING_LOGIN_SIGNUP_WITH = 24;
  static const int LOGIN_TEXT_PREFIX_TO_GET_STARTED = 0;
  static const int LOGIN_TEXT_PREFIX_TO_CONTINUE = 1;
  static const int LOGIN_TEXT_PREFIX_TO_PLACE_ORDER = 2;
  static const int LOGIN_TEXT_PREFIX_TO_COMPLETE_YOUR_PURCHASE = 3;
  static const int LOGIN_TEXT_PREFIX_TO_CHECKOUT = 4;
  static const int LOGIN_TEXT_PREFIX_TO_COMPLETE_YOUR_BOOKING = 5;
  static const int LOGIN_TEXT_PREFIX_TO_PROCEED_WITH_YOUR_BOOKING = 6;
  static const int LOGIN_TEXT_PREFIX_TO_CONTINUE_WITH_YOUR_BOOKING = 7;
  static const int LOGIN_TEXT_PREFIX_TO_GET_DETAILS = 8;
  static const int LOGIN_TEXT_PREFIX_TO_VIEW_MORE = 9;
  static const int LOGIN_TEXT_PREFIX_TO_CONTINUE_READING = 10;
  static const int LOGIN_TEXT_PREFIX_TO_PROCEED = 11;
  static const int LOGIN_TEXT_PREFIX_FOR_NEW_UPDATES = 12;
  static const int LOGIN_TEXT_PREFIX_TO_GET_UPDATES = 13;
  static const int LOGIN_TEXT_PREFIX_TO_SUBSCRIBE = 14;
  static const int LOGIN_TEXT_PREFIX_TO_SUBSCRIBE_AND_GET_UPDATES = 15;
  static const int CTA_TEXT_PROCEED = 0;
  static const int CTA_TEXT_CONTINUE = 1;
  static const int CTA_TEXT_ACCEPT = 2;
  static const int CTA_TEXT_CONFIRM = 3;
}
