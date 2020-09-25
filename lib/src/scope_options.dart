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
  /// footer options
  static const int FOOTER_TYPE_SKIP = 1;
  static const int FOOTER_TYPE_CONTINUE = 2;
  static const int FOOTER_TYPE_NONE = 64;
  static const int FOOTER_TYPE_ANOTHER_METHOD = 256;
  static const int FOOTER_TYPE_MANUALLY = 512;
  static const int FOOTER_TYPE_LATER = 4096;

  /// consent mode options
  static const int CONSENT_MODE_POPUP = 4;
  static const int CONSENT_MODE_FULLSCREEN = 8;
  static const int CONSENT_MODE_BOTTOMSHEET = 128;

  /// sdk options
  static const int SDK_OPTION_WITHOUT_OTP = 16;
  static const int SDK_OPTION_WITH_OTP = 32;

  /// title options (applicable for [CONSENT_MODE_POPUP] and [CONSENT_MODE_FULLSCREEN])
  static const int SDK_CONSENT_TITLE_LOG_IN = 0;
  static const int SDK_CONSENT_TITLE_SIGN_UP = 1;
  static const int SDK_CONSENT_TITLE_SIGN_IN = 2;
  static const int SDK_CONSENT_TITLE_VERIFY = 3;
  static const int SDK_CONSENT_TITLE_REGISTER = 4;
  static const int SDK_CONSENT_TITLE_GET_STARTED = 5;

  /// button shape options (applicable for [CONSENT_MODE_BOTTOMSHEET])
  static const int BUTTON_SHAPE_ROUNDED = 1024;
  static const int BUTTON_SHAPE_RECTANGLE = 2048;

  /// login text prefix options (applicable for [CONSENT_MODE_BOTTOMSHEET])
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

  /// login text suffix options (applicable for [CONSENT_MODE_BOTTOMSHEET])
  static const int LOGIN_TEXT_SUFFIX_PLEASE_VERIFY_MOBILE_NO = 0;
  static const int LOGIN_TEXT_SUFFIX_PLEASE_LOGIN = 1;
  static const int LOGIN_TEXT_SUFFIX_PLEASE_SIGNUP = 2;
  static const int LOGIN_TEXT_SUFFIX_PLEASE_LOGIN_SIGNUP = 3;
  static const int LOGIN_TEXT_SUFFIX_PLEASE_REGISTER = 4;
  static const int LOGIN_TEXT_SUFFIX_PLEASE_SIGN_IN = 5;

  /// button text prefix options (applicable for [CONSENT_MODE_BOTTOMSHEET])
  static const int CTA_TEXT_PREFIX_USE = 0;
  static const int CTA_TEXT_PREFIX_CONTINUE_WITH = 1;
  static const int CTA_TEXT_PREFIX_PROCEED_WITH = 2;
}
