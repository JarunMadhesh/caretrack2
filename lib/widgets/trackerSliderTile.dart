import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;

import 'package:auto_size_text/auto_size_text.dart';
import 'slider.dart';

class TrackerSliderTile extends StatefulWidget {
  final String _title;
  final double _val;
  final bool _isEng;

  TrackerSliderTile(this._title, this._val, this._isEng);

  @override
  _TrackerSliderTileState createState() => _TrackerSliderTileState();
}

class _TrackerSliderTileState extends State<TrackerSliderTile> {
  Color _color = Colors.transparent;

  Color selectColor(double number) {
    if (number == 0)
      return Color(0xff70B030);
    else if (number == 1)
      return Color(0xffE3CF38);
    else if (number == 2)
      return Color(0xffE5AF5B);
    else if (number == 3) return Color(0xffC25B57);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _color = selectColor(widget._val);
    final _width = MediaQuery.of(context).size.width;
    return Container(
      height: 90,
      child: Column(children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: _width * 0.1),
          child: AutoSizeText(
            widget._title,
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
          width: _width * 0.7,
          child: NeumorphicSlider(
            style: SliderStyle(
              borderRadius: BorderRadius.circular(10),
              variant: _color,
              disableDepth: false,
              accent: _color,
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
            max: 3,
            value: widget._val,
          ),
        ),
    const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget._isEng ? 'none' : 'எதுவும் இல்லை',
              style: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: const Color(0xff000000),
              ),
            ),
            Text(
              widget._isEng ? 'mild' : 'லேசான',
              style: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: const Color(0xff000000),
              ),
            ),
            Text(
              widget._isEng ? 'moderate' : 'மிதமான',
              style: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: const Color(0xff000000),
              ),
            ),
            Text(
              widget._isEng ? 'high' : 'கடுமையானது',
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
    );
  }
}

class TrackerSliderTile2 extends StatelessWidget {
  final String _title;
  final double _val;
  final double upperLimit;
  final double lowerLimit;
  final Color _color = Color(0xff8b3365);

  TrackerSliderTile2(this._title, this._val, this.upperLimit, this.lowerLimit);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Container(
      height: 90,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: _width * 0.1),
            child: AutoSizeText(
              _title,
              style: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 25,
                fontWeight: FontWeight.w300,
                color: const Color(0xff8b3365),
              ),
            ),
          ),
          Container(
            width: _width * 0.7,
            child: NeumorphicSlider(
              style: SliderStyle(
                borderRadius: BorderRadius.circular(10),
                variant: _color,
                disableDepth: false,
                accent: _color,
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
              max: upperLimit,
              min: lowerLimit,
              value: _val,
            ),
          ),
      const SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            alignment: Alignment.centerRight,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: _val.toStringAsFixed(2),
                  style: const TextStyle(
                    fontFamily: 'Calibre',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xffb4b4b4),
                  ),
                ),
                TextSpan(
                  text: _title == 'Oxygen saturation ( Spo2 )'
                      ? "%"
                      : _title == 'pulse' ? '  per min.' : " c",
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
    );
  }
}
