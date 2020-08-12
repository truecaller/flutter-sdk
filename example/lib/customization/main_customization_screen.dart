import 'dart:async';

import 'package:flutter/material.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';

import 'ConfigOptions.dart';
import 'result_screen.dart';

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
    return MaterialApp(title: "TC SDK Demo", debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> selectedConsentType;
  List<TitleOption> titleOptions;
  TitleOption selectedTitle;
  int selectedFooter;
  bool darkMode, rectangularBtn;
  List<DropdownMenuItem<int>> colorMenuItemList = List();
  List<DropdownMenuItem<int>> ctaPrefixMenuItemList = List();
  List<DropdownMenuItem<int>> loginPrefixMenuItemList = List();
  List<DropdownMenuItem<int>> loginSuffixMenuItemList = List();
  int ctaColor, ctaTextColor;
  int ctaPrefixOption, loginPrefixOption, loginSuffixOption;
  final TextEditingController privacyPolicyController =
      TextEditingController(text: "https://www.example.com");
  final TextEditingController termsOfServiceController =
      TextEditingController(text: "https://www.truecaller.com/");
  final TextEditingController localeController = TextEditingController();
  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    createStreamBuilder();
    selectedConsentType = [true, false, false];
    titleOptions = TitleOption.getTitleOptions();
    selectedTitle = titleOptions[0];
    selectedFooter = FooterOption.getFooterOptionsMap().keys.first;
    darkMode = false;
    rectangularBtn = false;
    ctaColor = Colors.blue.value;
    ctaTextColor = Colors.white.value;
    ctaPrefixOption = 0;
    loginPrefixOption = 0;
    loginSuffixOption = 0;

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

    for (int i = 0; i < ConfigOptions.getLoginPrefixOptions().length; i++) {
      loginPrefixMenuItemList.add(DropdownMenuItem<int>(
        value: i,
        child: Text("${ConfigOptions.getLoginPrefixOptions()[i]}"),
      ));
    }

    for (int i = 0; i < ConfigOptions.getLoginSuffixOptions().length; i++) {
      loginSuffixMenuItemList.add(DropdownMenuItem<int>(
        value: i,
        child: Text("${ConfigOptions.getLoginSuffixOptions()[i]}"),
      ));
    }
  }

  List<Widget> createRadioListTitleOptions() {
    List<Widget> widgets = [];
    for (TitleOption titleOption in titleOptions) {
      widgets.add(
        RadioListTile(
          value: titleOption,
          groupValue: selectedTitle,
          title: Text(titleOption.name),
          onChanged: (currentOption) {
            setSelectedTitle(currentOption);
          },
          selected: selectedTitle == titleOption,
          activeColor: Colors.green,
        ),
      );
    }
    return widgets;
  }

  setSelectedTitle(TitleOption option) {
    setState(() {
      selectedTitle = option;
    });
  }

  List<Widget> createRadioListFooterOptions() {
    List<Widget> widgets = [];
    for (int key in FooterOption.getFooterOptionsMap().keys) {
      widgets.add(
        RadioListTile(
          value: key,
          groupValue: selectedFooter,
          title: Text("${FooterOption.getFooterOptionsMap()[key]}"),
          onChanged: (currentOption) {
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

  bool isBottomSheetSelected() {
    return selectedConsentType[0] == true;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                  "UI Options",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
                ToggleButtons(
                  constraints: BoxConstraints(minHeight: 50, minWidth: (width - 48) / 3),
                  children: <Widget>[
                    Text("Bottomsheet"),
                    Text("Popup"),
                    Text("Fullscreen"),
                  ],
                  selectedColor: Colors.green,
                  selectedBorderColor: Colors.green,
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < selectedConsentType.length;
                          buttonIndex++) {
                        selectedConsentType[buttonIndex] = buttonIndex == index ? true : false;
                      }
                    });
                  },
                  isSelected: selectedConsentType,
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
                Text(
                  isBottomSheetSelected() ? "Bottomsheet customization Options" : "Title Options",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Visibility(
                  visible: isBottomSheetSelected(),
                  child: Column(
                    children: createBottomsheetConfigOptions(),
                  ),
                  replacement: Column(
                    children: createRadioListTitleOptions(),
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
                Text(
                  "Footer Options",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Column(
                  children: createRadioListFooterOptions(),
                ),
                Visibility(
                  visible: !isBottomSheetSelected(),
                  child: SwitchListTile(
                    title: Text("Dark Mode"),
                    value: darkMode,
                    onChanged: (value) {
                      setState(() {
                        darkMode = value;
                      });
                    },
                    selected: darkMode,
                    activeColor: Colors.green,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 10.0),
                  child: TextField(
                    controller: localeController,
                    maxLength: 2,
                    style: TextStyle(
                      color: Colors.green,
                    ),
                    decoration: InputDecoration(
                        labelText: "Enter Locale",
                        labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                        hintText: "Example: en(default), hi, kn, ta, te, mr, etc.",
                        hintStyle: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.green, fontSize: 14.0)),
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
                MaterialButton(
                  minWidth: width - 50.0,
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

  createBottomsheetConfigOptions() {
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
                ctaColor = value;
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
                ctaTextColor = value;
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
                ctaPrefixOption = value;
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
              labelText: "Login Prefix",
              labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            style: TextStyle(color: Colors.green),
            value: loginPrefixOption,
            isExpanded: true,
            items: loginPrefixMenuItemList,
            onChanged: (value) {
              setState(() {
                loginPrefixOption = value;
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
              labelText: "Login Suffix",
              labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            style: TextStyle(color: Colors.green),
            value: loginSuffixOption,
            isExpanded: true,
            items: loginSuffixMenuItemList,
            onChanged: (value) {
              setState(() {
                loginSuffixOption = value;
              });
            }),
      ),
      Divider(
        color: Colors.transparent,
        height: 10.0,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: TextField(
          controller: termsOfServiceController,
          style: TextStyle(
            color: Colors.green,
          ),
          decoration: InputDecoration(
            labelText: "Terms & Conditions URL",
            labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
        ),
      ),
      Divider(
        color: Colors.transparent,
        height: 10.0,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: TextField(
          controller: privacyPolicyController,
          style: TextStyle(
            color: Colors.green,
          ),
          decoration: InputDecoration(
            labelText: "Privacy Policy URL",
            labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
        ),
      ),
      Divider(
        color: Colors.transparent,
        height: 20.0,
      )
    ];
  }

  void initializeSdk() {
    int selectedConsentMode = TruecallerSdkScope.CONSENT_MODE_BOTTOMSHEET;
    if (selectedConsentType[1] == true) {
      selectedConsentMode = TruecallerSdkScope.CONSENT_MODE_POPUP;
    } else if (selectedConsentType[2] == true) {
      selectedConsentMode = TruecallerSdkScope.CONSENT_MODE_FULLSCREEN;
    }
    TruecallerSdk.initializeSDK(
        consentMode: selectedConsentMode,
        consentTitleOptions:
            TitleOption.getTitleOptions().indexWhere((title) => title.name == selectedTitle.name),
        footerType: selectedFooter,
        loginTextPrefix: loginPrefixOption,
        loginTextSuffix: loginSuffixOption,
        ctaTextPrefix: ctaPrefixOption,
        privacyPolicyUrl: privacyPolicyController.text,
        termsOfServiceUrl: termsOfServiceController.text,
        buttonShapeOptions: rectangularBtn
            ? TruecallerSdkScope.BUTTON_SHAPE_RECTANGLE
            : TruecallerSdkScope.BUTTON_SHAPE_ROUNDED,
        buttonColor: ctaColor,
        buttonTextColor: ctaTextColor);

    TruecallerSdk.isUsable.then((isUsable) {
      if (isUsable) {
        if (darkMode) {
          TruecallerSdk.setDarkTheme;
        }
        if (localeController.text.isNotEmpty) {
          TruecallerSdk.setLocale(localeController.text);
        }
        TruecallerSdk.getProfile;
      } else {
        print("****Not usable****");
      }
    });
  }

  void createStreamBuilder() {
    streamSubscription = TruecallerSdk.getProfileStreamData.listen((truecallerUserCallback) {
      switch (truecallerUserCallback.result) {
        case TruecallerUserCallbackResult.success:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ResultScreen(truecallerUserCallback.profile.firstName, 1),
          ));
          break;
        case TruecallerUserCallbackResult.failure:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ResultScreen("Error code : ${truecallerUserCallback.error.code}", -1),
          ));
          break;
        case TruecallerUserCallbackResult.verification:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ResultScreen("Verification Required!!", 0),
          ));
          break;
        default:
          print("Invalid result");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (streamSubscription != null) {
      streamSubscription.cancel();
    }
  }
}
