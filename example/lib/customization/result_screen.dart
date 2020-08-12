import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  String result;
  int resultCode;

  ResultScreen(String result, int resultCode) {
    this.result = result;
    this.resultCode = resultCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result Page"),
      ),
      body: Center(
        child: Text(
          (resultCode == 1) ? "Hi, $result!" : "$result",
          style: TextStyle(fontSize: 20.0, letterSpacing: 5.0),
        ),
      ),
    );
  }
}
