import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:caretrack/providers/symptomsHistory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../authentication/selectLanguage.dart';
import '../authentication/welcomePage.dart';
import '../providers/profile.dart';
import '../providers/screenController.dart';

class NewProfile2 extends StatefulWidget {
  static const route = '/NewProfile2';

  @override
  _NewProfileScreenState createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfile2>
    with TickerProviderStateMixin {
  Profile _profile = Profile(
    name: "",
    antiInflam: false,
    arthritis: false,
    asthma: false,
    bloodPressure: false,
    chemotheraphy: false,
    cortisone: false,
    diabetes: false,
    dialysis: false,
    dob: DateTime.now(),
    heartDisease: false,
    language: "",
    patientID: DateTime.now().toString(),
    phoneNumber: "",
    sex: "",
    smoker: false,
    age: 0,
    isAlreadyavailable: false,
  );

  bool _isEng = true;
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(microseconds: 0),
      () {
        _controller = AnimationController(
            vsync: this, duration: Duration(milliseconds: 700));
        _animation = Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
        final Profile args = ModalRoute.of(context).settings.arguments;
        if (args != null) {
          _profile.name = args.name;
          _profile.patientID = args.patientID;
          _profile.dob = args.dob;
          _profile.phoneNumber = args.phoneNumber;
          _profile.age = args.age;
          _profile.sex = args.sex;
          _profile.language = args.language;
          _profile.antiInflam = args.antiInflam;
          _profile.arthritis = args.arthritis;
          _profile.asthma = args.asthma;
          _profile.bloodPressure = args.bloodPressure;
          _profile.chemotheraphy = args.chemotheraphy;
          _profile.cortisone = args.cortisone;
          _profile.diabetes = args.diabetes;
          _profile.dialysis = args.dialysis;
          _profile.heartDisease = args.heartDisease;
          _profile.smoker = args.smoker;
          setState(() {});
          setState(() {
            _isEng = args.language != 'Tamil';
          });
        }
      },
    );
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

  void onConfirmSubmit() async {
    try {
      Navigator.of(context).pop();
      Provider.of<NewProfileScreenController>(context, listen: false).setTrue();
      //
      //
      // actual thinegey
      await Provider.of<ProfileProvider>(context, listen: false)
          .addProfile(_profile);
      await Provider.of<SymptomsHistory>(context, listen: false).getSymptoms(context);
      //
      //
      //
      Provider.of<NewProfileScreenController>(context, listen: false)
          .setFalse();
      Navigator.of(context).pushReplacementNamed(
        WelomePage.route,
        arguments: _profile.name,
      );
    } catch (err) {
      errorDialogue(onConfirmSubmit);
    } finally {
      Provider.of<NewProfileScreenController>(context, listen: false)
          .setFalse();
    }
  }

