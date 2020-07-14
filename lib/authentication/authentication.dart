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
    } catch (err) {
      if (err.toString() == 'error') {
        throw MyException(
            'Try with your registered mobile number in the hospital');
      }
      throw MyException(
          'Something went wrong. Check your internet. Keep calm and try again.');
    }
  }
}
