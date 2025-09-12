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

import 'package:flutter/material.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';

class HeadingOption {
  static List<String> getHeadingOptions() {
    return [
      "Login",
      "Signup",
      "Signin",
      "Verify",
      "Register",
      "Get Started",
      "Proceed with",
      "Verify with",
      "Verify profile with",
      "Verify your profile with",
      "Verify phone number with",
      "Verify your number with",
      "Continue with",
      "Complete order with",
      "Place order with",
      "Complete booking with",
      "Checkout with",
      "Manage details with",
      "Manage your details with",
      "Login to %s with one tap",
      "Subscribe to",
      "Get updates from",
      "Continue reading on",
      "Get new updates from",
      "Login/Signup with"
    ];
  }
}

class FooterOption {
  String name;

  FooterOption(this.name);

  static Map<int, String> getFooterOptionsMap() {
    return {
      TcSdkOptions.FOOTER_TYPE_ANOTHER_MOBILE_NO: "Use Another Number",
      TcSdkOptions.FOOTER_TYPE_ANOTHER_METHOD: "Use Another Method",
      TcSdkOptions.FOOTER_TYPE_MANUALLY: "Enter Details Manually",
      TcSdkOptions.FOOTER_TYPE_LATER: "I'll do later",
      TcSdkOptions.FOOTER_TYPE_SKIP: "Skip",
    };
  }
}

class ConfigOptions {
  static Map<String, int> getColorList() {
    return {
      "green": Colors.green.toARGB32(),
      "white": Colors.white.toARGB32(),
      "red": Colors.red.toARGB32(),
      "blue": Colors.blue.toARGB32(),
      "black": Colors.black.toARGB32(),
      "grey": Colors.grey.toARGB32(),
      "cyan": Colors.cyan.toARGB32(),
      "brown": Colors.brown.toARGB32(),
      "yellow": Colors.yellow.toARGB32(),
      "lime": Colors.lime.toARGB32(),
      "purple": Colors.purple.toARGB32(),
      "pink": Colors.pink.toARGB32(),
      "deepOrange": Colors.deepOrange.toARGB32(),
      "indigo": Colors.indigo.toARGB32(),
      "teal": Colors.teal.toARGB32(),
    };
  }

  static List<String> getCtaPrefixOptions() {
    return [
      "Proceed",
      "Continue",
      "Accept",
      "Confirm",
      "Use %s",
      "Continue with %s",
      "Proceed with %s"
    ];
  }
}

class DismissOptions {
  static Map<String, int> getDismissOptions() {
    return {
      "None": 0,
      "Secondary cta border": TcSdkOptions.DISMISS_OPTION_SECONDARY_CTA_BORDER,
      "Cross button": TcSdkOptions.DISMISS_OPTION_CROSS_BUTTON,
    };
  }
}

class AccessTokenHelper {
  final TcOAuthData tcOAuthData;
  final String codeVerifier;

  AccessTokenHelper(this.tcOAuthData, this.codeVerifier);
}
