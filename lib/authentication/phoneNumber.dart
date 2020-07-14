import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

import 'authentication.dart';
import 'selectProfile.dart';
import '../providers/dbProfiles.dart';
import '../providers/screenController.dart';

class PhoneNumberScreen extends StatefulWidget {
  static const route = '/PhoneNumberScreen';

  @override
  _PhoneNumberScreen createState() => _PhoneNumberScreen();
}

class _PhoneNumberScreen extends State<PhoneNumberScreen>
    with TickerProviderStateMixin {
  String errorText = '';
  bool _gotPhone = false;

  Animation<double> _animation;
  AnimationController _controller;

  TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: '');
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
            padding:  const EdgeInsets.symmetric(
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
                    padding: const  EdgeInsets.symmetric(vertical: 7, horizontal: 30),
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

  void onPhoneSubmit() async {
    try {
      if (_phoneController.text.length == 0 ||
          _phoneController.text.trim().length == 0) {
        setState(() {
          errorText = 'Please enter your phone number';
          return;
        });
      } else if (_phoneController.text.contains(new RegExp(r'[A-Z]')) ||
          _phoneController.text.contains(new RegExp(r'[a-z]')) ||
          _phoneController.text.length != 10) {
        setState(() {
          errorText = 'Please enter a proper phone number';
        });
      } else if (_phoneController.text.trim().contains(' ')) {
        setState(() {
          errorText = 'Enter your phone number without spaces';
        });
      } else {
        setState(() {
          errorText = '';
          Provider.of<ScreenController>(context, listen: false).setTrue();
        });
        await Authenticate().postPhoneNo(_phoneController.text);
        setState(() {
          _gotPhone = true;
          Provider.of<ScreenController>(context, listen: false).setFalse();
        });
      }
    } catch (err) {
      showDialog(
        context: context,
        barrierColor: Colors.white60,
        child: errorDialogue(err.toString(), () {
          onPhoneSubmit();
        }),
      );
    } finally {
      setState(() {
        Provider.of<ScreenController>(context, listen: false).setFalse();
      });
    }
  }

  void onOTPsubmit(otp) async {
    try {
      //ToDo validate...
      setState(() {
        Provider.of<ScreenController>(context, listen: false).setTrue();
      });
      if (otp.length != 4 || otp.trim().length != 4) {
        setState(() {
          errorText = 'Please a valid otp';
          return;
        });
      }
      await Provider.of<DBProfileProvider>(context, listen: false)
          .fetchprofiles(_phoneController.text, otp, context);
      setState(() {
        Provider.of<ScreenController>(context, listen: false).setFalse();
      });
      Navigator.of(context).pushReplacementNamed(SelectProfileScreen.route,
          arguments: _phoneController.text);
    } catch (err) {
      showDialog(
        context: context,
        barrierColor: Colors.white60,
        child: errorDialogue(err.toString(), () {
          onOTPsubmit(otp);
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
    _phoneController.dispose();
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
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _gotPhone
                            ? 'Enter key'
                            : 'Enter your registered mobile number in the hospital',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _gotPhone
                        ? NeuCard(
                            constraints: const BoxConstraints(minHeight: 46),
                            curveType: CurveType.emboss,
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 5),
                            alignment: Alignment.centerLeft,
                            decoration: NeumorphicDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: OTPTextField(
                              fieldStyle: FieldStyle.underline,
                              keyboardType: TextInputType.number,
                              length: 4,
                              width: width * 0.55,
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              onCompleted: onOTPsubmit,
                              style: const TextStyle(
                                fontFamily: 'Calibre',
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff8b3365),
                              ),
                            ),
                          )
                        : NeuCard(
                            constraints: const BoxConstraints(minHeight: 46),
                            curveType: CurveType.emboss,
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 5),
                            alignment: Alignment.centerLeft,
                            decoration: NeumorphicDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding:  const EdgeInsets.only(left: 0, right: 10),
                                  child: Text(
                                    "+91",
                                    style: const TextStyle(
                                      fontFamily: 'Calibre',
                                      fontSize: 21,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff8b3365),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    validator: (str) {
                                      if (str.length == 0 ||
                                          str.trim().length == 0) {}
                                      return null;
                                    },
                                    controller: _phoneController,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.phone,
                                    onFieldSubmitted: (str) {
                                      onPhoneSubmit();
                                    },
                                    onSaved: (str) {
                                      onPhoneSubmit();
                                    },
                                    style: const TextStyle(
                                      fontFamily: 'Calibre',
                                      fontSize: 21,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff8b3365),
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    cursorColor: const Color(0xff8b3365),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 20),
                    Text(
                      errorText,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.red,
                      ),
                    ),
                    if (errorText != '') const SizedBox(height: 20),
                    if (!_gotPhone)
                      Container(
                        width: 127,
                        child: NeuButton(
                          onPressed: () {
                            onPhoneSubmit();
                          },
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
                    if (_gotPhone)
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '*The key is/was sent to your registered mobile number through sms.',
                          style: const TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    if (_gotPhone) const SizedBox(height: 15),
                    if (_gotPhone)
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Kindly save your key for future references related to this mobile number.",
                          style: const TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 15,
                            color: const Color(0xff8b3365),
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
