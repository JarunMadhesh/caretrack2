import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:provider/provider.dart';

import '../providers/feedbackProvider.dart';
import '../providers/profile.dart';
import '../providers/screenController.dart';

class FeedbackScreen extends StatefulWidget {
  static const route = '/FeedbackScreen';

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with TickerProviderStateMixin {
  double height;
  double width;

  Animation<double> _animation;
  AnimationController _controller;

  String feedback;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
  }

  @override
  void dispose() {
    if (_formKey.currentState != null) _formKey.currentState.dispose();
    _controller.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
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
                  const BoxShadow(
                    color: Colors.grey,
                    offset: const Offset(2, 2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.close),
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
                  const BoxShadow(
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
                          EdgeInsets.symmetric(vertical: 7, horizontal: 30),
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

    Future postFeedback() async {
      try {
        setState(() {
          Provider.of<ScreenController>(context, listen: false).setTrue();
        });
        await Future.delayed(Duration(seconds: 3));
        await Provider.of<FeedbackProvider>(context, listen: false)
            .postFeedback(
          Provider.of<ProfileProvider>(context, listen: false)
              .profile[0]
              .patientID,
          feedback,
        );
        Provider.of<ScreenController>(context, listen: false).setFalse();
        Navigator.of(context).pop(true);
      } catch (err) {
        showDialog(
          context: context,
          barrierColor: Colors.white60,
          child: errorDialogue(postFeedback),
        );
      } finally {
        Provider.of<ScreenController>(context, listen: false).setFalse();
      }
    }

    void onSubmit() {
      if (!_formKey.currentState.validate()) {
        return;
      }
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
                    const Text(
                      'Are you sure you want to submit your feedback?',
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
                            child: const Text(
                              "Cancel",
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Navigator.of(context).pop();
                            postFeedback();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Text(
                              "Confirm",
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

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async =>
          !Provider.of<ScreenController>(context, listen: false).isLoading,
      child: Material(
        child: Stack(
          children: [
            Scaffold(
              key: scaffoldKey,
              backgroundColor: const Color(0xffEAEBF3),
              appBar: NeuAppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: const Color(0xff8b3365),
                ),
                title: const Text(
                  'Feedback',
                  style: const TextStyle(
                    fontFamily: 'RalewayMed',
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff8b3365),
                  ),
                ),
              ),
              body: Container(
                margin:
                    EdgeInsets.only(left: width * 0.17, right: width * 0.17),
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: height * 0.1),
                    const Text(
                      'Enter your feedback',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff000000),
                      ),
                    ),
                    const SizedBox(height: 10),
                    NeuCard(
                      curveType: CurveType.emboss,
                      bevel: 12,
                      padding: const EdgeInsets.all(10),
                      decoration: NeumorphicDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          maxLines: 6,
                          onChanged: (str) {
                            feedback = str;
                          },
                          validator: (str) {
                            if (str.length <= 5 || str.trim().length <= 5) {
                              return "     Please enter your feedback before you submit";
                            }
                            return null;
                          },
                          cursorColor: const Color(0xff8b3365),
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                            color: const Color(0xff8b3365),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            errorStyle: const TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 9.5,
                              fontWeight: FontWeight.w100,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: 127,
                      child: NeuButton(
                        onPressed: onSubmit,
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
                    Spacer(),
                  ],
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
