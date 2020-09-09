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
    super.initState();
    _stream = TruecallerSdk.streamCallbackData;
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
