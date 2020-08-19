import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neumorphic/neumorphic.dart';


import '../widgets/homeScreenTile.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isContactOpen = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffEAEBF3),
      // floatingActionButton: FloatingActionButton(onPressed: () async{
      //   setState(() {
      //     _isLoading = true;
      //   });
      //   await Provider.of<DBProfileProvider>(context, listen: false).fetchprofiles('9443857628', context);
      //   setState(() {
      //     _isLoading = false;
      //   });
      // }),
      body: _isLoading
          ? Container()
          : Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isContactOpen = _isContactOpen ? false : false;
                    });
                  },
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: MediaQuery.of(context).size.height,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          Container(
                            height: _height * 0.18,
                            child: Image.asset('assets/logo.png'),
                          ),
                          Container(
                            height: _height * 0.6,
                            child: GridView.count(
                              crossAxisCount: 2,
                              physics: new NeverScrollableScrollPhysics(),
                              addAutomaticKeepAlives: true,
                              childAspectRatio: 1,
                              padding: EdgeInsets.only(
                                top: 20,
                                right: _width * 0.11,
                                left: _width * 0.11,
                              ),
                              mainAxisSpacing: 15,
                              children: [
                                HomeScreenTile("Symptoms", "symptoms"),
                                HomeScreenTile("Tracker", "tracker"),
                                HomeScreenTile("Hygiene Tips", "hygiene"),
                                HomeScreenTile("Corona Corner", "viruz"),
                                HomeScreenTile("Profile", "profile"),
                                HomeScreenTile("Feedback", "feedback"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInCubic,
                  bottom: _height * 0.05,
                  right: _isContactOpen ? -10 : -_width * 0.71 + 65,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isContactOpen = _isContactOpen ? false : true;
                      });
                    },
                    child: NeuCard(
                      constraints: BoxConstraints(
                          minHeight: 58, maxWidth: _width * 0.71),
                      curveType: CurveType.flat,
                      decoration: NeumorphicDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff8b3365),
                            ),
                            width: 65,
                            height: 58,
                            padding: const EdgeInsets.all(15),
                            child: SvgPicture.asset('assets/icons/contact.svg',
                                color: Colors.white),
                          ),Container(
                              height: 58,
                              margin: const EdgeInsets.only(left: 20),
                              padding: const EdgeInsets.only(top: 10),
                              alignment: Alignment.center,
                              child: const Text(
                                '093848 46223',
                                style: const TextStyle(
                                  fontFamily: 'Calibre',
                                  fontSize: 23,
                                  color: const Color(0xff000000),
                                ),
                              ),
                            
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Icon(
                              Icons.arrow_right,
                              color: const Color(0xff8b3365),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
