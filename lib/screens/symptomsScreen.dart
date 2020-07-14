import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../providers/profile.dart';
import '../providers/screenController.dart';
import '../widgets/symtomTIle.dart';

class SymptomScreen extends StatefulWidget {
  static const route = '/SymptomScreen';

  @override
  _SymptomScreenState createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen>
    with TickerProviderStateMixin {
  DateTime time;
  bool _isEng = true;

  Animation<double> _animation;
  AnimationController _controller;

  String _time = "";

  @override
  void initState() {
    super.initState();
    int no = 0;
    if (TimeOfDay.now().hour >= 7 && TimeOfDay.now().hour < 10)
      no = 1;
    else if (TimeOfDay.now().hour >= 17 && TimeOfDay.now().hour < 20) no = 2;
    _time = '${DateTime.now().toString().substring(0, 10)} $no';
    Future.delayed(Duration(seconds: 0), () {
      _controller = AnimationController(
          vsync: this, duration: Duration(milliseconds: 700));
      _animation = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
      setState(() {
        _isEng = Provider.of<ProfileProvider>(context, listen: false)
                .profile
                .firstWhere((element) =>
                    element.patientID ==
                    ModalRoute.of(context).settings.arguments)
                .language ==
            'English';
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration(milliseconds: 0), () async {
      while (Provider.of<SymptomsScreenController>(context, listen: false)
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xffEAEBF3),
          appBar: AppBar(
            backgroundColor: const Color(0xffEAEBF3),
            centerTitle: true,
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              color: const Color(0xff8b3365),
            ),
            title: Text(
              _isEng ? 'Symptoms' : 'அறிகுறிகள்',
              style: TextStyle(
                fontFamily: 'RalewayMed',
                fontSize: _isEng ? 21 : 18,
                fontWeight: FontWeight.w300,
                color: const Color(0xff8b3365),
              ),
            ),
          ),
          body: ModalRoute.of(context).settings.arguments == null
              ? Container(
                  child: Center(child: Text("Loading..")),
                )
              : SymptomTile(ModalRoute.of(context).settings.arguments, _time),
        ),
        if (Provider.of<SymptomsScreenController>(context).isLoading)
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
    );
  }
}
