import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import 'exception.dart';
import 'latestSymptoms.dart';

class Profile {
  String name;
  String patientID;
  DateTime dob;
  String phoneNumber;
  String sex;
  int age;

  bool diabetes;
  bool bloodPressure;
  bool asthma;
  bool heartDisease;
  bool dialysis;
  bool arthritis;
  bool chemotheraphy;
  bool smoker;
  bool cortisone;
  bool antiInflam;

  String language;

  Profile(
      {this.name,
      this.patientID,
      this.dob,
      this.phoneNumber,
      this.diabetes,
      this.bloodPressure,
      this.asthma,
      this.heartDisease,
      this.dialysis,
      this.arthritis,
      this.antiInflam,
      this.chemotheraphy,
      this.smoker,
      this.cortisone,
      this.language,
      this.sex,
      this.age});
}

class ProfileProvider with ChangeNotifier {
  List<Profile> _profiles = [];

  Future<sql.Database> profilesdatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbPath, 'profilesDB.db'),
      version: 1,
      onCreate: (sql.Database db, version) async {
        await db.execute(
            'CREATE TABLE profile(name TEXT, patientID TEXT, dob TEXT, phoneNumber TEXT, sex TEXT, age INTEGER, diabetes INTEGER, bloodPressure INTEGER, asthma INTEGER, heartDisease INTEGER, dialysis INTEGER,arthritis INTEGER,chemotheraphy INTEGER, smoker INTEGER,cortisone INTEGER,antiInflam INTEGER,language TEXT)');
      },
    );
  }

  Future addProfile(Profile p) async {
    try {
      final sql.Database db = await profilesdatabase();
      final url =
          'https://caretrackpd.kauveryhospital.com/caretrackphr/api/Values/Covid19AppHMS_PatientHealthRecord';
      Map<String, List<Map<String, dynamic>>> map = {
        "results": [
          {
            "UHID": p.patientID,
            "Diabetes": p.diabetes ? 'T' : 'F',
            "Pressure": p.bloodPressure ? 'T' : 'F',
            "Asthma": p.asthma ? 'T' : 'F',
            "Heart_Disease": p.heartDisease ? 'T' : 'F',
            "Blood_pressure": p.bloodPressure ? 'T' : 'F',
            "Dialysis": p.dialysis ? 'T' : 'F',
            "Kidney_Disease": p.diabetes ? 'T' : 'F',
            "Arthritis": p.arthritis ? 'T' : 'F',
            "Chemotherapy": p.chemotheraphy ? 'T' : 'F',
            "Smoker": p.smoker ? 'T' : 'F',
            "Cortisone_Med": p.cortisone ? 'T' : 'F'
          }
        ]
      };
      final response = await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: jsonEncode(map),
      );
      if (response.statusCode != 200) {
        throw MyException('Something went wrong. Keep calm and try again.');
      }

      await db.insert(
        'profile',
        {
          'name': p.name,
          'patientID': p.patientID,
          'dob': p.dob.toString(),
          'age': p.age,
          'phoneNumber': p.phoneNumber,
          'sex': p.sex,
          'diabetes': p.diabetes ? 1 : 0,
          'bloodPressure': p.bloodPressure ? 1 : 0,
          'asthma': p.asthma ? 1 : 0,
          'heartDisease': p.heartDisease ? 1 : 0,
          'dialysis': p.dialysis ? 1 : 0,
          'arthritis': p.arthritis ? 1 : 0,
          'chemotheraphy': p.chemotheraphy ? 1 : 0,
          'smoker': p.smoker ? 1 : 0,
          'cortisone': p.cortisone ? 1 : 0,
          'antiInflam': p.antiInflam ? 1 : 0,
          'language': p.language
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
        nullColumnHack: "null",
      );
      await LatestSymtoms().addNewSymtomProfile(p.patientID);
      await getProfiles();
    } catch (err) {
      throw MyException('Something went wrong. Keep calm and try again.');
    }
  }

  Future getProfiles() async {
    try {
      final db = await profilesdatabase();
      final List<Map<String, dynamic>> dbData = await db.query("profile");
      List<Profile> tempProfileList = [];
      dbData.forEach(
        (p) {
          tempProfileList.add(
            Profile(
              name: p['name'],
              patientID: p['patientID'],
              phoneNumber: p['phoneNumber'],
              dob: p['dob'] == null
                  ? DateTime(DateTime.now().year - p['age'])
                  : DateTime.parse(p['dob']),
              sex: p['sex'],
              age: p['age'],
              language: p['language'],
              diabetes: p['diabetes'] == 1,
              bloodPressure: p['bloodPressure'] == 1,
              asthma: p['asthma'] == 1,
              heartDisease: p['heartDisease'] == 1,
              dialysis: p['dialysis'] == 1,
              arthritis: p['arthritis'] == 1,
              smoker: p['smoker'] == 1,
              cortisone: p['cortisone'] == 1,
              antiInflam: p['antiInflam'] == 1,
              chemotheraphy: p['chemotheraphy'] == 1,
            ),
          );
        },
      );
      _profiles = tempProfileList;
    } catch (err) {
      throw (err);
    }
  }

  List<Profile> get profile {
    return _profiles;
  }

  Future deleteProfiles() async {
    final db = await profilesdatabase();
    db.rawQuery(
      'Delete from profile',
    );
  }
}
