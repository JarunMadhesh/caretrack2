import 'exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedbackProvider with ChangeNotifier {

  Future postFeedback(String id, String content) async {
    try {
      final url =
          'https://caretrackpd.kauveryhospital.com/caretrackpfb/api/Values/Covid19AppHMS_PatientFeedback';

      final map = {
        "results": [
          {"UHID": id, "Feedback": content}
        ]
      };
      final response = await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: json.encode(map),
      );

      if (response.statusCode != 200) {
        throw MyException(
            "Something went wrong. Check your internet. Keep calm and try again.");
      }
    } catch (err) {
      throw err;
    }
  }
}
