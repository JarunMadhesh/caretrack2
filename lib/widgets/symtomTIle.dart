import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../classes/symtoms.dart';
import '../providers/exception.dart';
import '../providers/latestSymptoms.dart';
import '../providers/profile.dart';
import '../providers/screenController.dart';
import '../providers/symptomsHistory.dart';
import 'slider.dart';

class SymptomTile extends StatefulWidget {
  final String id;
  final String time;
  SymptomTile(this.id, this.time);

  @override
  _SymptomTileState createState() => _SymptomTileState();
}

class _SymptomTileState extends State<SymptomTile>
    with TickerProviderStateMixin {
  bool _isError = false;
  bool _isEng = true;
  double _fever = 0.0;
  double _cough = 0.0;
  double _soreThroat = 0.0;
  double _shortnessOfBreath = 0.0;
  double _lossOfSmell = 0.0;
  double _lossOfTaste = 0.0;
  double _headache = 0.0;
  double _fatique = 0.0;
  double _muscleAches = 0.0;
  double _sneezing = 0.0;
  double _diarrhea = 0.0;
  double _stomachAche = 0.0;
  double _vomiting = 0.0;
  double _rednessOfEyes = 0.0;
  bool _skinRash = false;
  double _oxygen = 0.0;
  double _pulse = 0.0;
  double _temperature = 0.0;

  Color fever;
  Color cough;
  Color soreThroat;
  Color shortnessOfBreath;
  Color lossOfSmell;
  Color lossOfTaste;
  Color headache;
  Color fatique;
  Color muscleAches;
  Color sneezing;
  Color diarrhea;
  Color stomachAche;
  Color vomiting;
  Color rednessOfEyes;
  Color skinRash;
  Color oxygen;
  Color pulse;
  Color temperature;

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
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 30),
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

  Future save() async {
    try {
      Provider.of<SymptomsScreenController>(context, listen: false).setTrue();
      // await Future.delayed(Duration(seconds: 0));
      await Provider.of<LatestSymtoms>(context, listen: false).updateSymptom(
        Symptoms(
          patientId: widget.id,
          fever: _fever,
          cough: _cough,
          soreThroat: _soreThroat,
          shortnessOfBreath: _shortnessOfBreath,
          time: widget.time,
          lossOfSmell: _lossOfSmell,
          lossOfTaste: _lossOfTaste,
          headache: _headache,
          fatique: _fatique,
          muscleAches: _muscleAches,
          sneezing: _sneezing,
          diarrhea: _diarrhea,
          stomachAche: _stomachAche,
          vomiting: _vomiting,
          rednessOfEyes: _rednessOfEyes,
          skinRash: _skinRash,
          oxygen: _oxygen,
          pulse: _pulse,
          temperature: _temperature,
        ),
      );
      Provider.of<SymptomsScreenController>(context, listen: false).setFalse();
    } catch (err) {
      Provider.of<SymptomsScreenController>(context, listen: false).setFalse();
      showDialog(
        context: context,
        barrierColor: Colors.white60,
        child: errorDialogue(save),
      );
    } finally {
      Provider.of<SymptomsScreenController>(context, listen: false).setFalse();
    }
  }

  Future submit() async {
    try {
      Symptoms symptom = Symptoms(
        patientId: widget.id,
        fever: _fever,
        points: _fever +
            _cough +
            _soreThroat +
            _shortnessOfBreath +
            _lossOfSmell +
            _lossOfTaste +
            _headache +
            _fatique +
            _muscleAches +
            _sneezing +
            _diarrhea +
            _stomachAche +
            _vomiting +
            _rednessOfEyes,
        time: widget.time,
        cough: _cough,
        soreThroat: _soreThroat,
        shortnessOfBreath: _shortnessOfBreath,
        lossOfSmell: _lossOfSmell,
        lossOfTaste: _lossOfTaste,
        headache: _headache,
        fatique: _fatique,
        muscleAches: _muscleAches,
        sneezing: _sneezing,
        diarrhea: _diarrhea,
        stomachAche: _stomachAche,
        vomiting: _vomiting,
        rednessOfEyes: _rednessOfEyes,
        skinRash: _skinRash,
        oxygen: _oxygen,
        pulse: _pulse,
        temperature: _temperature,
      );
      Provider.of<SymptomsScreenController>(context, listen: false).setTrue();
      final bool _isAvailable =
          await Provider.of<SymptomsHistory>(context, listen: false)
              .isAvailable(widget.id, widget.time, context, true);
      if (_isAvailable) {
        throw MyException('Already exists');
      }
      await Provider.of<SymptomsHistory>(context, listen: false)
          .submitSymptoms(symptom, context);
      await Provider.of<LatestSymtoms>(context, listen: false)
          .setZero(widget.id);
      Navigator.of(context).pop();
      Navigator.of(context).pop('Successfully submitted your symptoms');
    } catch (err) {
      Provider.of<SymptomsScreenController>(context, listen: false).setFalse();
      if (err.toString() == "Already exists") {
        Navigator.of(context).pop();
        Navigator.of(context).pop('You have already submitted your sumptoms');
      } else {
        showDialog(
          context: context,
          barrierColor: Colors.white60,
          child: errorDialogue(submit),
        );
      }
    } finally {
      Provider.of<SymptomsScreenController>(context, listen: false).setFalse();
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(microseconds: 0), () {
      final Symptoms sym = Provider.of<LatestSymtoms>(context, listen: false)
          .latestSymtoms(widget.id);
      _isEng = Provider.of<ProfileProvider>(context, listen: false)
              .profile
              .firstWhere((element) => element.patientID == widget.id)
              .language ==
          'English';
      if (sym != null) {
        _fever = sym.fever;
        if (sym.fever == 0.0)
          fever = Color(0xff70B030);
        else if (sym.fever == 1.0)
          fever = Color(0xffE3CF38);
        else if (sym.fever == 2.0)
          fever = Color(0xffE5AF5B);
        else if (sym.fever == 3.0) fever = Color(0xffC25B57);

        _cough = sym.cough;
        if (sym.cough == 0)
          cough = Color(0xff70B030);
        else if (sym.cough == 1)
          cough = Color(0xffE3CF38);
        else if (sym.cough == 2)
          cough = Color(0xffE5AF5B);
        else if (sym.cough == 3) cough = Color(0xffC25B57);

        _soreThroat = sym.soreThroat;
        if (sym.soreThroat == 0)
          soreThroat = Color(0xff70B030);
        else if (sym.soreThroat == 1)
          soreThroat = Color(0xffE3CF38);
        else if (sym.soreThroat == 2)
          soreThroat = Color(0xffE5AF5B);
        else if (sym.soreThroat == 3) soreThroat = Color(0xffC25B57);

        _shortnessOfBreath = sym.shortnessOfBreath;
        if (sym.shortnessOfBreath == 0)
          shortnessOfBreath = Color(0xff70B030);
        else if (sym.shortnessOfBreath == 1)
          shortnessOfBreath = Color(0xffE3CF38);
        else if (sym.shortnessOfBreath == 2)
          shortnessOfBreath = Color(0xffE5AF5B);
        else if (sym.shortnessOfBreath == 3)
          shortnessOfBreath = Color(0xffC25B57);

        _lossOfSmell = sym.lossOfSmell;
        if (sym.lossOfSmell == 0)
          lossOfSmell = Color(0xff70B030);
        else if (sym.lossOfSmell == 1)
          lossOfSmell = Color(0xffE3CF38);
        else if (sym.lossOfSmell == 2)
          lossOfSmell = Color(0xffE5AF5B);
        else if (sym.lossOfSmell == 3) lossOfSmell = Color(0xffC25B57);

        _lossOfTaste = sym.lossOfTaste;
        if (sym.lossOfTaste == 0)
          lossOfTaste = Color(0xff70B030);
        else if (sym.lossOfTaste == 1)
          lossOfTaste = Color(0xffE3CF38);
        else if (sym.lossOfTaste == 2)
          lossOfTaste = Color(0xffE5AF5B);
        else if (sym.lossOfTaste == 3) lossOfTaste = Color(0xffC25B57);

        _headache = sym.headache;
        if (sym.headache == 0)
          headache = Color(0xff70B030);
        else if (sym.headache == 1)
          headache = Color(0xffE3CF38);
        else if (sym.headache == 2)
          headache = Color(0xffE5AF5B);
        else if (sym.headache == 3) headache = Color(0xffC25B57);

        _fatique = sym.fatique;
        if (sym.fatique == 0)
          fatique = Color(0xff70B030);
        else if (sym.fatique == 1)
          fatique = Color(0xffE3CF38);
        else if (sym.fatique == 2)
          fatique = Color(0xffE5AF5B);
        else if (sym.fatique == 3) fatique = Color(0xffC25B57);

        _muscleAches = sym.muscleAches;
        if (sym.muscleAches == 0)
          muscleAches = Color(0xff70B030);
        else if (sym.muscleAches == 1)
          muscleAches = Color(0xffE3CF38);
        else if (sym.muscleAches == 2)
          muscleAches = Color(0xffE5AF5B);
        else if (sym.muscleAches == 3) muscleAches = Color(0xffC25B57);

        _sneezing = sym.sneezing;
        if (sym.sneezing == 0)
          sneezing = Color(0xff70B030);
        else if (sym.sneezing == 1)
          sneezing = Color(0xffE3CF38);
        else if (sym.sneezing == 2)
          sneezing = Color(0xffE5AF5B);
        else if (sym.sneezing == 3) sneezing = Color(0xffC25B57);

        _diarrhea = sym.diarrhea;
        if (sym.diarrhea == 0)
          diarrhea = Color(0xff70B030);
        else if (sym.diarrhea == 1)
          diarrhea = Color(0xffE3CF38);
        else if (sym.diarrhea == 2)
          diarrhea = Color(0xffE5AF5B);
        else if (sym.diarrhea == 3) diarrhea = Color(0xffC25B57);

        _stomachAche = sym.stomachAche;
        if (sym.stomachAche == 0)
          stomachAche = Color(0xff70B030);
        else if (sym.stomachAche == 1)
          stomachAche = Color(0xffE3CF38);
        else if (sym.stomachAche == 2)
          stomachAche = Color(0xffE5AF5B);
        else if (sym.stomachAche == 3) stomachAche = Color(0xffC25B57);

        _vomiting = sym.vomiting;
        if (sym.vomiting == 0)
          vomiting = Color(0xff70B030);
        else if (sym.vomiting == 1)
          vomiting = Color(0xffE3CF38);
        else if (sym.vomiting == 2)
          vomiting = Color(0xffE5AF5B);
        else if (sym.vomiting == 3) vomiting = Color(0xffC25B57);

        _rednessOfEyes = sym.rednessOfEyes;
        if (sym.rednessOfEyes == 0)
          rednessOfEyes = Color(0xff70B030);
        else if (sym.rednessOfEyes == 1)
          rednessOfEyes = Color(0xffE3CF38);
        else if (sym.rednessOfEyes == 2)
          rednessOfEyes = Color(0xffE5AF5B);
        else if (sym.rednessOfEyes == 3) rednessOfEyes = Color(0xffC25B57);

        _skinRash = sym.skinRash;
        _oxygen = sym.oxygen;
        _pulse = sym.pulse;
        _temperature = sym.temperature;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Container(
      height: _height,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Container(
              height: 90,
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: _width * 0.15),
                  child: AutoSizeText(
                    _isEng ? "Fever" : "காய்ச்சல்",
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: _width * 0.77,
                  child: NeumorphicSlider(
                    style: SliderStyle(
                      borderRadius: BorderRadius.circular(10),
                      variant: fever,
                      disableDepth: false,
                      accent: fever,
                    ),
                    thumb: neu.Neumorphic(
                      style: neu.NeumorphicStyle(
                        disableDepth: false,
                        shape: neu.NeumorphicShape.flat,
                        color: Colors.white,
                        boxShape: neu.NeumorphicBoxShape.circle(),
                      ),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                      ),
                    ),
                    max: 3,
                    onChanged: (number) {
                      setState(
                        () {
                          if (number >= 0 && number < 0.6)
                            number = 0;
                          else if (number >= 0.6 && number < 1.5)
                            number = 1;
                          else if (number >= 1.5 && number < 2.4)
                            number = 2;
                          else if (number >= 2.4 && number <= 3) number = 3;

                          _fever = number;

                          if (number == 0)
                            fever = Color(0xff70B030);
                          else if (number == 1)
                            fever = Color(0xffE3CF38);
                          else if (number == 2)
                            fever = Color(0xffE5AF5B);
                          else if (number == 3) fever = Color(0xffC25B57);
                        },
                      );
                    },
                    value: _fever,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _isEng ? 'none' : 'எதுவும் இல்லை',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'mild' : 'லேசான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'moderate' : 'மிதமான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'high' : 'கடுமையானது',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    )
                  ],
                ),
              ]),
            ),
            Container(
              height: 90,
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: _width * 0.15),
                  child: AutoSizeText(
                    _isEng ? "Cough" : "இருமல்",
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: _width * 0.77,
                  child: NeumorphicSlider(
                    style: SliderStyle(
                      borderRadius: BorderRadius.circular(10),
                      variant: cough,
                      disableDepth: false,
                      accent: cough,
                    ),
                    thumb: neu.Neumorphic(
                      style: neu.NeumorphicStyle(
                        disableDepth: false,
                        shape: neu.NeumorphicShape.flat,
                        color: Colors.white,
                        boxShape: neu.NeumorphicBoxShape.circle(),
                      ),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                      ),
                    ),
                    max: 3,
                    onChanged: (number) {
                      setState(
                        () {
                          if (number >= 0 && number < 0.6)
                            number = 0;
                          else if (number >= 0.6 && number < 1.5)
                            number = 1;
                          else if (number >= 1.5 && number < 2.4)
                            number = 2;
                          else if (number >= 2.4 && number <= 3) number = 3;

                          _cough = number;

                          if (number == 0)
                            cough = Color(0xff70B030);
                          else if (number == 1)
                            cough = Color(0xffE3CF38);
                          else if (number == 2)
                            cough = Color(0xffE5AF5B);
                          else if (number == 3) cough = Color(0xffC25B57);
                        },
                      );
                    },
                    value: _cough,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _isEng ? 'none' : 'எதுவும் இல்லை',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'mild' : 'லேசான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'moderate' : 'மிதமான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'high' : 'கடுமையானது',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    )
                  ],
                ),
              ]),
            ),
            Container(
              height: 90,
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: _width * 0.15),
                  child: AutoSizeText(
                    _isEng ? "Sore Throat" : 'தொண்டை வலி',
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: _width * 0.77,
                  child: NeumorphicSlider(
                    style: SliderStyle(
                        borderRadius: BorderRadius.circular(10),
                        variant: soreThroat,
                        disableDepth: false,
                        accent: soreThroat),
                    thumb: neu.Neumorphic(
                      style: neu.NeumorphicStyle(
                        disableDepth: false,
                        shape: neu.NeumorphicShape.flat,
                        color: Colors.white,
                        boxShape: neu.NeumorphicBoxShape.circle(),
                      ),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                      ),
                    ),
                    max: 3,
                    onChanged: (number) {
                      setState(
                        () {
                          if (number >= 0 && number < 0.6)
                            number = 0;
                          else if (number >= 0.6 && number < 1.5)
                            number = 1;
                          else if (number >= 1.5 && number < 2.4)
                            number = 2;
                          else if (number >= 2.4 && number <= 3) number = 3;

                          _soreThroat = number;

                          if (number == 0)
                            soreThroat = Color(0xff70B030);
                          else if (number == 1)
                            soreThroat = Color(0xffE3CF38);
                          else if (number == 2)
                            soreThroat = Color(0xffE5AF5B);
                          else if (number == 3) soreThroat = Color(0xffC25B57);
                        },
                      );
                    },
                    value: _soreThroat,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _isEng ? 'none' : 'எதுவும் இல்லை',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'mild' : 'லேசான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'moderate' : 'மிதமான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'high' : 'கடுமையானது',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    )
                  ],
                ),
              ]),
            ),
            Container(
              height: 90,
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: _width * 0.15),
                  child: AutoSizeText(
                    _isEng ? "Shortness Of Breath" : "மூச்சுத் திணறல்",
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: _width * 0.77,
                  child: NeumorphicSlider(
                    style: SliderStyle(
                      borderRadius: BorderRadius.circular(10),
                      variant: shortnessOfBreath,
                      disableDepth: false,
                      accent: shortnessOfBreath,
                    ),
                    thumb: neu.Neumorphic(
                      style: neu.NeumorphicStyle(
                        disableDepth: false,
                        shape: neu.NeumorphicShape.flat,
                        color: Colors.white,
                        boxShape: neu.NeumorphicBoxShape.circle(),
                      ),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                      ),
                    ),
                    max: 3,
                    onChanged: (number) {
                      setState(
                        () {
                          if (number >= 0 && number < 0.6)
                            number = 0;
                          else if (number >= 0.6 && number < 1.5)
                            number = 1;
                          else if (number >= 1.5 && number < 2.4)
                            number = 2;
                          else if (number >= 2.4 && number <= 3) number = 3;

                          _shortnessOfBreath = number;

                          if (number == 0)
                            shortnessOfBreath = Color(0xff70B030);
                          else if (number == 1)
                            shortnessOfBreath = Color(0xffE3CF38);
                          else if (number == 2)
                            shortnessOfBreath = Color(0xffE5AF5B);
                          else if (number == 3)
                            shortnessOfBreath = Color(0xffC25B57);
                        },
                      );
                    },
                    value: _shortnessOfBreath,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _isEng ? 'none' : 'எதுவும் இல்லை',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'mild' : 'லேசான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'moderate' : 'மிதமான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'high' : 'கடுமையானது',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    )
                  ],
                ),
              ]),
            ),
            Container(
              height: 90,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: _width * 0.15),
                    child: AutoSizeText(
                      _isEng ? "Loss of smell" : 'வாசனை இழப்பு',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: _width * 0.77,
                    child: NeumorphicSlider(
                      style: SliderStyle(
                        borderRadius: BorderRadius.circular(10),
                        variant: lossOfSmell,
                        disableDepth: false,
                        accent: lossOfSmell,
                      ),
                      thumb: neu.Neumorphic(
                        style: neu.NeumorphicStyle(
                          disableDepth: false,
                          shape: neu.NeumorphicShape.flat,
                          color: Colors.white,
                          boxShape: neu.NeumorphicBoxShape.circle(),
                        ),
                        child: SizedBox(
                          height: 25,
                          width: 25,
                        ),
                      ),
                      max: 3,
                      onChanged: (number) {
                        setState(
                          () {
                            if (number >= 0 && number < 0.6)
                              number = 0;
                            else if (number >= 0.6 && number < 1.5)
                              number = 1;
                            else if (number >= 1.5 && number < 2.4)
                              number = 2;
                            else if (number >= 2.4 && number <= 3) number = 3;

                            _lossOfSmell = number;

                            if (number == 0)
                              lossOfSmell = Color(0xff70B030);
                            else if (number == 1)
                              lossOfSmell = Color(0xffE3CF38);
                            else if (number == 2)
                              lossOfSmell = Color(0xffE5AF5B);
                            else if (number == 3)
                              lossOfSmell = Color(0xffC25B57);
                          },
                        );
                      },
                      value: _lossOfSmell,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        _isEng ? 'none' : 'எதுவும் இல்லை',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff000000),
                        ),
                      ),
                      Text(
                        _isEng ? 'mild' : 'லேசான',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff000000),
                        ),
                      ),
                      Text(
                        _isEng ? 'moderate' : 'மிதமான',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff000000),
                        ),
                      ),
                      Text(
                        _isEng ? 'high' : 'கடுமையானது',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff000000),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 90,
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: _width * 0.15),
                  child: AutoSizeText(
                    _isEng ? "Loss of taste" : "சுவை இழப்பு",
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: _width * 0.77,
                  child: NeumorphicSlider(
                    style: SliderStyle(
                      borderRadius: BorderRadius.circular(10),
                      variant: lossOfTaste,
                      disableDepth: false,
                      accent: lossOfTaste,
                    ),
                    thumb: neu.Neumorphic(
                      style: neu.NeumorphicStyle(
                        disableDepth: false,
                        shape: neu.NeumorphicShape.flat,
                        color: Colors.white,
                        boxShape: neu.NeumorphicBoxShape.circle(),
                      ),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                      ),
                    ),
                    max: 3,
                    onChanged: (number) {
                      setState(
                        () {
                          if (number >= 0 && number < 0.6)
                            number = 0;
                          else if (number >= 0.6 && number < 1.5)
                            number = 1;
                          else if (number >= 1.5 && number < 2.4)
                            number = 2;
                          else if (number >= 2.4 && number <= 3) number = 3;

                          _lossOfTaste = number;

                          if (number == 0)
                            lossOfTaste = Color(0xff70B030);
                          else if (number == 1)
                            lossOfTaste = Color(0xffE3CF38);
                          else if (number == 2)
                            lossOfTaste = Color(0xffE5AF5B);
                          else if (number == 3) lossOfTaste = Color(0xffC25B57);
                        },
                      );
                    },
                    value: _lossOfTaste,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _isEng ? 'none' : 'எதுவும் இல்லை',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'mild' : 'லேசான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'moderate' : 'மிதமான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'high' : 'கடுமையானது',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    )
                  ],
                ),
              ]),
            ),
            Container(
              height: 90,
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: _width * 0.15),
                  child: AutoSizeText(
                    _isEng ? "Headache" : 'தலைவலி',
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: _width * 0.77,
                  child: NeumorphicSlider(
                    style: SliderStyle(
                      borderRadius: BorderRadius.circular(10),
                      variant: headache,
                      disableDepth: false,
                      accent: headache,
                    ),
                    thumb: neu.Neumorphic(
                      style: neu.NeumorphicStyle(
                        disableDepth: false,
                        shape: neu.NeumorphicShape.flat,
                        color: Colors.white,
                        boxShape: neu.NeumorphicBoxShape.circle(),
                      ),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                      ),
                    ),
                    max: 3,
                    onChanged: (number) {
                      setState(
                        () {
                          if (number >= 0 && number < 0.6)
                            number = 0;
                          else if (number >= 0.6 && number < 1.5)
                            number = 1;
                          else if (number >= 1.5 && number < 2.4)
                            number = 2;
                          else if (number >= 2.4 && number <= 3) number = 3;

                          _headache = number;

                          if (number == 0)
                            headache = Color(0xff70B030);
                          else if (number == 1)
                            headache = Color(0xffE3CF38);
                          else if (number == 2)
                            headache = Color(0xffE5AF5B);
                          else if (number == 3) headache = Color(0xffC25B57);
                        },
                      );
                    },
                    value: _headache,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _isEng ? 'none' : 'எதுவும் இல்லை',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'mild' : 'லேசான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'moderate' : 'மிதமான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'high' : 'கடுமையானது',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    )
                  ],
                ),
              ]),
            ),
            Container(
              height: 90,
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: _width * 0.15),
                  child: AutoSizeText(
                    _isEng ? "Fatigue or Tiredness" : 'சோர்வு',
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: _width * 0.77,
                  child: NeumorphicSlider(
                    style: SliderStyle(
                      borderRadius: BorderRadius.circular(10),
                      variant: fatique,
                      disableDepth: false,
                      accent: fatique,
                    ),
                    thumb: neu.Neumorphic(
                      style: neu.NeumorphicStyle(
                        disableDepth: false,
                        shape: neu.NeumorphicShape.flat,
                        color: Colors.white,
                        boxShape: neu.NeumorphicBoxShape.circle(),
                      ),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                      ),
                    ),
                    max: 3,
                    onChanged: (number) {
                      setState(
                        () {
                          if (number >= 0 && number < 0.6)
                            number = 0;
                          else if (number >= 0.6 && number < 1.5)
                            number = 1;
                          else if (number >= 1.5 && number < 2.4)
                            number = 2;
                          else if (number >= 2.4 && number <= 3) number = 3;

                          _fatique = number;

                          if (number == 0)
                            fatique = Color(0xff70B030);
                          else if (number == 1)
                            fatique = Color(0xffE3CF38);
                          else if (number == 2)
                            fatique = Color(0xffE5AF5B);
                          else if (number == 3) fatique = Color(0xffC25B57);
                        },
                      );
                    },
                    value: _fatique,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _isEng ? 'none' : 'எதுவும் இல்லை',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'mild' : 'லேசான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'moderate' : 'மிதமான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'high' : 'கடுமையானது',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    )
                  ],
                ),
              ]),
            ),
            Container(
              height: 90,
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: _width * 0.15),
                  child: AutoSizeText(
                    _isEng ? "Muscle Aches" : 'தசை வலிகள்',
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: _width * 0.77,
                  child: NeumorphicSlider(
                    style: SliderStyle(
                      borderRadius: BorderRadius.circular(10),
                      variant: muscleAches,
                      disableDepth: false,
                      accent: muscleAches,
                    ),
                    thumb: neu.Neumorphic(
                      style: neu.NeumorphicStyle(
                        disableDepth: false,
                        shape: neu.NeumorphicShape.flat,
                        color: Colors.white,
                        boxShape: neu.NeumorphicBoxShape.circle(),
                      ),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                      ),
                    ),
                    max: 3,
                    onChanged: (number) {
                      setState(
                        () {
                          if (number >= 0 && number < 0.6)
                            number = 0;
                          else if (number >= 0.6 && number < 1.5)
                            number = 1;
                          else if (number >= 1.5 && number < 2.4)
                            number = 2;
                          else if (number >= 2.4 && number <= 3) number = 3;

                          _muscleAches = number;

                          if (number == 0)
                            muscleAches = Color(0xff70B030);
                          else if (number == 1)
                            muscleAches = Color(0xffE3CF38);
                          else if (number == 2)
                            muscleAches = Color(0xffE5AF5B);
                          else if (number == 3) muscleAches = Color(0xffC25B57);
                        },
                      );
                    },
                    value: _muscleAches,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _isEng ? 'none' : 'எதுவும் இல்லை',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'mild' : 'லேசான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'moderate' : 'மிதமான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'high' : 'கடுமையானது',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    )
                  ],
                ),
              ]),
            ),
            Container(
              height: 90,
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: _width * 0.15),
                  child: AutoSizeText(
                    _isEng ? "Sneezing" : 'தும்மல்',
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: _width * 0.77,
                  child: NeumorphicSlider(
                    style: SliderStyle(
                      borderRadius: BorderRadius.circular(10),
                      variant: sneezing,
                      disableDepth: false,
                      accent: sneezing,
                    ),
                    thumb: neu.Neumorphic(
                      style: neu.NeumorphicStyle(
                        disableDepth: false,
                        shape: neu.NeumorphicShape.flat,
                        color: Colors.white,
                        boxShape: neu.NeumorphicBoxShape.circle(),
                      ),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                      ),
                    ),
                    max: 3,
                    onChanged: (number) {
                      setState(
                        () {
                          if (number >= 0 && number < 0.6)
                            number = 0;
                          else if (number >= 0.6 && number < 1.5)
                            number = 1;
                          else if (number >= 1.5 && number < 2.4)
                            number = 2;
                          else if (number >= 2.4 && number <= 3) number = 3;

                          _sneezing = number;

                          if (number == 0)
                            sneezing = Color(0xff70B030);
                          else if (number == 1)
                            sneezing = Color(0xffE3CF38);
                          else if (number == 2)
                            sneezing = Color(0xffE5AF5B);
                          else if (number == 3) sneezing = Color(0xffC25B57);
                        },
                      );
                    },
                    value: _sneezing,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _isEng ? 'none' : 'எதுவும் இல்லை',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'mild' : 'லேசான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'moderate' : 'மிதமான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'high' : 'கடுமையானது',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    )
                  ],
                ),
              ]),
            ),
            Container(
              height: 90,
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: _width * 0.15),
                  child: AutoSizeText(
                    _isEng ? "Diarrhea" : 'வயிற்றுப்போக்கு',
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: _width * 0.77,
                  child: NeumorphicSlider(
                    style: SliderStyle(
                      borderRadius: BorderRadius.circular(10),
                      variant: diarrhea,
                      disableDepth: false,
                      accent: diarrhea,
                    ),
                    thumb: neu.Neumorphic(
                      style: neu.NeumorphicStyle(
                        disableDepth: false,
                        shape: neu.NeumorphicShape.flat,
                        color: Colors.white,
                        boxShape: neu.NeumorphicBoxShape.circle(),
                      ),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                      ),
                    ),
                    max: 3,
                    onChanged: (number) {
                      setState(
                        () {
                          if (number >= 0 && number < 0.6)
                            number = 0;
                          else if (number >= 0.6 && number < 1.5)
                            number = 1;
                          else if (number >= 1.5 && number < 2.4)
                            number = 2;
                          else if (number >= 2.4 && number <= 3) number = 3;

                          _diarrhea = number;

                          if (number == 0)
                            diarrhea = Color(0xff70B030);
                          else if (number == 1)
                            diarrhea = Color(0xffE3CF38);
                          else if (number == 2)
                            diarrhea = Color(0xffE5AF5B);
                          else if (number == 3) diarrhea = Color(0xffC25B57);
                        },
                      );
                    },
                    value: _diarrhea,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _isEng ? 'none' : 'எதுவும் இல்லை',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'mild' : 'லேசான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'moderate' : 'மிதமான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'high' : 'கடுமையானது',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    )
                  ],
                ),
              ]),
            ),
            Container(
              height: 90,
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: _width * 0.15),
                  child: AutoSizeText(
                    _isEng ? "Stomach Ache" : 'வயிற்று வலி',
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: _width * 0.77,
                  child: NeumorphicSlider(
                    style: SliderStyle(
                      borderRadius: BorderRadius.circular(10),
                      variant: stomachAche,
                      disableDepth: false,
                      accent: stomachAche,
                    ),
                    thumb: neu.Neumorphic(
                      style: neu.NeumorphicStyle(
                        disableDepth: false,
                        shape: neu.NeumorphicShape.flat,
                        color: Colors.white,
                        boxShape: neu.NeumorphicBoxShape.circle(),
                      ),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                      ),
                    ),
                    max: 3,
                    onChanged: (number) {
                      setState(
                        () {
                          if (number >= 0 && number < 0.6)
                            number = 0;
                          else if (number >= 0.6 && number < 1.5)
                            number = 1;
                          else if (number >= 1.5 && number < 2.4)
                            number = 2;
                          else if (number >= 2.4 && number <= 3) number = 3;

                          _stomachAche = number;

                          if (number == 0)
                            stomachAche = Color(0xff70B030);
                          else if (number == 1)
                            stomachAche = Color(0xffE3CF38);
                          else if (number == 2)
                            stomachAche = Color(0xffE5AF5B);
                          else if (number == 3) stomachAche = Color(0xffC25B57);
                        },
                      );
                    },
                    value: _stomachAche,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _isEng ? 'none' : 'எதுவும் இல்லை',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'mild' : 'லேசான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'moderate' : 'மிதமான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'high' : 'கடுமையானது',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    )
                  ],
                ),
              ]),
            ),
            Container(
              height: 90,
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: _width * 0.15),
                  child: AutoSizeText(
                    _isEng ? "Vomiting" : 'வாந்தி',
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: _width * 0.77,
                  child: NeumorphicSlider(
                    style: SliderStyle(
                      borderRadius: BorderRadius.circular(10),
                      variant: vomiting,
                      disableDepth: false,
                      accent: vomiting,
                    ),
                    thumb: neu.Neumorphic(
                      style: neu.NeumorphicStyle(
                        disableDepth: false,
                        shape: neu.NeumorphicShape.flat,
                        color: Colors.white,
                        boxShape: neu.NeumorphicBoxShape.circle(),
                      ),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                      ),
                    ),
                    max: 3,
                    onChanged: (number) {
                      setState(
                        () {
                          if (number >= 0 && number < 0.6)
                            number = 0;
                          else if (number >= 0.6 && number < 1.5)
                            number = 1;
                          else if (number >= 1.5 && number < 2.4)
                            number = 2;
                          else if (number >= 2.4 && number <= 3) number = 3;

                          _vomiting = number;

                          if (number == 0)
                            vomiting = Color(0xff70B030);
                          else if (number == 1)
                            vomiting = Color(0xffE3CF38);
                          else if (number == 2)
                            vomiting = Color(0xffE5AF5B);
                          else if (number == 3) vomiting = Color(0xffC25B57);
                        },
                      );
                    },
                    value: _vomiting,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _isEng ? 'none' : 'எதுவும் இல்லை',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'mild' : 'லேசான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'moderate' : 'மிதமான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'high' : 'கடுமையானது',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    )
                  ],
                ),
              ]),
            ),
            Container(
              height: 90,
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: _width * 0.15),
                  child: AutoSizeText(
                    _isEng ? "Redness of eyes" : 'கண்களின் சிவத்தல்',
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: _width * 0.77,
                  child: NeumorphicSlider(
                    style: SliderStyle(
                      borderRadius: BorderRadius.circular(10),
                      variant: rednessOfEyes,
                      disableDepth: false,
                      accent: rednessOfEyes,
                    ),
                    thumb: neu.Neumorphic(
                      style: neu.NeumorphicStyle(
                        disableDepth: false,
                        shape: neu.NeumorphicShape.flat,
                        color: Colors.white,
                        boxShape: neu.NeumorphicBoxShape.circle(),
                      ),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                      ),
                    ),
                    max: 3,
                    onChanged: (number) {
                      setState(
                        () {
                          if (number >= 0 && number < 0.6)
                            number = 0;
                          else if (number >= 0.6 && number < 1.5)
                            number = 1;
                          else if (number >= 1.5 && number < 2.4)
                            number = 2;
                          else if (number >= 2.4 && number <= 3) number = 3;

                          _rednessOfEyes = number;

                          if (number == 0)
                            rednessOfEyes = Color(0xff70B030);
                          else if (number == 1)
                            rednessOfEyes = Color(0xffE3CF38);
                          else if (number == 2)
                            rednessOfEyes = Color(0xffE5AF5B);
                          else if (number == 3)
                            rednessOfEyes = Color(0xffC25B57);
                        },
                      );
                    },
                    value: _rednessOfEyes,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _isEng ? 'none' : 'எதுவும் இல்லை',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'mild' : 'லேசான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'moderate' : 'மிதமான',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      _isEng ? 'high' : 'கடுமையானது',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    )
                  ],
                ),
              ]),
            ),
            const SizedBox(height: 20),
            Container(
              constraints: BoxConstraints(minHeight: 58),
              margin: EdgeInsets.symmetric(horizontal: _width * 0.12),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(width: 10),
                  Container(
                    alignment: Alignment.center,
                    width: _width * 0.43,
                    padding: const EdgeInsets.all(10),
                    child: AutoSizeText(
                      _isEng ? 'Fresh skin rash' : 'புதிய தோல் சொறி',
                      maxLines: 1,
                      maxFontSize: 16,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  CupertinoSwitch(
                    value: _skinRash,
                    activeColor: const Color(0xff8b3365),
                    onChanged: (newbool) {
                      _skinRash = newbool;
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              constraints: BoxConstraints(minHeight: 58),
              margin: EdgeInsets.only(
                right: _width * 0.12,
                left: _width * 0.12,
                bottom: 20,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 30,
                      bottom: 10,
                    ),
                    child: AutoSizeText(
                      _isEng ? 'Oximeter reading' : 'ஆக்சிமீட்டர் வாசிப்பு',
                      maxLines: 1,
                      maxFontSize: 28,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: AutoSizeText(
                            _isEng
                                ? 'Oxygen saturation ( Spo2 )'
                                : 'ஆக்ஸிஜன் செறிவு ( Spo2 )',
                            style: const TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          child: NeumorphicSlider(
                            style: SliderStyle(
                              borderRadius: BorderRadius.circular(10),
                              variant: Color(0xff8b3365),
                              disableDepth: false,
                              accent: Color(0xff8b3365),
                            ),
                            thumb: neu.Neumorphic(
                              style: neu.NeumorphicStyle(
                                disableDepth: false,
                                shape: neu.NeumorphicShape.flat,
                                color: Colors.white,
                                boxShape: neu.NeumorphicBoxShape.circle(),
                              ),
                              child: SizedBox(
                                height: 25,
                                width: 25,
                              ),
                            ),
                            max: 100,
                            min: 80,
                            onChanged: (number) {
                              setState(
                                () {
                                  _oxygen = number;
                                },
                              );
                            },
                            value: _oxygen,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${_oxygen.toStringAsFixed(2)}%',
                            style: const TextStyle(
                              fontFamily: 'Calibre',
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xffb4b4b4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: AutoSizeText(
                            _isEng
                                ? 'Pulse rate ( PRbpm )'
                                : 'துடிப்பு வீதம் (PRbpm)',
                            style: const TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          child: NeumorphicSlider(
                            style: SliderStyle(
                              borderRadius: BorderRadius.circular(10),
                              variant: Color(0xff8b3365),
                              disableDepth: false,
                              accent: Color(0xff8b3365),
                            ),
                            thumb: neu.Neumorphic(
                              style: neu.NeumorphicStyle(
                                disableDepth: false,
                                shape: neu.NeumorphicShape.flat,
                                color: Colors.white,
                                boxShape: neu.NeumorphicBoxShape.circle(),
                              ),
                              child: SizedBox(
                                height: 25,
                                width: 25,
                              ),
                            ),
                            max: 150,
                            min: 50,
                            onChanged: (number) {
                              setState(
                                () {
                                  _pulse = number;
                                },
                              );
                            },
                            value: _pulse,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: _pulse.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontFamily: 'Calibre',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xffb4b4b4),
                                ),
                              ),
                              TextSpan(
                                text: '  per min.',
                                style: const TextStyle(
                                  fontFamily: 'Calibre',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xffb4b4b4),
                                ),
                              )
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(minHeight: 58),
              margin: EdgeInsets.symmetric(horizontal: _width * 0.12),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: AutoSizeText(
                      _isEng ? 'Temperature' : 'வெப்ப நிலை',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: NeumorphicSlider(
                      style: SliderStyle(
                        borderRadius: BorderRadius.circular(10),
                        variant: Color(0xff8b3365),
                        disableDepth: false,
                        accent: Color(0xff8b3365),
                      ),
                      thumb: neu.Neumorphic(
                        style: neu.NeumorphicStyle(
                          disableDepth: false,
                          shape: neu.NeumorphicShape.flat,
                          color: Colors.white,
                          boxShape: neu.NeumorphicBoxShape.circle(),
                        ),
                        child: SizedBox(
                          height: 25,
                          width: 25,
                        ),
                      ),
                      max: 103,
                      min: 95,
                      onChanged: (number) {
                        setState(
                          () {
                            _temperature = number;
                          },
                        );
                      },
                      value: _temperature,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${_temperature.toStringAsFixed(2)} c',
                      style: const TextStyle(
                        fontFamily: 'Calibre',
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xffb4b4b4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: _width * 0.12,
              ),
              child: _isError
                  ? Text(
                      _isEng
                          ? "*Please make sure you entered your Oximeter readings and Temperature"
                          : "உங்கள் ஆக்சிமீட்டர் அளவீடுகள் மற்றும் வெப்பநிலையை உள்ளிட்டுள்ளீர்கள் என்பதை உறுதிப்படுத்தவும்",
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.red,
                      ),
                    )
                  : Container(),
            ),
            GestureDetector(
              onTap: () async {
                if (_oxygen == 0 || _pulse == 0 || _temperature == 0) {
                  setState(() {
                    _isError = true;
                  });
                } else {
                  setState(() {
                    _isError = false;
                  });
                  showDialog(
                    context: context,
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
                                Text(
                                  _isEng
                                      ? 'Are you sure you want to submit your symptoms?'
                                      : "உங்கள் அறிகுறிகளை சமர்ப்பிக்க விரும்புகிறீர்களா?",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 21,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _isEng
                                      ? "*Symtoms cannot be changed once you submit"
                                      : "*நீங்கள் சமர்ப்பித்தவுடன் குறியீடுகளை மாற்ற முடியாது",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 14,
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
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Text(
                                          _isEng ? "Cancel" : "இல்லை",
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
                                        await save();
                                        await submit();
                                        //TODo: Submit it in the database
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Text(
                                          _isEng ? "Confirm" : "ஆம்",
                                          style: const TextStyle(
                                            fontFamily: 'Raleway',
                                            color: const Color(0xff8b3365),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
              child: Container(
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
                  borderRadius: BorderRadius.circular(40),
                  color: const Color(0xffEAEBF3),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Text(
                  _isEng ? " Submit " : 'சமர்ப்பிக்கவும்',
                  style: const TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xff8B3365),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                if (_oxygen == 0 || _pulse == 0 || _temperature == 0) {
                  setState(() {
                    _isError = true;
                  });
                } else {
                  setState(() {
                    _isError = false;
                  });
                  showDialog(
                    context: context,
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
                                Text(
                                  _isEng
                                      ? 'Are you sure you want to save your symptoms?'
                                      : "அறிகுறிகளை சமர்ப்பிக்காமல் உங்கள் மொபைலில் சேமிக்க விரும்புகிறீர்களா?",
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
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Text(
                                          _isEng ? "Cancel" : "இல்லை",
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
                                        await save();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop(
                                            'Successfully saved your symptoms');
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Text(
                                          _isEng ? "Confirm" : "ஆம்",
                                          style: const TextStyle(
                                            fontFamily: 'Raleway',
                                            color: const Color(0xff8b3365),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Text(
                  _isEng ? " Save " : 'பதிவு',
                  style: const TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
