import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'selectProfile.dart';
import '../providers/profile.dart';
import '../screens/newProfile2.dart';

class SelectLanguageScreen extends StatefulWidget {
  static const route = '/SelectLanguageScreen';

  @override
  _SelectLanguageScreen createState() => _SelectLanguageScreen();
}

class _SelectLanguageScreen extends State<SelectLanguageScreen> {
  String phoneNumber = '';
  List<String> language = ['English', 'Tamil'];
  int selectedIndex = -1;
  String errorText = '';

  Profile args;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0), () {
      args = ModalRoute.of(context).settings.arguments;
    });
  }

  void onSubmit() {
    if (selectedIndex == -1) {
      setState(() {
        errorText = 'Please select language';
      });
      return;
    }
    setState(() {
      errorText = '';
    });
    Navigator.of(context).pushReplacementNamed(
      NewProfile2.route,
      arguments: Profile(
        name: args.name,
        antiInflam: false,
        arthritis: false,
        asthma: false,
        bloodPressure: false,
        chemotheraphy: false,
        cortisone: false,
        diabetes: false,
        dialysis: false,
        dob: args.dob,
        heartDisease: false,
        language: language[selectedIndex],
        patientID: args.patientID,
        phoneNumber: args.phoneNumber,
        sex: args.sex,
        smoker: false,
        age: args.age,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xffEAEBF3),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: height * 0.19,
                left: width * 0.15,
                right: width * 0.15,
              ),
              alignment: Alignment.topCenter,
              child: ListView(
                physics: new NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: MediaQuery.of(context).size.height * 0.18,
                    child: Image.asset('assets/logo.png'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 0, bottom: 10),
                    alignment: Alignment.center,
                    child: Text(
                      "Preferable language",
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: height * 0.3,
                    child: ListView.builder(
                      itemCount: language.length,
                      itemBuilder: (ctx, i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = i;
                            errorText = '';
                          });
                        },
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          margin: const EdgeInsets.only(
                              bottom: 20, left: 20, right: 20),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
                                offset: const Offset(-5.0, -5.0),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(5.0, 5.0),
                                blurRadius: 10.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                            color: selectedIndex == i
                                ? Color(0xff8b3365)
                                : Color(0xffEAEBF3),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            language[i],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Raleway",
                              color: selectedIndex == i
                                  ? Color(0xffEAEBF3)
                                  : Color(0xff8b3365),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      errorText,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
                                offset: const Offset(-5.0, -5.0),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(5.0, 5.0),
                                blurRadius: 10.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xffEAEBF3),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                  SelectProfileScreen.route);
                            },
                            color: const Color(0xff8b3365),
                          ),
                        ),
                        alignment: Alignment.center,
                      ),
                      Container(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
                                offset: const Offset(-5.0, -5.0),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(5.0, 5.0),
                                blurRadius: 10.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xffEAEBF3),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: onSubmit,
                            color: const Color(0xff8b3365),
                          ),
                        ),
                        alignment: Alignment.center,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: Provider.of<ProfileProvider>(context).profile.length != 0
                  ? IconButton(
                      icon: Icon(Icons.close),
                      color: const Color(0xff8b3365),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
