import 'package:flutter/material.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';
import 'package:truecaller_sdk_example/non_tc_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Truecaller SDK example'),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    TruecallerSdk.initializeSDK(sdkOptions: TruecallerSdkScope.SDK_OPTION_WITH_OTP);
                    TruecallerSdk.isUsable.then((isUsable) {
                      isUsable ? TruecallerSdk.getProfile : print("***Not usable***");
                    });
                  },
                  child: Text(
                    "Initialize SDK & Get Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
                StreamBuilder<TruecallerSdkCallback>(
                    stream: TruecallerSdk.getProfileStreamData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.result) {
                          case TruecallerSdkCallbackResult.success:
                            return Text(
                                "Hi, ${snapshot.data.profile.firstName} ${snapshot.data.profile.lastName}");
                          case TruecallerSdkCallbackResult.failure:
                            return Text("Oops!! Error type ${snapshot.data.error.code}");
                          case TruecallerSdkCallbackResult.verification:
                            return Column(
                              children: [
                                Text("Verification Required"),
                                MaterialButton(
                                  color: Colors.green,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NonTcVerification()));
                                  },
                                  child: Text(
                                    "Do manual verification",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            );
                          default:
                            return Text("Invalid result");
                        }
                      } else
                        return Text("");
                    }),
              ],
            ),
          )),
    );
  }
}
