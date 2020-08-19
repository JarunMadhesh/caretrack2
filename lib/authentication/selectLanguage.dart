import 'package:caretrack/authentication/welcomePage.dart';
import 'package:caretrack/providers/screenController.dart';
import 'package:caretrack/providers/symptomsHistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'selectProfile.dart';
import '../providers/profile.dart';
import '../screens/newProfile2.dart';

import 'dart:math' as math;

class SelectLanguageScreen extends StatefulWidget {
  static const route = '/SelectLanguageScreen';

  @override
  _SelectLanguageScreen createState() => _SelectLanguageScreen();
}

class _SelectLanguageScreen extends State<SelectLanguageScreen>
    with TickerProviderStateMixin {
  String phoneNumber = '';
  List<String> language = ['English', 'Tamil'];
  int selectedIndex = -1;
  String errorText = '';

  Profile args;

  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0), () {
      _controller = AnimationController(
          vsync: this, duration: Duration(milliseconds: 700));
      _animation = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration(milliseconds: 0), () async {
      while (Provider.of<NewProfileScreenController>(context, listen: false)
          .isLoading) {
        await _controller.forward();
        await _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget errorDialogue(Function function) {
    return AlertDialog(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xff8b3365),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: const Offset(2, 2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.close),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 30,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff8b3365),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: const Offset(6, 6),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/icons/sadFace.svg',
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Error occurred !',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffeaebf3),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Something went wrong.\nKeep calm and try again.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffe5e5e8),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    function();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Try again',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff8b3365),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onSubmit() async {
    try {
      if (selectedIndex == -1) {
        setState(() {
          errorText = 'Please select language';
        });
        return;
      }
      setState(() {
        errorText = '';
      });
      Profile profile = Profile(
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
        isAlreadyavailable: args.isAlreadyavailable,
      );
      if (args.isAlreadyavailable) {
        Provider.of<NewProfileScreenController>(context, listen: false)
            .setTrue();
        await Provider.of<ProfileProvider>(context, listen: false)
            .addProfiletoLocal(profile);
        await Provider.of<SymptomsHistory>(context, listen: false)
            .getSymptoms(context);
        Provider.of<NewProfileScreenController>(context, listen: false)
            .setFalse();
        Navigator.of(context).pushReplacementNamed(
          WelomePage.route,
          arguments: profile.name,
        );
      } else {
        Navigator.of(context)
            .pushReplacementNamed(NewProfile2.route, arguments: profile);
      }
    } catch (err) {
      errorDialogue(onSubmit);
    }
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
                      args != null && args.isAlreadyavailable
                          ? Container(
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
                                child: GestureDetector(
                                  child: Container(
                                    child: Text(
                                      "Confirm",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "RalewayMed",
                                        color: Color(0xff8b3365),
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                  ),
                                  onTap: onSubmit,
                                ),
                              ),
                              alignment: Alignment.center,
                            )
                          : Container(
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
            if (Provider.of<NewProfileScreenController>(context).isLoading)
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white70,
                alignment: Alignment.center,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (ctx, _) => Transform.rotate(
                    angle: math.pi * 2 * _animation.value,
                    child: Icon(
                      Icons.add,
                      size: 140,
                      color: _animation.value > 0.5
                          ? Color(0xffCC2F7A)
                          : Color(0xff8B3365),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
