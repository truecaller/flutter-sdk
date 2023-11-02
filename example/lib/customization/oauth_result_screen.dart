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

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'config_options.dart';

class OAuthResultScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<OAuthResultScreen> {
  late final Dio dio = Dio();
  late String accessToken = "";
  late String accessTokenResponse = "";
  late String userInfoResponse = "";

  @override
  Widget build(BuildContext context) {
    final accessTokenHelper =
        ModalRoute.of(context)!.settings.arguments as AccessTokenHelper;
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('OAuth Result'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                SelectableText(
                  "Auth Code: ${accessTokenHelper.tcOAuthData.authorizationCode}",
                  style: TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
                SelectableText(
                  "OAuth State: ${accessTokenHelper.tcOAuthData.state}",
                  style: TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.left,
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
                SelectableText(
                  "Scopes granted: ${accessTokenHelper.tcOAuthData.scopesGranted}",
                  style: TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.left,
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
                MaterialButton(
                  height: 45.0,
                  child: Text(
                    "Fetch Access Token",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    fetchAccessToken(accessTokenHelper);
                  },
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
                SelectableText(
                  accessTokenResponse.isEmpty
                      ? ""
                      : "Access Token Response: $accessTokenResponse",
                  style: TextStyle(fontSize: 12.0),
                  textAlign: TextAlign.left,
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
                Visibility(
                  visible: accessToken.isNotEmpty,
                  child: MaterialButton(
                    height: 45.0,
                    child: Text(
                      "Fetch User Info",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      fetchUserInfo();
                    },
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
                SelectableText(
                  userInfoResponse.isEmpty
                      ? ""
                      : "User Info Response: $userInfoResponse",
                  style: TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.left,
                ),
                Divider(
                  color: Colors.transparent,
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void fetchAccessToken(AccessTokenHelper accessTokenHelper) async {
    try {
      Response response;
      response =
          await dio.post('https://oauth-account-noneu.truecaller.com/v1/token',
              data: {
                'grant_type': 'authorization_code',
                'client_id': '1si1lk7rbbo_mtg29mw5yczekv2ripbbnwnaozhpz6o',
                'code': '${accessTokenHelper.tcOAuthData.authorizationCode}',
                'code_verifier': '${accessTokenHelper.codeVerifier}'
              },
              options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200 && response.data != null) {
        Map result = response.data;
        accessToken = result['access_token'];
        setState(() {
          for (final e in result.entries) {
            accessTokenResponse =
                accessTokenResponse + "\n\n" + ('${e.key} = ${e.value}');
          }
        });
      }
    } on DioException catch (e) {
      print(e.toString());
      setState(() {
        accessTokenResponse = e.toString();
      });
    }
  }

  void fetchUserInfo() async {
    try {
      userInfoResponse = "";
      Response response;
      response = await dio.get(
          'https://oauth-account-noneu.truecaller.com/v1/userinfo',
          options: Options(headers: {"Authorization": "Bearer $accessToken"}));
      if (response.statusCode == 200 && response.data != null) {
        Map result = response.data;
        setState(() {
          for (final e in result.entries) {
            userInfoResponse =
                userInfoResponse + "\n\n" + ('${e.key} = ${e.value}');
          }
        });
      }
    } on DioException catch (e) {
      print(e.toString());
      setState(() {
        userInfoResponse = e.toString();
      });
    }
  }
}
