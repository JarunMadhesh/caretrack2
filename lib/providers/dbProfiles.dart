import 'dart:convert';

import 'exception.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DBProfile {
  final String name;
  final String phoneNumber;
  final String uhid;
  final String gender;
  final DateTime dob;
  final int age;
  final bool isAlreadyPresent;

  DBProfile(this.name, this.phoneNumber, this.uhid, this.gender, this.dob,
      this.age, this.isAlreadyPresent);
}

class DBProfileProvider with ChangeNotifier {
  List<DBProfile> _profiles = [
    DBProfile("Ram", "7708998036", "uhid1", "Male", DateTime.now(), 10, false),
    DBProfile("Meghna", "ph no", "uhid1", "Female", DateTime.now(), 20, false),
    DBProfile("Kiran", "ph no", "uhid1", "Male", DateTime.now(), 30, true),
    DBProfile("Raj", "ph no", "uhid1", "Female", DateTime.now(), 40, false),
  ];

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Future<bool> checkAvailability(String uhid) async {
    try {
      final url =
          'https://caretrackpd.kauveryhospital.com/caretrackphr/api/Values/Covid19AppHMS_PatientHealthRecord';

      final _map = {
        "results": [
          {"UHID": uhid, "Flag": "Select"}
        ]
      };

      final _response = await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: json.encode(_map),
      );

      if (_response.body.length == 0) {
        return false;
      }

      if (_response.statusCode != 200) {
        throw MyException('Something went wrong. Keep calm and try again.');
      }

      return true;
    } catch (err) {
      throw MyException('Something went wrong. Keep calm and try again.');
    }
  }

  Future putProfile(
      List<dynamic> profiles, String phoneNumber, BuildContext context) async {
    try {
      List<DBProfile> _tempList = [];
      await Future.forEach(profiles, (element) async {
        bool flag = true;

        Provider.of<ProfileProvider>(context, listen: false)
            .profile
            .forEach((each) {
          if (each.patientID == element['uhid']) {
            flag = false;
          }
        });
        if (flag) {
          int year = 0, month = 0, day = 0;
          if (element['dob'].toString().length != 0) {
            year = int.parse(element['dob'].toString().substring(6, 10));
            month = int.parse(element['dob'].toString().substring(3, 5));
            day = int.parse(element['dob'].toString().substring(0, 2));
          }
          _tempList.add(
            DBProfile(
              element['patName'],
              phoneNumber,
              element['uhid'],
              element['gender'][0] +
                  element['gender'].toString().substring(1).toLowerCase(),
              element['dob'].toString().length == 0
                  ? DateTime(DateTime.now().year - int.parse(element['age']))
                  : DateTime(year, month, day),
              element['age'].toString().length != 0
                  ? int.parse(element['age'])
                  : -1,
              false,
            ),
          );
        }
      });
      _profiles = _tempList;
      notifyListeners();
    } catch (err) {
      print(err.toString());
      throw err;
    }
  }

  Future fetchprofiles(
      String phoneNumber, String password, BuildContext context) async {
    try {
      final url =
          'https://caretrackpd.kauveryhospital.com/caretrackpd/api/Values/Covid19AppHMS_Pat_Details';
      Map<String, String> map = {
        'mobileNo': phoneNumber,
        'pwsword': password,
        'Flag': 'PwdCheck',
      };

      final response = await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: jsonEncode(map),
      );

      if (response.reasonPhrase != "OK") {
        throw MyException("NOT OK");
      }

      List<dynamic> profiles = json.decode(response.body)['results'];

      // print(profiles);
      // print("\n\n");

      putProfile(profiles, phoneNumber, context);
    } catch (err) {
      if (err.toString() == "NOT OK") {
        throw MyException("Invalid Password");
      }
      throw "'Something went wrong. Check your internet. Keep calm and try again.";
    }
  }

  List<DBProfile> get profiles {
    return _profiles;
  }
}
