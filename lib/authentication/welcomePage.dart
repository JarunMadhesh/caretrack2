
import '../screens/homeScreen.dart';
import 'package:flutter/material.dart';

class WelomePage extends StatefulWidget {
  static const route = '/Welcomepage';

  @override
  _WelomePageState createState() => _WelomePageState();
}

class _WelomePageState extends State<WelomePage> with TickerProviderStateMixin {
  String name = '';

  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    Future.delayed(Duration(milliseconds: 0), () async {
      setState(() {
        name = ModalRoute.of(context).settings.arguments;
        
      });
      await _controller.forward();
      Future.delayed(Duration(seconds: 4), () async {
        await _controller.reverse();
        Navigator.of(context).pushReplacementNamed(HomeScreen.route);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xffEAEBF3),
        body: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.1,
              left: 60,
            ),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (ctx, child) => Opacity(
                opacity: _animation.value,
                child: child,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hello,",
                    style: const TextStyle(
                      fontFamily: "Raleway",
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xffcc2f7a),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: "Raleway",
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff8b3365),
                    ),
                  ),
                  Container(
                    child: const Text(
                      'welcome\nto care\ntrack ',
                      style: const TextStyle(
                        fontFamily: "Raleway",
                        fontSize: 50,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
