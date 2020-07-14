import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'phoneNumber.dart';
import 'selectLanguage.dart';
import '../providers/dbProfiles.dart';
import '../providers/profile.dart';

class SelectProfileScreen extends StatefulWidget {
  static const route = '/SelectProfileScreen';

  @override
  _SelectProfileScreen createState() => _SelectProfileScreen();
}

class _SelectProfileScreen extends State<SelectProfileScreen> {
  List<DBProfile> profiles = [];
  int selectedIndex = -1;
  String errorText = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      setState(() {
        profiles =
            Provider.of<DBProfileProvider>(context, listen: false).profiles;
      });
    });
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
                    margin:  const EdgeInsets.only(bottom: 20),
                    height: MediaQuery.of(context).size.height * 0.18,
                    child: Image.asset('assets/logo.png'),
                  ),
                  if (profiles.length != 0)
                    Container(
                      margin:  const EdgeInsets.only(top: 0, bottom: 10, left: 30),
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
                            padding:  const EdgeInsets.only(left: 30, right: 30),
                            margin:  const EdgeInsets.only(
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
                    padding:  const EdgeInsets.only(left: 40),
                    child: Text(
                      errorText,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (profiles.length != 0)
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
                          onPressed: () {
                            if (selectedIndex == -1) {
                              setState(() {
                                errorText = 'Please select profile';
                              });
                              return;
                            }
                            setState(() {
                              errorText = '';
                            });
                            Navigator.of(context).pushReplacementNamed(
                              SelectLanguageScreen.route,
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
                                phoneNumber:
                                    profiles[selectedIndex].phoneNumber,
                                sex: profiles[selectedIndex].gender,
                                smoker: false,
                                age: profiles[selectedIndex].age,
                                //ToDo: add the attributes from the db
                              ),
                            );
                          },
                          color: const Color(0xff8b3365),
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                  if (profiles.length == 0)
                    Container(
                      child: Text(
                        "All the account(s) linked with this phone number is/are already added",
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
                  padding:  const EdgeInsets.all(10),
                  child: Text(
                    "Change phone number",
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
          ],
        ),
      ),
    );
  }
}
