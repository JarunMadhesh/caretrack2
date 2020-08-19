import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';

import '../authentication/phoneNumber.dart';

class OnBoarding extends StatefulWidget {
  static const route = '/onBoarding';

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<Widget> introWidgetsList = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 0), () {
      introWidgetsList = <Widget>[
        NeuCard(
          decoration:
              NeumorphicDecoration(borderRadius: BorderRadius.circular(20)),
          bevel: 12,
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: MediaQuery.of(context).size.height * 0.2),
          child: Image.asset(
            'assets/onBoarding/1.png',
            fit: BoxFit.cover,
          ),
        ),
        NeuCard(
          decoration:
              NeumorphicDecoration(borderRadius: BorderRadius.circular(20)),
          bevel: 12,
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: MediaQuery.of(context).size.height * 0.2),
          child: Image.asset(
            'assets/onBoarding/2.png',
            fit: BoxFit.cover,
          ),
        ),
        NeuCard(
          decoration:
              NeumorphicDecoration(borderRadius: BorderRadius.circular(20)),
          bevel: 12,
          margin: EdgeInsets.symmetric(
              horizontal: 30,
              vertical: MediaQuery.of(context).size.height * 0.2),
          child: Image.asset(
            'assets/onBoarding/3.png',
            fit: BoxFit.cover,
          ),
        ),
        NeuCard(
          decoration:
              NeumorphicDecoration(borderRadius: BorderRadius.circular(20)),
          bevel: 12,
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: MediaQuery.of(context).size.height * 0.2),
          child: Image.asset(
            'assets/onBoarding/4.png',
            fit: BoxFit.cover,
          ),
        ),
        NeuCard(
          decoration:
              NeumorphicDecoration(borderRadius: BorderRadius.circular(20)),
          bevel: 12,
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: MediaQuery.of(context).size.height * 0.2),
          child: Image.asset(
            'assets/onBoarding/5.png',
            fit: BoxFit.cover,
          ),
        ),
      ];
      setState(() {});
    });
  }

  final PageController controller = PageController();
  int currentPageValue = 0;

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 9 : 6,
      width: isActive ? 9 : 6,
      decoration: BoxDecoration(
          color:
              isActive ? Color(0xff8b3365) : Color(0xff8b3365).withOpacity(0.4),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAEBF3),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          PageView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: introWidgetsList.length,
            onPageChanged: (int page) {
              getChangedPageAndMoveBar(page);
            },
            controller: controller,
            itemBuilder: (context, index) {
              return introWidgetsList[index];
            },
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.15,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < introWidgetsList.length; i++)
                  if (i == currentPageValue) ...[circleBar(true)] else
                    circleBar(false),
              ],
            ),
          ),
          Positioned(
            bottom: 25,
            child: currentPageValue == introWidgetsList.length - 1
                ? FloatingActionButton(
                    backgroundColor: const Color(0xffEAEBF3),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(PhoneNumberScreen.route);
                    },
                    child: const Icon(
                      Icons.arrow_forward,
                      color: const Color(0xff8b3365),
                    ),
                  )
                : Container(
                    child: FlatButton(
                      child: Text(
                        "Skip",
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff8b3365),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(PhoneNumberScreen.route);
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
