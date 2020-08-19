import 'package:flutter/material.dart';


class SelectBranch extends StatefulWidget {
  @override
  _SelectBranchState createState() => _SelectBranchState();
}

class _SelectBranchState extends State<SelectBranch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Hello"),
            RaisedButton(
              child: Text("click me dude"),
              onPressed: () {
                // otp.FlutterOtp().sendOtp("7708998036");
              },
            ),
          ],
        ),
      ),
    );
  }
}
