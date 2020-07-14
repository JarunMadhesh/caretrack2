import '../classes/symtoms.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class LatestSymtoms with ChangeNotifier {
  List<Symptoms> _symptoms = [];

  Future<sql.Database> symptomsdatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbPath, 'symptomsDatabase.db'),
      version: 1,
      onCreate: (sql.Database db, version) async {
        await db.execute('''CREATE TABLE symptoms(
            patientId TEXT PRIMARY KEY,
            fever REAL,
            cough REAL,
            soreThroat REAL,
            shortnessOfBreath REAL,
            lossOfSmell REAL,
            lossOfTaste REAL,
            headache REAL,
            fatique REAL,
            muscleAches REAL,
            sneezing REAL,
            diarrhea REAL,
            stomachAche REAL,
            vomiting REAL,
            rednessOfEyes REAL,
            oxygen REAL,
            pulse REAL,
            temperature REAL,
            skinRash INT
        )''');
      },
    );
  }

  Future addNewSymtomProfile(String id) async {
    try {
      final db = await symptomsdatabase();
      await db.insert(
        'symptoms',
        {
          'patientId': id,
          'cough': 0.0,
          'diarrhea': 0.0,
          'fatique': 0.0,
          'fever': 0.0,
          'headache': 0.0,
          'lossOfSmell': 0.0,
          'lossOfTaste': 0.0,
          'muscleAches': 0.0,
          'oxygen': 90.0,
          'pulse': 80.0,
          'rednessOfEyes': 0.0,
          'shortnessOfBreath': 0.0,
          'sneezing': 0.0,
          'soreThroat': 0.0,
          'stomachAche': 0.0,
          'temperature': 97.0,
          'vomiting': 0.0,
          'skinRash': 0
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      await getSymptoms();
    } catch (err) {
      throw err;
    }
  }

  Future getSymptoms() async {
    try {
      final db = await symptomsdatabase();
      final List<Map<String, dynamic>> profile = await db.query('symptoms');
      final List<Symptoms> tempSymptoms = [];
      profile.forEach(
        (e) {
          tempSymptoms.add(
            Symptoms(
                patientId: e['patientId'],
                cough: e['cough'],
                diarrhea: e['diarrhea'],
                fatique: e['fatique'],
                fever: e['fever'],
                headache: e['headache'],
                lossOfSmell: e['lossOfSmell'],
                lossOfTaste: e['lossOfTaste'],
                muscleAches: e['muscleAches'],
                oxygen: e['oxygen'],
                pulse: e['pulse'],
                rednessOfEyes: e['rednessOfEyes'],
                shortnessOfBreath: e['shortnessOfBreath'],
                sneezing: e['sneezing'],
                soreThroat: e['soreThroat'],
                stomachAche: e['stomachAche'],
                temperature: e['temperature'],
                vomiting: e['vomiting'],
                skinRash: e['skinRash'] == 1),
          );
        },
      );
      _symptoms = tempSymptoms;
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future updateSymptom(Symptoms symptom) async {
    try {
      final db = await symptomsdatabase();
      db.insert(
        'symptoms',
        {
          'patientId': symptom.patientId,
          'cough': symptom.cough,
          'diarrhea': symptom.diarrhea,
          'fatique': symptom.fatique,
          'fever': symptom.fever,
          'headache': symptom.headache,
          'lossOfSmell': symptom.lossOfSmell,
          'lossOfTaste': symptom.lossOfTaste,
          'muscleAches': symptom.muscleAches,
          'oxygen': symptom.oxygen,
          'pulse': symptom.pulse,
          'rednessOfEyes': symptom.rednessOfEyes,
          'shortnessOfBreath': symptom.shortnessOfBreath,
          'sneezing': symptom.sneezing,
          'soreThroat': symptom.soreThroat,
          'stomachAche': symptom.stomachAche,
          'temperature': symptom.temperature,
          'vomiting': symptom.vomiting,
          'skinRash': symptom.skinRash ? 1 : 0,
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      await getSymptoms();
    } catch (err) {
      throw err;
    }
  }

  Future setZero(String id) async {
    try {
      final db = await symptomsdatabase();
      await db.update('symptoms', {
        'oxygen': 0.0,
        'pulse': 0.0,
        'temperature': 0.0,
      });
      await getSymptoms();
    } catch (err) {
      throw err;
    }
  }

  Symptoms latestSymtoms(String id) {
    int i = _symptoms.indexWhere((element) => element.patientId == id);
    if (i != -1) {
      return _symptoms[i];
    }
    return null;
  }
}