  void onSubmit() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white60,
      child: AlertDialog(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.transparent,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
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
                  Text(
                    _isEng
                        ? 'Are you sure you want to submit?'
                        : 'நீங்கள் சமர்ப்பிக்க விரும்புகிறீர்களா?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 21,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            _isEng ? "Cancel" : 'இல்லை',
                            style: const TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onConfirmSubmit,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            _isEng ? "Confirm" : ' ஆம் ',
                            style: const TextStyle(
                              fontFamily: 'Raleway',
                              color: const Color(0xff8b3365),
                            ),
                          ),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: const Color(0xffEAEBF3),
              // floatingActionButton: FloatingActionButton(onPressed: () {
              //   Provider.of<SymptomsHistory>(context, listen: false).deleteSymptoms();
              // }),
              appBar: AppBar(
                leading: Container(),
                centerTitle: true,
                backgroundColor: const Color(0xffEAEBF3),
                elevation: 0.0,
                title: Text(
                  _isEng ? 'Health Records' : 'மருத்துவ பதிவுகள்',
                  style: TextStyle(
                    fontFamily: 'RalewayMed',
                    fontSize: _isEng ? 21 : 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff8b3365),
                  ),
                ),
              ),
              body: Container(
                height: _height,
                width: _width,
                padding:
                    EdgeInsets.only(left: _width * 0.1, right: _width * 0.1),
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      NeuCard(
                        constraints: const BoxConstraints(minHeight: 50),
                        curveType: CurveType.flat,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.centerLeft,
                        decoration: NeumorphicDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              _isEng ? 'Diabetes' : 'நீரிழிவு நோய்',
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff000000),
                              ),
                            ),
                            CupertinoSwitch(
                              value: _profile.diabetes,
                              onChanged: (val) {
                                setState(() {
                                  _profile.diabetes = val;
                                });
                              },
                              activeColor: const Color(0xffCC2F7A),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      NeuCard(
                        constraints: const BoxConstraints(minHeight: 50),
                        curveType: CurveType.flat,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.centerLeft,
                        decoration: NeumorphicDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              _isEng ? 'Blood Pressure' : 'இரத்த அழுத்தம்',
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff000000),
                              ),
                            ),
                            CupertinoSwitch(
                              value: _profile.bloodPressure,
                              onChanged: (val) {
                                setState(() {
                                  _profile.bloodPressure = val;
                                });
                              },
                              activeColor: const Color(0xffCC2F7A),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      NeuCard(
                        constraints: const BoxConstraints(minHeight: 50),
                        curveType: CurveType.flat,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.centerLeft,
                        decoration: NeumorphicDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              _isEng ? 'Asthma' : 'ஆஸ்துமா',
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff000000),
                              ),
                            ),
                            CupertinoSwitch(
                              value: _profile.asthma,
                              onChanged: (val) {
                                setState(() {
                                  _profile.asthma = val;
                                });
                              },
                              activeColor: const Color(0xffCC2F7A),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      NeuCard(
                        constraints: const BoxConstraints(minHeight: 50),
                        curveType: CurveType.flat,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.centerLeft,
                        decoration: NeumorphicDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              _isEng ? 'Heart disease' : 'இருதய நோய்',
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff000000),
                              ),
                            ),
                            CupertinoSwitch(
                              value: _profile.heartDisease,
                              onChanged: (val) {
                                setState(() {
                                  _profile.heartDisease = val;
                                });
                              },
                              activeColor: const Color(0xffCC2F7A),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      NeuCard(
                        constraints: const BoxConstraints(minHeight: 50),
                        curveType: CurveType.flat,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.centerLeft,
                        decoration: NeumorphicDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: _width * 0.45,
                              child: AutoSizeText(
                                _isEng
                                    ? 'Dialysis/Kidney disease'
                                    : 'டயாலிசிஸ்/சிறுநீரக நோய்',
                                maxLines: 1,
                                style: const TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: const Color(0xff000000),
                                ),
                              ),
                            ),
                            CupertinoSwitch(
                              value: _profile.dialysis,
                              onChanged: (val) {
                                setState(() {
                                  _profile.dialysis = val;
                                });
                              },
                              activeColor: const Color(0xffCC2F7A),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      NeuCard(
                        constraints: const BoxConstraints(minHeight: 50),
                        curveType: CurveType.flat,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.centerLeft,
                        decoration: NeumorphicDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              _isEng ? 'Arthritis' : 'கீல்வாதம்',
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff000000),
                              ),
                            ),
                            CupertinoSwitch(
                              value: _profile.arthritis,
                              onChanged: (val) {
                                setState(() {
                                  _profile.arthritis = val;
                                });
                              },
                              activeColor: const Color(0xffCC2F7A),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      NeuCard(
                        constraints: const BoxConstraints(minHeight: 50),
                        curveType: CurveType.flat,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.centerLeft,
                        decoration: NeumorphicDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              _isEng ? 'Chemotherapy' : 'கீமோதெரபி',
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff000000),
                              ),
                            ),
                            CupertinoSwitch(
                              value: _profile.chemotheraphy,
                              onChanged: (val) {
                                setState(() {
                                  _profile.chemotheraphy = val;
                                });
                              },
                              activeColor: const Color(0xffCC2F7A),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      NeuCard(
                        constraints: const BoxConstraints(minHeight: 50),
                        curveType: CurveType.flat,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.centerLeft,
                        decoration: NeumorphicDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              _isEng ? 'Smoker' : 'புகைப்பிடிப்பவர்',
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff000000),
                              ),
                            ),
                            CupertinoSwitch(
                              value: _profile.smoker,
                              onChanged: (val) {
                                setState(() {
                                  _profile.smoker = val;
                                });
                              },
                              activeColor: const Color(0xffCC2F7A),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      NeuCard(
                        constraints: const BoxConstraints(minHeight: 50),
                        curveType: CurveType.flat,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.centerLeft,
                        decoration: NeumorphicDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(height: 10),
                            AutoSizeText(
                              _isEng ? 'Medications' : 'மருந்துகள்',
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff000000),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(
                                  _isEng ? 'Cortisone' : 'கார்டிசோன்',
                                  style: const TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                                CupertinoSwitch(
                                  value: _profile.cortisone,
                                  onChanged: (val) {
                                    setState(() {
                                      _profile.cortisone = val;
                                    });
                                  },
                                  activeColor: const Color(0xffCC2F7A),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(
                                  _isEng
                                      ? 'Anti inflammatory\nmedications'
                                      : 'அழற்சி எதிர்ப்பு\nமருந்துகள்',
                                  style: const TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                                CupertinoSwitch(
                                  value: _profile.antiInflam,
                                  onChanged: (val) {
                                    setState(() {
                                      _profile.antiInflam = val;
                                    });
                                  },
                                  activeColor: const Color(0xffCC2F7A),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info,
                            color: const Color(0xff8b3365),
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          AutoSizeText(
                            _isEng
                                ? "This is for doctors' purpose only"
                                : 'இது மருத்துவர்களின் \nகண்காணிப்புக்கு மட்டுமே',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                fontFamily: "Raleway"),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NeuButton(
                            child: Container(
                              alignment: Alignment.center,
                              width: _width * 0.25,
                              height: 25,
                              child: AutoSizeText(
                                _isEng ? "Previous" : 'முந்தையது',
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: _isEng ? 16 : 12,
                                  fontWeight: FontWeight.w300,
                                  color: const Color(0xff8B3365),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                SelectLanguageScreen.route,
                                arguments: Profile(
                                  name: _profile.name,
                                  antiInflam: false,
                                  arthritis: false,
                                  asthma: false,
                                  bloodPressure: false,
                                  chemotheraphy: false,
                                  cortisone: false,
                                  diabetes: false,
                                  dialysis: false,
                                  dob: _profile.dob,
                                  heartDisease: false,
                                  language: _profile.language,
                                  patientID: _profile.patientID,
                                  phoneNumber: _profile.phoneNumber,
                                  sex: _profile.sex,
                                  smoker: false,
                                  age: _profile.age,
                                  isAlreadyavailable: false
                                ),
                              );
                            },
                          ),
                          NeuButton(
                            child: Container(
                              alignment: Alignment.center,
                              width: _width * 0.25,
                              height: 25,
                              child: AutoSizeText(
                                _isEng ? "Submit" : 'சமர்ப்பிக்கவும்',
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: _isEng ? 16 : 12,
                                  fontWeight: FontWeight.w300,
                                  color: const Color(0xff8B3365),
                                ),
                              ),
                            ),
                            onPressed: onSubmit,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 31,
              right: 20,
              child: Provider.of<ProfileProvider>(context, listen: false)
                          .profile
                          .length !=
                      0
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
