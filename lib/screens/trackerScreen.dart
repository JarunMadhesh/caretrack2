import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:provider/provider.dart';

import '../widgets/trackerTile.dart';
import '../classes/symtoms.dart';
import '../providers/profile.dart';
import '../providers/symptomsHistory.dart';
import '../widgets/chart.dart';

class TrackerScreen extends StatefulWidget {
  static const route = '/TrackerScreen';
  final PageController _pageController = PageController(
    viewportFraction: 0.75,
    initialPage: 0,
    keepPage: true,
  );

  @override
  _TrackerScreenState createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  List<Profile> _profile = [];

  List<Symptoms> _symptoms = [];

  bool _isEng = true;

  int selectedIndex = -1;

  String id = '';

  void init() {
    _symptoms = Provider.of<SymptomsHistory>(context, listen: false)
        .symptoms(id)
        .reversed
        .toList();
    _isEng = Provider.of<ProfileProvider>(context, listen: false)
            .profile
            .firstWhere((element) => element.patientID == id)
            .language ==
        'English';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0), () {
      _profile = Provider.of<ProfileProvider>(context, listen: false).profile;
      id = _profile[0].patientID;
      init();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffEAEBF3),
      appBar: NeuAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: const Color(0xff8b3365),
        ),
        title: const Text(
          'Tracker',
          style: const TextStyle(
            fontFamily: 'RalewayMed',
            fontWeight: FontWeight.w500,
            color: const Color(0xff8b3365),
          ),
        ),
      ),
      body: Container(
        child: id.length == 0
            ? Container()
            : Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      child: PageView.builder(
                        controller: widget._pageController,
                        pageSnapping: true,
                        onPageChanged: (int index) {
                          id = _profile[index].patientID;
                          setState(() {
                            selectedIndex = -1;
                            init();
                          });
                        },
                        allowImplicitScrolling: false,
                        itemCount: _profile.length,
                        itemBuilder: (ctx, i) => Container(
                          constraints: BoxConstraints(
                            minHeight: 58,
                            maxWidth: _width * 0.61,
                            maxHeight: 58,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              const BoxShadow(
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
                            color: const Color(0xffEAEBF3),
                          ),
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 20,
                            right: 20,
                          ),
                          child: Text(
                            _profile[i].name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff8b3365),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 186,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        cacheExtent: 30,
                        addAutomaticKeepAlives: true,
                        itemCount: _symptoms.length + 2,
                        itemBuilder: (ctx, i) {
                          i -= 2;
                          if (i == -2) {
                            return Container();
                          }
                          if (i == -1) {
                            return _symptoms.length == 0
                                ? Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.2),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "You have no symptoms history",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 23,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 30),
                                    constraints: BoxConstraints(
                                        minHeight: 58, maxWidth: _width * 0.81),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        const BoxShadow(
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
                                      color: const Color(0xffEAEBF3),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      height: 300,
                                      child: Chart(_symptoms),
                                    ),
                                  );
                          }
                          String dateTime = _symptoms[i].time;
                          DateTime _date =
                              DateTime.parse(dateTime.substring(0, 10));
                          String _time = dateTime[10];
                          return GestureDetector(
                            onTap: () {
                              if (selectedIndex == i) {
                                selectedIndex = -1;
                              } else {
                                selectedIndex = i;
                              }

                              setState(() {});
                            },
                            child: TrackerTile(_symptoms[i], _date, _time,
                                _isEng, selectedIndex == i),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
