import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:voting_client/utils/Consts.dart';
import 'package:voting_client/utils/Vary.dart';

class CountdownProvider extends ChangeNotifier {
  Duration offset = Duration.zero;
  Duration remaining = Duration.zero;
  Timer? _timer;
  String _error = "";
  String get error => _error;
  final vary = new Vary();
  bool _connErr = false;
  bool get connErr => _connErr;
  DateTime? startTime;
  DateTime? endTime;
  Future<bool> getCountDown() async {
    notifyListeners();
    bool isSuccess = false;
    final uri = Uri.parse("$API_URL/getTime");
    final headers = await vary.getHeaders();
    try {
      final response = await http.get(uri, headers: headers);
      final data = jsonDecode(response.body);
      if (data["con"]) {
        initCountdown(data["result"]);
        isSuccess = true;
      } else {
        _error = data["msg"];
      }
    } catch (e) {
      _connErr = true;
      notifyListeners();
    }
    return isSuccess;
  }

  Future<void> initCountdown(Map<String, dynamic> apiData) async {
    startTime = DateTime.parse(apiData['start_time']);
    endTime = DateTime.parse(apiData['end_time']);
    final serverNow = DateTime.parse(apiData['server_time']).toUtc();
    final localNow = DateTime.now().toUtc();

    offset = serverNow.difference(localNow);

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final nowWithOffset = DateTime.now().add(offset);

      if (startTime != null && endTime != null) {
        if (nowWithOffset.isBefore(startTime!) ||
            nowWithOffset.isAfter(endTime!)) {
          remaining = Duration.zero;
          _timer?.cancel();
        } else {
          remaining = endTime!.difference(nowWithOffset);
        }
        notifyListeners();
      }
    });
  }

  bool get isVisible => remaining.inSeconds > 0;

  String get formattedTime {
    if (remaining.inHours > 0) {
      return "${remaining.inHours.toString().padLeft(2, '0')}:"
          "${remaining.inMinutes.remainder(60).toString().padLeft(2, '0')}:"
          "${remaining.inSeconds.remainder(60).toString().padLeft(2, '0')}";
    } else {
      return "${remaining.inMinutes.toString().padLeft(2, '0')}:"
          "${remaining.inSeconds.remainder(60).toString().padLeft(2, '0')}";
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
