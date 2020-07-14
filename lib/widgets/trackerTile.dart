import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;

import '../classes/symtoms.dart';
import 'slider.dart';
import 'trackerSliderTile.dart';

class TrackerTile extends StatefulWidget {
  final Symptoms symptoms;
  final DateTime date;
  final String time;
  final bool _isEng;
  final bool _isOpen;

  TrackerTile(this.symptoms, this.date, this.time, this._isEng, this._isOpen);

  @override
  _TrackerTIleState createState() => _TrackerTIleState();
}

class _TrackerTIleState extends State<TrackerTile> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        constraints: BoxConstraints(minHeight: 55, maxWidth: _width * 0.81),
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
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: 3,
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                '${DateFormat.yMMMMd().format(widget.date)} ${widget.time == '1' ? "Morning" : "Evening"}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Calibre',
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xff8b3365),
                ),
              ),
            ),
            if (widget._isOpen)
              Column(
                children: [
                  const SizedBox(height: 20),
                  TrackerSliderTile(widget._isEng ? "Fever" : "காய்ச்சல்",
                      widget.symptoms.fever, widget._isEng),
                  TrackerSliderTile(widget._isEng ? "Cough" : "இருமல்",
                      widget.symptoms.cough, widget._isEng),
                  TrackerSliderTile(
                      widget._isEng ? "Sore Throat" : 'தொண்டை வலி',
                      widget.symptoms.soreThroat,
                      widget._isEng),
                  TrackerSliderTile(
                      widget._isEng ? "Shortness Of Breath" : "மூச்சுத் திணறல்",
                      widget.symptoms.shortnessOfBreath,
                      widget._isEng),
                  TrackerSliderTile(
                      widget._isEng ? "Loss of smell" : 'வாசனை இழப்பு',
                      widget.symptoms.lossOfSmell,
                      widget._isEng),
                  TrackerSliderTile(
                      widget._isEng ? "Loss of taste" : "சுவை இழப்பு",
                      widget.symptoms.lossOfTaste,
                      widget._isEng),
                  TrackerSliderTile(widget._isEng ? "Headache" : 'தலைவலி',
                      widget.symptoms.headache, widget._isEng),
                  TrackerSliderTile(
                      widget._isEng ? "Fatigue or Tiredness" : 'சோர்வு',
                      widget.symptoms.fatique,
                      widget._isEng),
                  TrackerSliderTile(
                      widget._isEng ? "Muscle Aches" : 'தசை வலிகள்',
                      widget.symptoms.muscleAches,
                      widget._isEng),
                  TrackerSliderTile(widget._isEng ? "Sneezing" : 'தும்மல்',
                      widget.symptoms.sneezing, widget._isEng),
                  TrackerSliderTile(
                      widget._isEng ? "Diarrhea" : 'வயிற்றுப்போக்கு',
                      widget.symptoms.diarrhea,
                      widget._isEng),
                  TrackerSliderTile(
                      widget._isEng ? "Stomach Ache" : 'வயிற்று வலி',
                      widget.symptoms.stomachAche,
                      widget._isEng),
                  TrackerSliderTile(widget._isEng ? "Vomiting" : 'வாந்தி',
                      widget.symptoms.vomiting, widget._isEng),
                  TrackerSliderTile(
                      widget._isEng ? "Redness of eyes" : 'கண்களின் சிவத்தல்',
                      widget.symptoms.rednessOfEyes,
                      widget._isEng),
                  Container(
                    constraints: const BoxConstraints(minHeight: 55),
                    margin: EdgeInsets.symmetric(horizontal: _width * 0.06),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(width: 10),
                        Container(
                          alignment: Alignment.center,
                          width: _width * 0.4,
                          padding: const EdgeInsets.all(10),
                          child: AutoSizeText(
                            widget._isEng
                                ? 'Fresh skin rash'
                                : 'புதிய தோல் சொறி',
                            maxLines: 1,
                            maxFontSize: 18,
                            style: const TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff0000000),
                            ),
                          ),
                        ),
                        CupertinoSwitch(
                          value: widget.symptoms.skinRash,
                          activeColor: const Color(0xff8b3365),
                          onChanged: (newbool) {},
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    constraints: BoxConstraints(minHeight: 58),
                    margin: EdgeInsets.only(
                      right: _width * 0.06,
                      left: _width * 0.06,
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
                            bottom: 10,
                            left: 30,
                          ),
                          child: AutoSizeText(
                            widget._isEng
                                ? 'Oximeter reading'
                                : 'ஆக்சிமீட்டர் வாசிப்பு',
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
                        const SizedBox(width: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: AutoSizeText(
                                  widget._isEng
                                      ? 'Oxygen saturation ( Spo2 )'
                                      : 'ஆக்ஸிஜன் செறிவு ( Spo2 )',
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
                                      height: 21,
                                      width: 21,
                                    ),
                                  ),
                                  max: 100,
                                  min: 80,
                                  onChanged: (number) {},
                                  value: widget.symptoms.oxygen,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${widget.symptoms.oxygen.toStringAsFixed(2)}%',
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
                                  widget._isEng
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
                                      height: 21,
                                      width: 21,
                                    ),
                                  ),
                                  max: 150,
                                  min: 50,
                                  onChanged: (number) {},
                                  value: widget.symptoms.pulse,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: widget.symptoms.pulse
                                          .toStringAsFixed(2),
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
                    margin: EdgeInsets.symmetric(horizontal: _width * 0.06),
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
                            widget._isEng ? 'Temperature' : 'வெப்ப நிலை',
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
                                height: 21,
                                width: 21,
                              ),
                            ),
                            max: 103,
                            min: 95,
                            value: widget.symptoms.temperature,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${widget.symptoms.temperature.toStringAsFixed(2)} c',
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
                ],
              ),
            if (widget._isOpen) SizedBox(height: 20),
            Container(
              child: Icon(
                widget._isOpen ? Icons.expand_less : Icons.expand_more,
                size: 16,
                color: const Color(0xff8b3365),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
