import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../providers/profile.dart';
import '../providers/screenController.dart';
import '../providers/symptomsHistory.dart';
import 'symptomsScreen.dart';

class SymptomInitScreen extends StatefulWidget {
  static const route = '/SymptomInitScreen';

  @override
  _SymptomScreenState createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomInitScreen>
    with TickerProviderStateMixin {
  List<Profile> _profiles;

  bool _isOnTime = false;
  bool _isSingleAndAvailable = false;

  Animation<double> _animation;
  AnimationController _controller;

  // ToDo: Set _isOnTime to false

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
    if ((TimeOfDay.now().hour >= 7 && TimeOfDay.now().hour < 10) ||
        (TimeOfDay.now().hour >= 17 && TimeOfDay.now().hour < 20)) {
      setState(() {
        _isOnTime = true;
      });
    }

    Future.delayed(Duration(seconds: 0), () async {
      _profiles = Provider.of<ProfileProvider>(context, listen: false).profile;
      if (_isOnTime && _profiles.length == 1) {
        int no = 0;
        if (TimeOfDay.now().hour >= 7 && TimeOfDay.now().hour < 10)
          no = 1;
        else if (TimeOfDay.now().hour >= 17 && TimeOfDay.now().hour < 20)
          no = 2;
        String time = '${DateTime.now().toString().substring(0, 10)}$no';

        final bool _isAvailable =
            await Provider.of<SymptomsHistory>(context, listen: false)
                .isAvailable(_profiles[0].patientID, time, context);
        if (!_isAvailable) {
          Navigator.of(context).pushNamed(SymptomScreen.route,
              arguments: _profiles[0].patientID);
        } else {
          setState(() {
            _isSingleAndAvailable = true;
          });
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration(milliseconds: 0), () async {
      while (Provider.of<ScreenController>(context, listen: false).isLoading) {
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

  @override
  Widget build(BuildContext context) {
    _profiles = Provider.of<ProfileProvider>(context, listen: false).profile;
    return WillPopScope(
      onWillPop: () async =>
          !Provider.of<ScreenController>(context, listen: false).isLoading,
      child: Material(
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: const Color(0xffEAEBF3),
              appBar: AppBar(
                backgroundColor: const Color(0xffEAEBF3),
                centerTitle: true,
                elevation: 0.0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: const Color(0xff8b3365),
                ),
                title: const Text(
                  'Symptoms',
                  style: const TextStyle(
                    fontFamily: 'RalewayMed',
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff8b3365),
                  ),
                ),
              ),
              body: !_isOnTime
                  ? Container(
                      padding:  const EdgeInsets.all(30),
                      child: Center(
                        child: Text(
                          "You can update your symptoms only twice a day.\n\nMorning 7:00-10:00\nEvening 5:00-8:00",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 19,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    )
                  : _isSingleAndAvailable
                      ? Container(
                          padding:  const EdgeInsets.all(30),
                          child: Center(
                            child: Text(
                              'You have already uploaded your symptoms',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 19,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          padding:  const EdgeInsets.all(30),
                          alignment: Alignment.topCenter,
                          child: ListView.builder(
                            physics: new NeverScrollableScrollPhysics(),
                            itemCount: _profiles.length + 2,
                            itemBuilder: (ctx, i) {
                              i -= 2;
                              if (i == -2) {
                                return Container(
                                  margin: const  EdgeInsets.only(bottom: 20),
                                  height:
                                      MediaQuery.of(context).size.height * 0.18,
                                  child: Image.asset('assets/logo.png'),
                                );
                              }
                              if (i == -1)
                                return Container(
                                  margin: const  EdgeInsets.only(top: 20, bottom: 10),
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "Who is the patient today?",
                                    style: const TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                      color: const Color(0xff000000),
                                    ),
                                  ),
                                );
                              return GestureDetector(
                                onTap: () async {
                                  Provider.of<ScreenController>(context, listen: false)
                                      .setTrue();
                                  int no = 0;
                                  if (TimeOfDay.now().hour >= 7 &&
                                      TimeOfDay.now().hour < 10)
                                    no = 1;
                                  else if (TimeOfDay.now().hour >= 17 &&
                                      TimeOfDay.now().hour < 20) no = 2;
                                  String time =
                                      '${DateTime.now().toString().substring(0, 10)}$no';
                                  final bool _isAvailable =
                                      await Provider.of<SymptomsHistory>(
                                              context,
                                              listen: false)
                                          .isAvailable(_profiles[i].patientID,
                                              time, context);
                                  Provider.of<ScreenController>(context, listen: false)
                                      .setFalse();
                                  if (!_isAvailable) {
                                    Navigator.of(context).pushNamed(
                                        SymptomScreen.route,
                                        arguments: _profiles[i].patientID);
                                  } else {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      barrierColor: Colors.white60,
                                      child: AlertDialog(
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff8b3365),
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ),
                                        const SizedBox(height: 20),
                                            Container(
                                              padding:  const EdgeInsets.symmetric(
                                                horizontal: 40,
                                                vertical: 30,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff8b3365),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    offset: const Offset(6, 6),
                                                    blurRadius: 5,
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                "You have already uploaded your symptoms",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontFamily: 'Raleway',
                                                  fontSize: 21,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width * 0.1,
                                    vertical: 10,
                                  ),
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
                                    borderRadius: BorderRadius.circular(30),
                                    color: const Color(0xffEAEBF3),
                                  ),
                                  padding:  const EdgeInsets.all(10),
                                  child: AutoSizeText(
                                    _profiles[i].name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                      color: const Color(0xff8b3365),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
            if (Provider.of<ScreenController>(context).isLoading)
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
