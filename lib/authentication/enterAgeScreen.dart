import 'package:caretrack/authentication/selectLanguage.dart';
import 'package:caretrack/authentication/selectProfile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../providers/profile.dart';

class EnterAgeScreen extends StatefulWidget {
  static const route = '/EnterAgeScreen';

  @override
  _EnterAgeScreen createState() => _EnterAgeScreen();
}

class _EnterAgeScreen extends State<EnterAgeScreen> {
  String errorText = '';
  DateTime _selectedDate;

  TextEditingController _nameController = TextEditingController();

  Profile args;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0), () {
      args = ModalRoute.of(context).settings.arguments;
      setState(() {
        _nameController = TextEditingController(text: args.name);
        _selectedDate = args.age == -1 ? null : args.dob;
      });
    });
  }

  void onSubmit() {
    
    if (_nameController.text.length == 0) {
      setState(() {
        errorText = 'Please enter your name';
      });
      return;
    }
    if (_selectedDate == null) {
      setState(() {
        errorText = 'Please enter your date of birth';
      });
      return;
    }
    setState(() {
      errorText = '';
    });
    
    Navigator.of(context).pushReplacementNamed(
      SelectLanguageScreen.route,
      arguments: Profile(
        name: _nameController.text,
        antiInflam: false,
        arthritis: false,
        asthma: false,
        bloodPressure: false,
        chemotheraphy: false,
        cortisone: false,
        diabetes: false,
        dialysis: false,
        dob: _selectedDate,
        heartDisease: false,
        language: 'English',
        patientID: args.patientID,
        phoneNumber: args.phoneNumber,
        sex: args.sex,
        smoker: false,
        age: calculateAge(_selectedDate),
        isAlreadyavailable: args.isAlreadyavailable,
      ),
    );
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
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
                      "Name",
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  NeuCard(
                    constraints: BoxConstraints(minHeight: 46),
                    curveType: CurveType.flat,
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                    margin: EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.centerLeft,
                    decoration: NeumorphicDecoration(
                        borderRadius: BorderRadius.circular(20)),
                    child: TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                        fontFamily: 'Calibre',
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff8b3365),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      cursorColor: Color(0xff8b3365),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(top: 0, bottom: 10),
                    alignment: Alignment.center,
                    child: Text(
                      "Date of birth",
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.1,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NeuCard(
                          bevel: 12,
                          curveType: CurveType.emboss,
                          constraints: BoxConstraints(
                              maxHeight: 80, maxWidth: 200, minWidth: 100),
                          decoration: NeumorphicDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(40)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            child: Text(
                              _selectedDate == null
                                  ? "Select DOB"
                                  : DateFormat.yMMMd().format(_selectedDate),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Calibre',
                                  color: const Color(0xff8b3365)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: const Color(0xff8b3365),
                          ),
                          onPressed: () async {
                            DateTime _tempDateTime =
                                await DatePicker.showDatePicker(
                              context,
                              maxTime: DateTime.now(),
                              minTime: DateTime(1900),
                              currentTime: _selectedDate==null? DateTime(2000) : _selectedDate,
                              theme: DatePickerTheme(
                                doneStyle: TextStyle(
                                  color: const Color(0xff8b3365),
                                ),
                              ),
                            );
                            if (_tempDateTime != null) {
                              _selectedDate = _tempDateTime;
                            }
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(height: height * 0.03),
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
                        // Navigator.of(context).pop();
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
