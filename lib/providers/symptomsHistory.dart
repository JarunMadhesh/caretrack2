import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


import '../classes/symtoms.dart';
import '../providers/exception.dart';
import '../providers/profile.dart';

class SymptomsHistory with ChangeNotifier {
  List<Symptoms> _symptomsHistory = [];

  List<Symptoms> symptoms(String id) {
    return _symptomsHistory.where((element) {
      return element.patientId.substring(0, 14) == id.substring(0, 14);
    }).toList();
  }

  Future<bool> isAvailable(String id, String time, BuildContext context) async {
    await getSymptoms(context);
    Iterable<Symptoms> temp = _symptomsHistory.where((element) {
      return (element.patientId.substring(0, 14) == id.substring(0, 14) &&
          element.time.substring(0, 11) == time.substring(0, 11));
    });
    return temp.length > 0;
  }

  Future submitSymptoms(Symptoms symptom, BuildContext context) async {
    try {
      final url =
          'https://caretrackpd.kauveryhospital.com/caretracksym/api/Values/Covid19AppHMS_Symptoms';
      final response = await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: json.encode(
          {
            'results': [
              {
                'regId': 1,
                'Uhid': symptom.patientId,
                "Time": symptom.time,
                'Severity': symptom.points,
                'Cough': symptom.cough,
                'Diarrhea': symptom.diarrhea,
                'Fatigue': symptom.fatique,
                'Fever': symptom.fever,
                'Headache': symptom.headache,
                'LossofSmell': symptom.lossOfSmell,
                'LossofTaste': symptom.lossOfTaste,
                'MuscleAches': symptom.muscleAches,
                'Oxygen': symptom.oxygen,
                'Pulse': symptom.pulse,
                'RednessofEyes': symptom.rednessOfEyes,
                'ShortnessofBreath': symptom.shortnessOfBreath,
                'Sneezing': symptom.sneezing,
                'SoreThroat': symptom.soreThroat,
                'StomachAche': symptom.stomachAche,
                'Temperature': symptom.temperature,
                'Vomiting': symptom.vomiting,
                'SkinRash': symptom.skinRash ? 1 : 0,
              }
            ]
          },
        ),
      );

      if (response.statusCode != 200) {
        throw MyException('Something went wrong. Keep calm and try again.');
      }
      await getSymptoms(context);
    } catch (err) {
      throw (err);
    }
  }

  Future getSymptomsFromDB(String id) async {
    try {
      final url =
          'https://caretrackpd.kauveryhospital.com/caretracksym/api/Values/Covid19AppHMS_Symptoms';
      final map = {
        "results": [
          {"UHID": id, "Flag": "Select"}
        ]
      };

      final response = await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: json.encode(map),
      );
      if (response.statusCode != 200) {
        throw MyException('Something went wrong. Keep calm and try again.');
      }

      if (response.body.length == 0) {
        return;
      }

      List<Symptoms> _symps = [];
      List<dynamic> responseMap = json.decode(response.body)['results'];
      
      await Future.forEach(
          responseMap,
          (each) => {
                _symps.add(Symptoms(
                  patientId: each['Uhid'],
                  cough: double.parse(each['Cough']),
                  diarrhea: double.parse(each['Diarrhea']),
                  fatique: double.parse(each['Fatigue']),
                  fever: double.parse(each['Fever']),
                  headache: double.parse(each['Headache']),
                  lossOfSmell: double.parse(each['LossofSmell']),
                  lossOfTaste: double.parse(each['LossofTaste']),
                  muscleAches: double.parse(each['MuscleAches']),
                  oxygen: double.parse(each['Oxygen']),
                  points: double.parse(each['Severity']),
                  pulse: double.parse(each['Pulse']),
                  rednessOfEyes: double.parse(each['RednessofEyes']),
                  shortnessOfBreath: double.parse(each['ShortnessofBreath']),
                  sneezing: double.parse(each['Sneezing']),
                  soreThroat: double.parse(each['SoreThroat']),
                  stomachAche: double.parse(each['StomachAche']),
                  temperature: double.parse(each['Temperature']),
                  time: each['Time'],
                  vomiting: double.parse(each['Vomiting']),
                  skinRash: each['SkinRash'] == 1,
                ))
              });
      return _symps;
    } catch (err) {
      throw (err);
    }
  }

  Future getSymptoms(BuildContext context) async {
    try {
      // final db = await symptomsdatabase();
      final List<Profile> _profilesList =
          Provider.of<ProfileProvider>(context, listen: false).profile;
      List<Symptoms> tempList = [];
      await Future.forEach(_profilesList, (element) async {
        List<Symptoms> _tempSymptoms =
            await getSymptomsFromDB(element.patientID);
        if (_tempSymptoms != null) {
          await Future.forEach(_tempSymptoms, (Symptoms element) {
            tempList.add(element);
          });
        }
      });
      _symptomsHistory = tempList;
      notifyListeners();
      // final List<Map<String, dynamic>> profile =
      //     await db.query('symptomsHistory', orderBy: 'time');

      // final List<Symptoms> tempSymptoms = [];
      // if (profile != null)
      //   profile.forEach(
      //     (e) {
      //       tempSymptoms.add(
      //         Symptoms(
      //             patientId: e['patientId'],
      //             time: e['time'],
      //             points: e['points'],
      //             cough: e['cough'],
      //             diarrhea: e['diarrhea'],
      //             fatique: e['fatique'],
      //             fever: e['fever'],
      //             headache: e['headache'],
      //             lossOfSmell: e['lossOfSmell'],
      //             lossOfTaste: e['lossOfTaste'],
      //             muscleAches: e['muscleAches'],
      //             oxygen: e['oxygen'],
      //             pulse: e['pulse'],
      //             rednessOfEyes: e['rednessOfEyes'],
      //             shortnessOfBreath: e['shortnessOfBreath'],
      //             sneezing: e['sneezing'],
      //             soreThroat: e['soreThroat'],
      //             stomachAche: e['stomachAche'],
      //             temperature: e['temperature'],
      //             vomiting: e['vomiting'],
      //             skinRash: e['skinRash'] == 1),
      //       );
      //     },
      //   );
      // _symptomsHistory = tempSymptoms;
    } catch (err) {
      throw (err);
    }
  }

  // Future deleteSymptoms() async {
  //   final db = await symptomsdatabase();
  //   await db.delete('symptomsHistory');
  // }

  // Future<sql.Database> symptomsdatabase() async {
  //   final dbPath = await sql.getDatabasesPath();
  //   return await sql.openDatabase(
  //     path.join(dbPath, 'symptomsHistory.db'),
  //     version: 1,
  //     onCreate: (sql.Database db, version) async {
  //       await db.execute('''CREATE TABLE symptomsHistory(
  //           patientId TEXT,
  //           time TEXT,
  //           points REAL,
  //           fever REAL,
  //           cough REAL,
  //           soreThroat REAL,
  //           shortnessOfBreath REAL,
  //           lossOfSmell REAL,
  //           lossOfTaste REAL,
  //           headache REAL,
  //           fatique REAL,
  //           muscleAches REAL,
  //           sneezing REAL,
  //           diarrhea REAL,
  //           stomachAche REAL,
  //           vomiting REAL,
  //           rednessOfEyes REAL,
  //           oxygen REAL,
  //           pulse REAL,
  //           temperature REAL,
  //           skinRash INT
  //       )''');
  //     },
  //   );
  // }

  // Future updateSymptom(Symptoms symptom, BuildContext context) async {
  //   try {
  //     final db = await symptomsdatabase();
  //     await db.insert(
  //       'symptomsHistory',
  //       {
  //         'patientId': symptom.patientId,
  //         'time': symptom.time,
  //         'points': symptom.points,
  //         'cough': symptom.cough,
  //         'diarrhea': symptom.diarrhea,
  //         'fatique': symptom.fatique,
  //         'fever': symptom.fever,
  //         'headache': symptom.headache,
  //         'lossOfSmell': symptom.lossOfSmell,
  //         'lossOfTaste': symptom.lossOfTaste,
  //         'muscleAches': symptom.muscleAches,
  //         'oxygen': symptom.oxygen,
  //         'pulse': symptom.pulse,
  //         'rednessOfEyes': symptom.rednessOfEyes,
  //         'shortnessOfBreath': symptom.shortnessOfBreath,
  //         'sneezing': symptom.sneezing,
  //         'soreThroat': symptom.soreThroat,
  //         'stomachAche': symptom.stomachAche,
  //         'temperature': symptom.temperature,
  //         'vomiting': symptom.vomiting,
  //         'skinRash': symptom.skinRash ? 1 : 0,
  //       },
  //     );
  //     await getSymptoms(context);
  //   } catch (err) {
  //     throw (err);
  //   }
  // }
}
