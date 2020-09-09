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

import 'package:flutter/material.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';

class TitleOption {
  String name;

  TitleOption(this.name);

  static List<TitleOption> getTitleOptions() {
    return <TitleOption>[
      TitleOption("Login"),
      TitleOption("Signup"),
      TitleOption("Signin"),
      TitleOption("Verify"),
      TitleOption("Register"),
      TitleOption("Get Started")
    ];
  }
}

class FooterOption {
  String name;

  FooterOption(this.name);

  static Map<int, String> getFooterOptionsMap() {
    return {
      TruecallerSdkScope.FOOTER_TYPE_SKIP: "Skip",
      TruecallerSdkScope.FOOTER_TYPE_CONTINUE: "Use Another Number",
      TruecallerSdkScope.FOOTER_TYPE_ANOTHER_METHOD: "Use Another Method",
      TruecallerSdkScope.FOOTER_TYPE_MANUALLY: "Enter Details Manually",
      TruecallerSdkScope.FOOTER_TYPE_LATER: "I'll do later",
      TruecallerSdkScope.FOOTER_TYPE_NONE: "None"
    };
  }
}

class ConfigOptions {
  static Map<String, int> getColorList() {
    return {
      "green": Colors.green.value,
      "white": Colors.white.value,
      "red": Colors.red.value,
      "blue": Colors.blue.value,
      "black": Colors.black.value,
      "grey": Colors.grey.value,
      "cyan": Colors.cyan.value,
      "brown": Colors.brown.value,
      "yellow": Colors.yellow.value,
      "lime": Colors.lime.value,
      "purple": Colors.purple.value,
      "pink": Colors.pink.value,
      "deepOrange": Colors.deepOrange.value,
      "indigo": Colors.indigo.value,
      "teal": Colors.teal.value,
    };
  }

  static List<String> getCtaPrefixOptions() {
    return ["Use %s", "Continue with %s", "Proceed with %s"];
  }

  static List<String> getLoginPrefixOptions() {
    return [
      "To get started",
      "To continue",
      "To place order",
      "To complete your purchase",
      "To checkout",
      "To complete your booking",
      "To proceed with your booking",
      "To continue with your booking",
      "To get details",
      "To view more",
      "To continue reading",
      "To proceed",
      "For new updates",
      "To get updates",
      "To subscribe",
      "To subscribe & get updates",
    ];
  }

  static List<String> getLoginSuffixOptions() {
    return [
      "please verify mobile number",
      "please login",
      "please signup",
      "please login/signup",
      "please register",
      "please sign in",
    ];
  }
}
