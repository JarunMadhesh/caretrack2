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

  DBProfile(
      this.name, this.phoneNumber, this.uhid, this.gender, this.dob, this.age);
}

class DBProfileProvider with ChangeNotifier {
  List<DBProfile> _profiles = [
    DBProfile("Ram", "7708998036", "uhid1", "Male", DateTime.now(), 10),
    DBProfile("Meghna", "ph no", "uhid1", "Female", DateTime.now(), 20),
    DBProfile("Kiran", "ph no", "uhid1", "Male", DateTime.now(), 30),
    DBProfile("Raj", "ph no", "uhid1", "Female", DateTime.now(), 40),
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

  Future fetchprofiles(
      String phoneNumber, String otp, BuildContext context) async {
    try {
      final url =
          'https://caretrackpd.kauveryhospital.com/caretrackpd/api/Values/Covid19AppHMS_Pat_Details';
      Map<String, String> map = {
        'mobileNo': phoneNumber,
        'otp': otp,
      };
      final response = await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: jsonEncode(map),
      );

      if (response.statusCode == 404) {
        throw MyException('Invalid OTP. Keep calm and try again.');
      }

      List<dynamic> profiles = json.decode(response.body)['results'];

      List<DBProfile> _tempList = [];
      profiles.forEach((element) {
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
              element['dob'].toString().length == 0
                  ? int.parse(element['age'])
                  : calculateAge(
                      DateTime(year, month, day),
                    ),
            ),
          );
        }
      });
      _profiles = _tempList;
      notifyListeners();
    } catch (err) {
      if (err.toString() == 'Invalid OTP. Keep calm and try again.') {
        throw (err);
      }
      throw MyException(
          'Something went wrong. Check your internet. Keep calm and try again.');
    }
  }

  List<DBProfile> get profiles {
    return _profiles;
  }
}
