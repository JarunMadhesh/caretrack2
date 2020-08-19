import 'package:caretrack/authentication/phoneNumber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neumorphic/neumorphic.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

import 'authentication.dart';
import 'selectProfile.dart';
import '../providers/dbProfiles.dart';
import '../providers/screenController.dart';

class PasswordScreen extends StatefulWidget {
  static const route = '/PasswordScreen';

  @override
  _PasswordScreen createState() => _PasswordScreen();
}

class _PasswordScreen extends State<PasswordScreen>
    with TickerProviderStateMixin {
  String errorText = '';
  String phoneNumber = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Animation<double> _animation;
  AnimationController _controller;

  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      phoneNumber = ModalRoute.of(context).settings.arguments;
    });
    _passwordController = TextEditingController(text: '');
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
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
                    if (errorString != 'Invalid Password') {
                      function();
                    }
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

  void onPasswordSubmit() async {
    try {
      setState(() {
        Provider.of<ScreenController>(context, listen: false).setTrue();
      });
      if (_passwordController.text.length < 7) {
        setState(() {
          errorText = "Enter a valid password";
        });
        return;
      }
      setState(() {
        errorText = '';
      });
      await Provider.of<DBProfileProvider>(context, listen: false)
          .fetchprofiles(phoneNumber, _passwordController.text, context);
      setState(() {
        Provider.of<ScreenController>(context, listen: false).setFalse();
      });
      Navigator.of(context).pushReplacementNamed(SelectProfileScreen.route,
          arguments: phoneNumber);
    } catch (err) {
      showDialog(
        context: _scaffoldKey.currentContext,
        barrierColor: Colors.white60,
        child: errorDialogue(err.toString(), () {
          onPasswordSubmit();
        }),
      );
    } finally {
      setState(() {
        Provider.of<ScreenController>(context, listen: false).setFalse();
      });
    }
  }

  void onForgotPassword() async {
    try {
      setState(() {
        Provider.of<ScreenController>(context, listen: false).setTrue();
      });
      await Authenticate().resendOTP(phoneNumber, context);
      Navigator.of(context).pushReplacementNamed(PhoneNumberScreen.route,
          arguments: phoneNumber);
    } catch (err) {
      showDialog(
        context: context,
        barrierColor: Colors.white60,
        child: errorDialogue(err.toString(), () {
          onForgotPassword();
        }),
      );
    } finally {
      setState(() {
        Provider.of<ScreenController>(context, listen: false).setFalse();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    change();
    return WillPopScope(
      onWillPop: () async =>
          !Provider.of<ScreenController>(context, listen: false).isLoading,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xffEAEBF3),
        body: Stack(
          children: [
            Container(
              height: height,
              width: width,
              padding: EdgeInsets.only(
                left: width * 0.15,
                right: width * 0.15,
              ),
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: height * 0.19),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      height: MediaQuery.of(context).size.height * 0.18,
                      child: Image.asset('assets/logo.png'),
                    ),
                    const SizedBox(height: 20),
                    NeuCard(
                      constraints: const BoxConstraints(minHeight: 46),
                      curveType: CurveType.emboss,
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                      alignment: Alignment.centerLeft,
                      decoration: NeumorphicDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        autofocus: true,
                        controller: _passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (str) {
                          onPasswordSubmit();
                        },
                        onSaved: (str) {
                          onPasswordSubmit();
                        },
                        style: const TextStyle(
                          fontFamily: 'Calibre',
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff8b3365),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter password",
                          hintStyle: const TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        cursorColor: const Color(0xff8b3365),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: onForgotPassword,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot Password?",
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      errorText,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.red,
                      ),
                    ),
                    if (errorText != '') const SizedBox(height: 20),
                    Container(
                      width: 127,
                      child: NeuButton(
                        onPressed: onPasswordSubmit,
                        decoration: NeumorphicDecoration(
                            borderRadius: BorderRadius.circular(40)),
                        child: const Text(
                          'Submit ',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xff8b3365),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
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
