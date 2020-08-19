import 'package:flutter/material.dart';

import '../providers/exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Authenticate {
  Future postPhoneNo(String phoneNumber) async {
    try {
      final url =
          'https://caretrackpd.kauveryhospital.com/caretrackpreg/api/Values/Covid19AppHMS_Pat_Reg';
      final map = {'mobileNO': phoneNumber};
      final response = await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: json.encode(map),
      );
      if (response.reasonPhrase == 'Mobile Number not registered, kindly register !!!') {
        throw MyException('error');
      }

      if(response.reasonPhrase == 'OTP Verified') {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      if (err.toString() == 'error') {
        throw MyException(
            'Try with your registered mobile number in the hospital');
      }
      throw MyException(
          'Something went wrong. Check your internet. Keep calm and try again.');
    }
  }

  Future checkOTP(String phoneNumber, String otp, BuildContext context) async {
    try {
      final url =
          'https://caretrackpd.kauveryhospital.com/caretrackpd/api/Values/Covid19AppHMS_Pat_Details';
      Map<String, String> map = {
        'mobileNo': phoneNumber,
        'otp': otp,
        'Flag': 'otp',
      };
      final response = await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: jsonEncode(map),
      );

      if (response.reasonPhrase == 'Invalid OTP') {
        throw MyException('Invalid OTP. Keep calm and try again.');
      }

    } catch (err) {
      if (err.toString() == 'Invalid OTP. Keep calm and try again.') {
        throw (err);
      }
      throw MyException(
          'Something went wrong. Check your internet. Keep calm and try again.');
    }
  }

    Future savePassword(String phoneNumber, String password) async {
    try {
      final url =
          'https://caretrackpd.kauveryhospital.com/caretrackpd/api/Values/Covid19AppHMS_Pat_Details';
      Map<String, String> map = {
        'mobileNo': phoneNumber,
        'pwsword': password,
        'Flag': 'PwdSave',
      };
      await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: jsonEncode(map),
      );
    } catch (err) {
      throw "'Something went wrong. Check your internet. Keep calm and try again.";
    }
  }

  Future resendOTP(String phoneNumber, BuildContext context) async {
    try {
      final url =
          'https://caretrackpd.kauveryhospital.com/caretrackpd/api/Values/Covid19AppHMS_Pat_Details';
      Map<String, String> map = {
        'mobileNo': phoneNumber,
        'Flag': 'ResetPwd',
      };
      final response = await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: jsonEncode(map),
      );

      if (response.reasonPhrase != 'OTP Generated Successfully Please Check it!') {
        throw MyException('Something went wrong. Check your internet. Keep calm and try again.');
      }

    } catch (err) {
      throw err;
    }
  }

  
}
