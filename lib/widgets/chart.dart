import 'package:caretrack/classes/symtoms.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class Chart extends StatefulWidget {
  final List<Symptoms> symptoms;

  Chart(this.symptoms);
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<charts.Series> seriesList;

  bool animate;

  List<charts.Series<Points, String>> something() {
    List<Points> morning = [];

    List<Points> evening = [];

    widget.symptoms.forEach((element) {
      String date = DateFormat()
          .add_MMMd()
          .format(DateTime.parse(element.time.substring(0, 10)));
      if (element.time[10] == "1") {
        morning.add(Points('$date', (element.points / 42) * 100));
      } else {
        evening.add(Points('$date', (element.points / 42) * 100));
      }
    });

    return [
      new charts.Series<Points, String>(
        id: 'Morning',
        domainFn: (Points sales, _) => sales.time,
        measureFn: (Points sales, _) => sales.points,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xff8b3365)),
        data: morning,
        displayName: "Morning",
      ),
      new charts.Series<Points, String>(
        id: 'Evening',
        domainFn: (Points sales, _) => sales.time,
        measureFn: (Points sales, _) => sales.points,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Color(0xff8b3365).withOpacity(0.3)),
        displayName: "Evening",
        data: evening,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    seriesList = something();
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
      animationDuration: Duration(milliseconds: 300),
      defaultInteractions: false,
      behaviors: [
        new charts.SlidingViewport(),
        new charts.PanAndZoomBehavior(),
        new charts.InitialHintBehavior(
          hintDuration: Duration(milliseconds: 500),
          maxHintTranslate: 3,
        ),
      ],
      domainAxis: new charts.OrdinalAxisSpec(
        showAxisLine: false,
        viewport: new charts.OrdinalViewport('', 3),
      ),
      primaryMeasureAxis: charts.AxisSpec(
        showAxisLine: false,
      ),
    );
  }
}

class Points {
  String time;
  double points;

  Points(this.time, this.points);
}
