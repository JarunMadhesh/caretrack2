import 'package:caretrack/authentication/enterAgeScreen.dart';
import 'package:caretrack/authentication/passwordScreen.dart';
import 'package:caretrack/authentication/setPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'screens/profileScreen.dart';
import 'screens/feedbackScreen.dart';
import 'screens/coronaCornerScreen.dart';
import 'providers/latestSymptoms.dart';
import 'providers/profile.dart';
import 'screens/homeScreen.dart';
import 'screens/newProfile2.dart';
import 'screens/symptomsScreen.dart';
import 'providers/symptomsHistory.dart';
import 'screens/hygieneTipsScreen.dart';
import 'screens/symptomsInitScreen.dart';
import 'screens/trackerScreen.dart';
import 'authentication/phoneNumber.dart';
import 'authentication/selectLanguage.dart';
import 'authentication/selectProfile.dart';
import 'authentication/welcomePage.dart';
import 'providers/dbProfiles.dart';
import 'providers/feedbackProvider.dart';
import 'providers/screenController.dart';
import 'screens/onBoarding.dart';
import 'screens/splashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

Color _color = Color(0xffEAEBF3);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: _color,
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LatestSymtoms()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => SymptomsHistory()),
        ChangeNotifierProvider(create: (_) => DBProfileProvider()),
        ChangeNotifierProvider(create: (_) => SymptomsScreenController()),
        ChangeNotifierProvider(create: (_) => NewProfileScreenController()),
        ChangeNotifierProvider(create: (_) => ScreenController()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
      ],
      child: NeuApp(
        debugShowCheckedModeBanner: false,
        title: 'Care Track',
        theme: NeuThemeData(
          primaryColor: const Color(0xff8b3365),
          backgroundColor: const Color(0xffEAEBF3),
          scaffoldBackgroundColor: _color,
          dialogBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            color: _color,
            textTheme: TextTheme(
              bodyText1: TextStyle(
                fontFamily: "Raleway",
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
        ),
        home: MainScreen(),
        routes: {
          HomeScreen.route: (ctx) => HomeScreen(),
          ProfileScreen.route: (ctx) => ProfileScreen(),
          FeedbackScreen.route: (ctx) => FeedbackScreen(),
          CoronaCorner.route: (ctx) => CoronaCorner(),
          SymptomScreen.route: (ctx) => SymptomScreen(),
          NewProfile2.route: (ctx) => NewProfile2(),
          SymptomInitScreen.route: (ctx) => SymptomInitScreen(),
          TrackerScreen.route: (ctx) => TrackerScreen(),
          HygieneTipsScreen.route: (ctx) => HygieneTipsScreen(),
          OnBoarding.route: (ctx) => OnBoarding(),
          PhoneNumberScreen.route: (ctx) => PhoneNumberScreen(),
          SelectProfileScreen.route: (ctx) => SelectProfileScreen(),
          SelectLanguageScreen.route: (ctx) => SelectLanguageScreen(),
          WelomePage.route: (ctx) => WelomePage(),
          EnterAgeScreen.route: (ctx) => EnterAgeScreen(),
          SetPassword.route: (ctx) => SetPassword(),
          PasswordScreen.route: (ctx) => PasswordScreen(),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoading = true;

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
                Navigator.of(context).pop();
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
                const Text(
                  'Something went wrong.\nCheck your internet.\nKeep calm and try again.',
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
                    padding:  const EdgeInsets.symmetric(vertical: 7, horizontal: 30),
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

  Future init() async {
    try {
      await Provider.of<ProfileProvider>(context, listen: false).getProfiles();
      await Provider.of<LatestSymtoms>(context, listen: false).getSymptoms();
      await Provider.of<SymptomsHistory>(context, listen: false)
          .getSymptoms(context);
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      showDialog(
        context: context,
        barrierColor: Colors.white60,
        child: errorDialogue(init),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () async {
      if (_isLoading) {
        await init();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? SplashScreen()
        : Provider.of<ProfileProvider>(context).profile.length == 0
            ? OnBoarding()
            : HomeScreen();
  }
}
