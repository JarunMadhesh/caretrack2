import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' as svg;
import 'package:neumorphic/neumorphic.dart';

import '../widgets/handwash.dart';

class HygieneTipsScreen extends StatefulWidget {
  static const route = '/HygieneTipsScreen';

  @override
  _HygieneTipsScreen createState() => _HygieneTipsScreen();
}

class _HygieneTipsScreen extends State<HygieneTipsScreen> {
  PageController _pageController = PageController(
    viewportFraction: 0.75,
    initialPage: 0,
    keepPage: true,
  );
  List<String> _assets = [
    'assets/mask/mask1.png',
    'assets/mask/mask2.png',
    'assets/mask/mask3.png',
    'assets/mask/mask4.png',
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffEAEBF3),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xffEAEBF3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: const Color(0xff8b3365),
        ),
        title: const Text(
          'Hygiene Tips',
          style: const TextStyle(
            fontFamily: 'RalewayMed',
            fontWeight: FontWeight.w500,
            color: const Color(0xff8b3365),
          ),
        ),
      ),
      body: Container(
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                '7 steps of hand washing',
                style: const TextStyle(
                  fontFamily: 'RalewayMed',
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff8b3365),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const HandWash(1, 'Apply soap\n'),
                    const HandWash(2, 'Rub your hands\npalm to palm'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const HandWash(3,
                        'With your right palm\nrub the back of\nyour left hand'),
                    const HandWash(4,
                        'Interlace your fingers\nand rub your palms\n together'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const HandWash(5,
                        'Interlock your fingers\nand rub the backs of\nthem with your palms'),
                    const HandWash(6,
                        'Enclose your right hand with your left thumb and rub as you rotate'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const HandWash(7,
                        'Rub your right fingers in a circular motion in your left palm'),
                    Container(
                      width: 100,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: 20, horizontal: width * 0.15),
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
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xffEAEBF3),
                ),
                child: Container(
                  height: 110,
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    const Text(
                      'How long should you wash your hands ?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff000000),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Scrub your hands for at least 20 seconds. Need a timer? Hum the “Happy Birthday” song from beginning to end twice.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 12,
                        color: const Color(0xff8b3365),
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Guide to use mask',
                style: const TextStyle(
                  fontFamily: 'RalewayMed',
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff8b3365),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: width * 0.76,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _assets.length,
                  itemBuilder: (ctx, i) => Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 22, horizontal: 20),
                    child: NeuCard(
                      constraints: BoxConstraints(
                        minHeight: width * 0.81,
                        minWidth: width * 0.81,
                        maxHeight: width * 0.81,
                        maxWidth: width * 0.81,
                      ),
                      curveType: CurveType.flat,
                      decoration: NeumorphicDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        child: Image.asset(_assets[i]),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'The right way to sneeze',
                style: const TextStyle(
                  fontFamily: 'RalewayMed',
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff8b3365),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child:
                            svg.SvgPicture.asset('assets/icons/sneeze1.svg')),
                    Container(
                      width: width * 0.55,
                      child: const Text(
                        'Catch your sneeze,  as it comes with considerable velocity and reach. Catch it in tissue if not a \nhandkerchief.',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 14,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child:
                            svg.SvgPicture.asset('assets/icons/sneeze2.svg')),
                    Container(
                      width: width * 0.55,
                      child: const Text(
                        'If both are not available, use your cupped hand. In Covid a sneeze is highly efficient in dispersing the virus far and wide.',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 14,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    svg.SvgPicture.asset('assets/icons/sneeze3.svg'),
                    Container(
                      width: width * 0.55,
                      child: const Text(
                        'Dispose off the tissue or handkerchief in a designated bin.',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 14,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    svg.SvgPicture.asset('assets/icons/sneeze4.svg'),
                    Container(
                      width: width * 0.55,
                      child: const Text(
                        'Either way, sanitize your  hand with sanitizer or soap and water.',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 14,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.15),
                child: const Text(
                  'Hand sanitizers have to be 70 % alcohol based and must be allowed to dry. It should reach every surface of the hands including tips of fingers, nails and between fingers.',
                  style: const TextStyle(
                    fontFamily: 'RalewayMed',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff8b3365),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: 20, horizontal: width * 0.15),
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
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'Clothes can be disinfected very effectively by  soaking it in 1 % Sodium Hypochlorite- Bleach- and washed  with soap and water, or in a washing machine.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
