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
  Stream<TruecallerSdkCallback> _stream;

  @override
  void initState() {
    _stream = TruecallerSdk.getProfileStreamData;
    super.initState();
  }

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
                    TruecallerSdk.initializeSDK();
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
                    stream: _stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.result) {
                          case TruecallerSdkCallbackResult.success:
                            return Text(
                                "Hi, ${snapshot.data.profile.firstName} ${snapshot.data.profile.lastName}");
                          case TruecallerSdkCallbackResult.failure:
                            return Text("Oops!! Error type ${snapshot.data.error.code}");
                          case TruecallerSdkCallbackResult.verification:
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

  @override
  void dispose() {
    _stream = null;
    super.dispose();
  }
}
