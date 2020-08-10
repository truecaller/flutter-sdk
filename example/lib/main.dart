import 'package:flutter/material.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';

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
            title: const Text('Plugin example app'),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    TruecallerSdk.initiateSDK();
                    TruecallerSdk.isUsable.then((isUsable) {
                      isUsable ? TruecallerSdk.getProfile : print("***Not usable***");
                    });
                  },
                  child: Text(
                    "Show Alert",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
                StreamBuilder<TruecallerUserCallback>(
                    stream: TruecallerSdk.streamData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.result) {
                          case TruecallerUserCallbackResult.success:
                            return Text(
                                "Hi, ${snapshot.data.profile.firstName} ${snapshot.data.profile.lastName}");
                          case TruecallerUserCallbackResult.failure:
                            return Text("Oops!! Error type ${snapshot.data.error.code}");
                          case TruecallerUserCallbackResult.verification:
                            return Text("Verification Required");
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
