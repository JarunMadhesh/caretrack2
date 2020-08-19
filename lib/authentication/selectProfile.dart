import 'package:caretrack/authentication/enterAgeScreen.dart';
import 'package:caretrack/providers/screenController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'phoneNumber.dart';
import '../providers/dbProfiles.dart';
import '../providers/profile.dart';

import 'dart:math' as math;

class SelectProfileScreen extends StatefulWidget {
  static const route = '/SelectProfileScreen';

  @override
  _SelectProfileScreen createState() => _SelectProfileScreen();
}

class _SelectProfileScreen extends State<SelectProfileScreen>
    with TickerProviderStateMixin {
  List<DBProfile> profiles = [];
  int selectedIndex = -1;
  String errorText = '';

  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      setState(() {
        profiles =
            Provider.of<DBProfileProvider>(context, listen: false).profiles;
      });

      _controller = AnimationController(
          vsync: this, duration: Duration(milliseconds: 700));
      _animation = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animation.removeListener(() {});
    super.dispose();
  }

  void change() async {
    Future.delayed(Duration(milliseconds: 0), () async {
      while (Provider.of<ScreenController>(context, listen: false).isLoading) {
        await _controller.forward();
        await _controller.reverse();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    change();
  }

  Widget errorDialogue(String errorString, Function function) {
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
                Text(
                  errorString,
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

  void onPressedToNext() async {
    try {
      if (selectedIndex == -1) {
        setState(() {
          errorText = 'Please select profile';
        });
        return;
      }
      setState(() {
        errorText = '';
        Provider.of<ScreenController>(context, listen: false).setTrue();
      });

      final _isAvailable = await Provider.of<DBProfileProvider>(context, listen: false)
          .checkAvailability(profiles[selectedIndex].uhid);

      Provider.of<ScreenController>(context, listen: false).setFalse();
      String route = EnterAgeScreen.route;
      Navigator.of(context).pushReplacementNamed(
        route,
        arguments: Profile(
          name: profiles[selectedIndex].name,
          antiInflam: false,
          arthritis: false,
          asthma: false,
          bloodPressure: false,
          chemotheraphy: false,
          cortisone: false,
          diabetes: false,
          dialysis: false,
          dob: profiles[selectedIndex].dob,
          heartDisease: false,
          language: "",
          patientID: profiles[selectedIndex].uhid,
          phoneNumber: profiles[selectedIndex].phoneNumber,
          sex: profiles[selectedIndex].gender,
          smoker: false,
          age: profiles[selectedIndex].age,
          isAlreadyavailable: _isAvailable,
          //ToDo: add the attributes from the db
        ),
      );
    } catch (err) {
      showDialog(
        context: context,
        barrierColor: Colors.white60,
        child: errorDialogue(err.toString(), () {
          onPressedToNext();
        }),
      );
    } finally {
      setState(() {
        Provider.of<ScreenController>(context, listen: false).setFalse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    change();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => !Provider.of<ScreenController>(context, listen: false).isLoading,
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
                  if (profiles.length != 0)
                    Container(
                      margin:
                          const EdgeInsets.only(top: 0, bottom: 10, left: 30),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select member",
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (profiles.length != 0)
                    Container(
                      height: height * 0.3,
                      child: ListView.builder(
                        itemCount: profiles.length,
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
                              profiles[i].name,
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
                    padding: const EdgeInsets.only(left: 40),
                    child: Text(
                      errorText,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (profiles.length != 0 && selectedIndex != -1)
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
                          onPressed: onPressedToNext,
                          color: const Color(0xff8b3365),
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                  if (profiles.length == 0)
                    Container(
                      child: Text(
                        "All the account(s) linked with this mobile number is/are already added",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff000000),
                        ),
                      ),
                    )
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(PhoneNumberScreen.route);
                },
                child: Container(
                  width: width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Change mobile number",
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      color: const Color(0xff8b3365),
                    ),
                  ),
                ),
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
            if (Provider.of<ScreenController>(context, listen: false).isLoading)
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
                          ? const Color(0xffCC2F7A)
                          : const Color(0xff8B3365),
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
