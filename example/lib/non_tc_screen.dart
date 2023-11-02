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
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';

import 'customization/result_screen.dart';

void main() {
  runApp(NonTcVerification());
}

class NonTcVerification extends StatefulWidget {
  @override
  _NonTcVerificationState createState() => _NonTcVerificationState();
}

class _NonTcVerificationState extends State<NonTcVerification> {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool invalidNumber = false;
  bool invalidFName = false;
  bool invalidOtp = false;
  bool showProgressBar = false;
  TextEditingController phoneController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  late StreamSubscription? streamSubscription;
  TcSdkCallbackResult? tempResult;
  Timer? _timer;
  int? _ttl;

  @override
  void initState() {
    super.initState();
    createStreamBuilder();
  }

  bool showInputNumberView() {
    return tempResult == null;
  }

  bool showInputNameView() {
    return tempResult != null &&
        (tempResult == TcSdkCallbackResult.missedCallReceived ||
            showInputOtpView());
  }

  bool showInputOtpView() {
    return tempResult != null &&
        ((tempResult == TcSdkCallbackResult.otpInitiated) ||
            (tempResult == TcSdkCallbackResult.otpReceived));
  }

  bool showRetryTextView() {
    return _ttl != null && !showInputNumberView();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    const double fontSize = 18.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify User Manually"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: showProgressBar,
              child: CircularProgressIndicator(
                strokeWidth: 6.0,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            Visibility(
              visible: showInputNumberView(),
              child: TextField(
                controller: phoneController,
                maxLength: 10,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(color: Colors.green, fontSize: fontSize),
                decoration: InputDecoration(
                  prefixText: "+91",
                  prefixStyle:
                      TextStyle(color: Colors.lightGreen, fontSize: fontSize),
                  labelText: "Enter Phone number",
                  labelStyle:
                      TextStyle(color: Colors.black, fontSize: fontSize),
                  hintText: "99999-99999",
                  errorText: invalidNumber
                      ? "Mobile Number must be of 10 digits"
                      : null,
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                      fontSize: fontSize),
                ),
              ),
            ),
            Divider(
              color: Colors.transparent,
              height: 20.0,
            ),
            Visibility(
              visible: showInputNameView(),
              child: TextField(
                controller: fNameController,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.green, fontSize: fontSize),
                decoration: InputDecoration(
                  prefixStyle:
                      TextStyle(color: Colors.lightGreen, fontSize: fontSize),
                  labelText: "Enter First Name",
                  labelStyle:
                      TextStyle(color: Colors.black, fontSize: fontSize),
                  hintText: "John",
                  errorText: invalidFName
                      ? "Invalid first name. Enter min 2 characters"
                      : null,
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                      fontSize: fontSize),
                ),
              ),
            ),
            Divider(
              color: Colors.transparent,
              height: 20.0,
            ),
            Visibility(
              visible: showInputNameView(),
              child: TextField(
                controller: lNameController,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.green, fontSize: fontSize),
                decoration: InputDecoration(
                  prefixStyle:
                      TextStyle(color: Colors.lightGreen, fontSize: fontSize),
                  labelText: "Enter Last Name",
                  labelStyle:
                      TextStyle(color: Colors.black, fontSize: fontSize),
                  hintText: "Doe",
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                      fontSize: fontSize),
                ),
              ),
            ),
            Divider(
              color: Colors.transparent,
              height: 20.0,
            ),
            Visibility(
              visible: showInputOtpView(),
              child: TextField(
                controller: otpController,
                maxLength: 6,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(color: Colors.green, fontSize: fontSize),
                decoration: InputDecoration(
                  labelText: "Enter OTP",
                  labelStyle:
                      TextStyle(color: Colors.black, fontSize: fontSize),
                  hintText: "123-456",
                  errorText: invalidOtp ? "OTP must be 6 digits" : null,
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                      fontSize: fontSize),
                ),
              ),
            ),
            Divider(
              color: Colors.transparent,
              height: 20.0,
            ),
            Visibility(
              visible: showInputNumberView() ||
                  showInputNameView() ||
                  showInputOtpView(),
              child: MaterialButton(
                minWidth: width - 50.0,
                height: 45.0,
                onPressed: () => onProceedClick(),
                child: Text("Proceed",
                    style: TextStyle(
                      color: Colors.white,
                    )),
                color: Colors.blue,
              ),
            ),
            Divider(
              color: Colors.transparent,
              height: 30.0,
            ),
            Visibility(
              visible: showRetryTextView(),
              child: _ttl == 0
                  ? TextButton(
                      child: Text(
                        "verification timed out, retry again",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue),
                      ),
                      onPressed: () => setState(() => tempResult = null))
                  : Text("Retry again in $_ttl seconds"),
            ),
          ],
        ),
      ),
    );
  }

  void startCountdownTimer(int ttl) {
    _ttl = ttl;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_ttl! < 1) {
            timer.cancel();
            showProgressBar = false;
          } else {
            _ttl = _ttl! - 1;
          }
        },
      ),
    );
  }

  void createStreamBuilder() {
    streamSubscription =
        TcSdk.streamCallbackData.listen((truecallerUserCallback) {
      // make sure you're changing state only after number has been entered. there could be case
      // where user initiated missed call, pressed back, and came to this screen again after
      // which the call was received and hence it would directly open input name screen.
      if (phoneController.text.length == 10) {
        setState(() {
          if (truecallerUserCallback.result != TcSdkCallbackResult.exception) {
            tempResult = truecallerUserCallback.result;
          }
          showProgressBar =
              tempResult == TcSdkCallbackResult.missedCallInitiated;
          if (tempResult == TcSdkCallbackResult.otpReceived) {
            otpController.text = truecallerUserCallback.otp!;
          }
        });
      }

      switch (truecallerUserCallback.result) {
        case TcSdkCallbackResult.missedCallInitiated:
          startCountdownTimer(
              double.parse(truecallerUserCallback.ttl!).floor());
          showSnackBar(
              "Missed call Initiated with TTL : ${truecallerUserCallback.ttl} && "
              "requestNonce = ${truecallerUserCallback.requestNonce}");
          break;
        case TcSdkCallbackResult.missedCallReceived:
          showSnackBar("Missed call Received");
          break;
        case TcSdkCallbackResult.otpInitiated:
          startCountdownTimer(
              double.parse(truecallerUserCallback.ttl!).floor());
          showSnackBar(
              "OTP Initiated with TTL : ${truecallerUserCallback.ttl} && "
              "requestNonce = ${truecallerUserCallback.requestNonce}");
          break;
        case TcSdkCallbackResult.otpReceived:
          showSnackBar("OTP Received : ${truecallerUserCallback.otp}");
          break;
        case TcSdkCallbackResult.verificationComplete:
          showSnackBar(
              "Verification Completed : ${truecallerUserCallback.accessToken} && "
              "requestNonce = ${truecallerUserCallback.requestNonce}");
          _navigateToResult(fNameController.text);
          break;
        case TcSdkCallbackResult.verifiedBefore:
          showSnackBar(
              "Verified Before : ${truecallerUserCallback.profile!.accessToken} && "
              "requestNonce = ${truecallerUserCallback.profile!.requestNonce}");
          _navigateToResult(truecallerUserCallback.profile!.firstName);
          break;
        case TcSdkCallbackResult.exception:
          showSnackBar("Exception : ${truecallerUserCallback.exception!.code}, "
              "${truecallerUserCallback.exception!.message}");
          break;
        default:
          print(tempResult.toString());
          break;
      }
    });
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _navigateToResult(String firstName) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(firstName),
        ));
  }

  Future<void> onProceedClick() async {
    if (showInputNumberView() && validateNumber()) {
      try {
        if (await Permission.phone.request().isGranted) {
          await TcSdk.requestVerification(phoneNumber: phoneController.text);
          setProgressBarToActive();
        } else if (await Permission.phone.isPermanentlyDenied) {
          openAppSettings();
        } else {
          showSnackBar("Please grant all the permissions to proceed");
        }
      } on PlatformException catch (exception) {
        showSnackBar(exception.message.toString());
      } catch (exception) {
        showSnackBar(exception.toString());
      }
    } else if (tempResult == TcSdkCallbackResult.missedCallReceived &&
        validateName()) {
      setProgressBarToActive();
      TcSdk.verifyMissedCall(
          firstName: fNameController.text, lastName: lNameController.text);
    } else if ((tempResult == TcSdkCallbackResult.otpInitiated ||
            tempResult == TcSdkCallbackResult.otpReceived) &&
        validateName() &&
        validateOtp()) {
      setProgressBarToActive();
      TcSdk.verifyOtp(
          firstName: fNameController.text,
          lastName: lNameController.text,
          otp: otpController.text);
    }
  }

  void setProgressBarToActive() {
    setState(() {
      showProgressBar = true;
    });
  }

  bool validateNumber() {
    String phoneNumber = phoneController.text;
    setState(() {
      phoneNumber.length != 10 ? invalidNumber = true : invalidNumber = false;
    });
    return !invalidNumber;
  }

  bool validateOtp() {
    String otp = otpController.text;
    setState(() {
      otp.length != 6 ? invalidOtp = true : invalidOtp = false;
    });
    return !invalidOtp;
  }

  bool validateName() {
    String fName = fNameController.text;
    setState(() {
      fName.length < 2 ? invalidFName = true : invalidFName = false;
    });
    return !invalidFName;
  }

  @override
  void dispose() {
    phoneController.dispose();
    fNameController.dispose();
    lNameController.dispose();
    otpController.dispose();
    streamSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}
