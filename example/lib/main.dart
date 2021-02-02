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
import 'package:truecaller_sdk_example/non_tc_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Stream<TruecallerSdkCallback> _stream;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
                    TruecallerSdk.initializeSDK(sdkOptions: TruecallerSdkScope.SDK_OPTION_WITH_OTP);
                    TruecallerSdk.isUsable.then((isUsable) {
                      if (isUsable) {
                        TruecallerSdk.getProfile;
                      } else {
                        final snackBar = SnackBar(content: Text("Not Usable"));
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                        print("***Not usable***");
                      }
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
                                "Hi, ${snapshot.data.profile.firstName} ${snapshot.data.profile.lastName}"
                                "\nBusiness Profile: ${snapshot.data.profile.isBusiness}");
                          case TruecallerSdkCallbackResult.failure:
                            return Text("Oops!! Error type ${snapshot.data.error.code}");
                          case TruecallerSdkCallbackResult.verification:
                            return Column(
                              children: [
                                Text("Verification Required : "
                                    "${snapshot.data.error != null ? snapshot.data.error.code : ""}"),
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

  @override
  void dispose() {
    _stream = null;
    super.dispose();
  }
}
