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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';
import 'package:truecaller_sdk_example/customization/oauth_result_screen.dart';
import 'package:truecaller_sdk_example/non_tc_screen.dart';
import 'package:uuid/uuid.dart';

import 'config_options.dart';

// This screen shows different customization options available in Truecaller SDK

void main() {
  runApp(OptionsConfiguration());
}

class OptionsConfiguration extends StatefulWidget {
  @override
  _OptionsConfigurationState createState() => _OptionsConfigurationState();
}

class _OptionsConfigurationState extends State<OptionsConfiguration> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "TC SDK Demo",
        debugShowCheckedModeBanner: false,
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int selectedFooter;
  late bool rectangularBtn, verifyAllUsers;
  late String? codeVerifier;
  List<DropdownMenuItem<int>> colorMenuItemList = [];
  List<DropdownMenuItem<int>> ctaPrefixMenuItemList = [];
  List<DropdownMenuItem<int>> headingMenuItemList = [];
  late int ctaColor, ctaTextColor;
  late int ctaPrefixOption, headingOption;
  final TextEditingController localeController = TextEditingController();
  late StreamSubscription? streamSubscription;

  @override
  void initState() {
    super.initState();
    createStreamBuilder();
    selectedFooter = FooterOption.getFooterOptionsMap().keys.first;
    rectangularBtn = false;
    verifyAllUsers = false;
    ctaColor = Colors.blue.value;
    ctaTextColor = Colors.white.value;
    ctaPrefixOption = 0;
    headingOption = 0;

    for (String key in ConfigOptions.getColorList().keys) {
      colorMenuItemList.add(DropdownMenuItem<int>(
        value: ConfigOptions.getColorList()[key],
        child: Text("$key"),
      ));
    }

    for (int i = 0; i < ConfigOptions.getCtaPrefixOptions().length; i++) {
      ctaPrefixMenuItemList.add(DropdownMenuItem<int>(
        value: i,
        child: Text("${ConfigOptions.getCtaPrefixOptions()[i]}"),
      ));
    }

    for (int i = 0; i < HeadingOption.getHeadingOptions().length; i++) {
      headingMenuItemList.add(DropdownMenuItem<int>(
        value: i,
        child: Text("${HeadingOption.getHeadingOptions()[i]}"),
      ));
    }
  }

  List<Widget> createRadioListFooterOptions() {
    List<Widget> widgets = [];
    for (int key in FooterOption.getFooterOptionsMap().keys) {
      widgets.add(
        RadioListTile(
          value: key,
          groupValue: selectedFooter,
          title: Text("${FooterOption.getFooterOptionsMap()[key]}"),
          onChanged: (dynamic currentOption) {
            setSelectedFooter(currentOption);
          },
          selected: selectedFooter == key,
          activeColor: Colors.green,
        ),
      );
    }
    return widgets;
  }

  setSelectedFooter(int option) {
    setState(() {
      selectedFooter = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configure SDK options"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Text(
                  "Customization Options",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Column(
                  children: createConfigOptions(),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
                Text(
                  "Footer Options",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
                Column(
                  children: createRadioListFooterOptions(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 10.0, bottom: 10.0),
                  child: TextField(
                    controller: localeController,
                    maxLength: 2,
                    style: TextStyle(
                      color: Colors.green,
                    ),
                    decoration: InputDecoration(
                        labelText: "Enter Locale",
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 16.0),
                        hintText:
                            "Example: en(default), hi, kn, ta, te, mr, etc.",
                        hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.green,
                            fontSize: 14.0)),
                  ),
                ),
                SwitchListTile(
                  title: Text("Verify all users"),
                  value: verifyAllUsers,
                  onChanged: (value) {
                    setState(() {
                      verifyAllUsers = value;
                    });
                  },
                  selected: verifyAllUsers,
                  activeColor: Colors.green,
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
                MaterialButton(
                  height: 45.0,
                  child: Text(
                    "LET'S GO",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    initializeSdk();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  createConfigOptions() {
    return [
      Divider(
        color: Colors.transparent,
        height: 20.0,
      ),
      SwitchListTile(
        title: Text("Rectangular Button"),
        value: rectangularBtn,
        onChanged: (value) {
          setState(() {
            rectangularBtn = value;
          });
        },
        selected: rectangularBtn,
        activeColor: Colors.green,
      ),
      Divider(
        color: Colors.transparent,
        height: 10.0,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: "CTA color",
              labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            style: TextStyle(color: Colors.green),
            value: ctaColor,
            isExpanded: true,
            items: colorMenuItemList,
            onChanged: (value) {
              setState(() {
                ctaColor = value!;
              });
            }),
      ),
      Divider(
        color: Colors.transparent,
        height: 10.0,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: "CTA text color",
              labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            style: TextStyle(color: Colors.green),
            value: ctaTextColor,
            isExpanded: true,
            items: colorMenuItemList,
            onChanged: (value) {
              setState(() {
                ctaTextColor = value!;
              });
            }),
      ),
      Divider(
        color: Colors.transparent,
        height: 10.0,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: "CTA Prefix",
              labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            style: TextStyle(color: Colors.green),
            value: ctaPrefixOption,
            isExpanded: true,
            items: ctaPrefixMenuItemList,
            onChanged: (value) {
              setState(() {
                ctaPrefixOption = value!;
              });
            }),
      ),
      Divider(
        color: Colors.transparent,
        height: 10.0,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: "Heading options",
              labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            style: TextStyle(color: Colors.green),
            value: headingOption,
            isExpanded: true,
            items: headingMenuItemList,
            onChanged: (value) {
              setState(() {
                headingOption = value!;
              });
            }),
      ),
      Divider(
        color: Colors.transparent,
        height: 10.0,
      ),
    ];
  }

  void initializeSdk() {
    _hideKeyboard();
    TcSdk.initializeSDK(
        sdkOption: verifyAllUsers
            ? TcSdkOptions.OPTION_VERIFY_ALL_USERS
            : TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS,
        consentHeadingOption: headingOption,
        footerType: selectedFooter,
        ctaText: ctaPrefixOption,
        buttonShapeOption: rectangularBtn
            ? TcSdkOptions.BUTTON_SHAPE_RECTANGLE
            : TcSdkOptions.BUTTON_SHAPE_ROUNDED,
        buttonColor: ctaColor,
        buttonTextColor: ctaTextColor);

    TcSdk.isOAuthFlowUsable.then((isOAuthFlowUsable) {
      if (isOAuthFlowUsable) {
        TcSdk.setOAuthState(Uuid().v1());
        TcSdk.setOAuthScopes(['profile', 'phone', 'openid', 'offline_access']);
        if (localeController.text.isNotEmpty) {
          TcSdk.setLocale(localeController.text);
        }
        TcSdk.generateRandomCodeVerifier.then((codeVerifier) {
          TcSdk.generateCodeChallenge(codeVerifier).then((codeChallenge) {
            if (codeChallenge != null) {
              this.codeVerifier = codeVerifier;
              TcSdk.setCodeChallenge(codeChallenge);
              TcSdk.getAuthorizationCode;
            } else {
              final snackBar = SnackBar(content: Text("Device not supported"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              print("***Code challenge NULL***");
            }
          });
        });
      } else {
        print("****Not usable****");
      }
    });
  }

  void createStreamBuilder() {
    streamSubscription =
        TcSdk.streamCallbackData.listen((truecallerSdkCallback) {
      switch (truecallerSdkCallback.result) {
        case TcSdkCallbackResult.success:
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OAuthResultScreen(),
                settings: RouteSettings(
                  arguments: AccessTokenHelper(
                      truecallerSdkCallback.tcOAuthData!, codeVerifier!),
                ),
              ));
          break;
        case TcSdkCallbackResult.failure:
          final snackBar = SnackBar(
              content: Text("${truecallerSdkCallback.error!.code} : "
                  "${truecallerSdkCallback.error!.message}"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case TcSdkCallbackResult.verification:
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NonTcVerification(),
              ));
          break;
        default:
          print("Invalid result");
      }
    });
  }

  _hideKeyboard() {
    FocusManager.instance.primaryFocus!.unfocus();
  }

  @override
  void dispose() {
    localeController.dispose();
    streamSubscription?.cancel();
    super.dispose();
  }
}
