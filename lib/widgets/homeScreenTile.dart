import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../screens/coronaCornerScreen.dart';
import '../screens/feedbackScreen.dart';
import '../screens/hygieneTipsScreen.dart';
import '../screens/profileScreen.dart';
import '../screens/symptomsInitScreen.dart';
import '../screens/trackerScreen.dart';

class HomeScreenTile extends StatelessWidget {
  final String title;
  final String fileName;

  HomeScreenTile(this.title, this.fileName);

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Container(
      height: _height * 0.157,
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              switch (title) {
                case "Symptoms":
                  {
                    final result = await Navigator.of(context)
                        .pushNamed(SymptomInitScreen.route);
                    if (result!=null) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 3),
                        content: Text(
                          result,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            color: Colors.white,
                          ),
                        ),
                      ));
                    }
                    break;
                  }
                case "Tracker":
                  {
                    Navigator.of(context).pushNamed(TrackerScreen.route);
                    break;
                  }
                case "Hygiene Tips":
                  {
                    Navigator.of(context).pushNamed(HygieneTipsScreen.route);
                    break;
                  }
                case "Corona Corner":
                  {
                    Navigator.of(context).pushNamed(CoronaCorner.route);
                    break;
                  }
                case "Profile":
                  {
                    Navigator.of(context).pushNamed(ProfileScreen.route);
                    break;
                  }
                case "Feedback":
                  {
                    final result = await Navigator.of(context)
                        .pushNamed(FeedbackScreen.route);
                    if (result) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 3),
                        content: Text(
                          'Thank you for your feedback !',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            color: Colors.white,
                          ),
                        ),
                      ));
                    }
                    break;
                  }
                default:
                  break;
              }
            },
            child: Container(
              child: Container(
                child: Transform.scale(
                  scale: (title == 'Tracker' || title == 'Profile') ? 0.9 : 1,
                  child: SvgPicture.asset('assets/icons/$fileName.svg'),
                ),
                padding:  const EdgeInsets.all(27),
              ),
              width: _width * 0.265,
              height: _width * 0.265,
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
                color: const Color(0xffEAEBF3),
              ),
            ),
          ),
      const SizedBox(height: 10),
          Container(
            height: 20,
            child: AutoSizeText(
              title,
              maxLines: 1,
              style: const TextStyle(
                fontFamily: 'RalewayMed',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xff000000),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
