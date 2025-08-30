import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:voting_client/models/Level.dart';
import 'package:voting_client/models/User.dart';
import 'package:voting_client/models/Vote.dart';
import 'package:voting_client/utils/Consts.dart';
import 'package:voting_client/utils/Vary.dart';

class Apiprovider extends ChangeNotifier {
  String _email = "";
  String _code = "";
  int _selectedIndex = 0;
  bool _isLoading = false;
  bool _isLoginEnable = false;
  bool _isSubmitted = false;
  String _error = "";
  String _msg = "";
  String _codeErr = "";
  int _countdown = 0; // countdown timer value
  Timer? _timer;
  late User _user = User.empty();
  List<Level> _levels = [];
  List<dynamic> _votedLvl = [];
  List<dynamic> _votedCont = [];
  List<dynamic> get votedLvl => _votedLvl;
  List<dynamic> get votedCont => _votedCont;
  List<Vote> _votes = [];
  List<Vote> get votes => _votes;
  int get selectedIndex => _selectedIndex;
  List<Level> get levels => _levels;
  User get user => _user;
  String get error => _error;
  String get email => _email;
  String get code => _code;
  String get codeErr => _codeErr;
  bool get isLoading => _isLoading;
  bool get isLoginEnable => _isLoginEnable;
  bool get isSubmitted => _isSubmitted;
  String get msg => _msg;
  int get countdown => _countdown;
  bool _connErr = false;
  bool get connErr => _connErr;
  final vary = new Vary();
  bool _voteLoading = false;
  bool get voteLoading => _voteLoading;

  void startCountdown(int seconds) {
    _countdown = seconds;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        _countdown--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<bool> checkToken() async {
    bool isSuccess = false;
    final uri = Uri.parse("$API_URL/user/checkToken");
    final headers = await vary.getHeaders();
    try {
      final response = await http.post(uri, headers: headers);
      final data = jsonDecode(response.body);
      if (data["con"]) {
        isSuccess = true;
      }
    } catch (e) {
      _error = e.toString();
    }
    return isSuccess;
  }

  Future<bool> getOtp() async {
    notifyListeners();
    bool isSuccess = false;
    final userData = jsonEncode({"email": email});
    final uri = Uri.parse("$API_URL/user/getotp");
    final headers = await vary.getHeaders();
    try {
      final response = await http.post(uri, body: userData, headers: headers);
      final data = jsonDecode(response.body);
      if (data["con"]) {
        _msg = data["msg"];
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

  Future<bool> getVotedLvl() async {
    notifyListeners();
    bool isSuccess = false;
    final uri = Uri.parse("$API_URL/votedLvl");
    final headers = await vary.getHeaders();
    try {
      final response = await http.get(uri, headers: headers);
      final data = jsonDecode(response.body);
      if (data["con"]) {
        _votedLvl = data["result"];
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

  Future<bool> showVotedHistory(id) async {
    _isLoading = true;
    notifyListeners();
    bool isSuccess = false;
    final uri = Uri.parse("$API_URL/voted/$id");
    final headers = await vary.getHeaders();
    try {
      final response = await http.get(uri, headers: headers);
      final data = jsonDecode(response.body);
      if (data["con"]) {
        var lisy = List.from(data["result"]);
        _votes = lisy
            .map<Vote>((e) => Vote.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        isSuccess = true;
      } else {
        _error = data["msg"];
      }
    } catch (e) {
      _connErr = true;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }

  Future<bool> getVotedCont() async {
    notifyListeners();
    bool isSuccess = false;
    final uri = Uri.parse("$API_URL/votedCont");
    final headers = await vary.getHeaders();
    try {
      final response = await http.get(uri, headers: headers);
      final data = jsonDecode(response.body);
      if (data["con"]) {
        _votedCont = data["result"];
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

  Future<bool> login() async {
    _isLoading = true;
    notifyListeners();
    bool isSuccess = false;
    final userData = jsonEncode({"email": email, "code": code});
    final uri = Uri.parse("$API_URL/user/login");
    final headers = await vary.getHeaders();
    try {
      final response = await http.post(uri, body: userData, headers: headers);
      final data = jsonDecode(response.body);
      if (data["con"]) {
        _msg = data["msg"];
        await vary.saveToken(data["result"]);
        isSuccess = true;
      } else {
        _error = data["msg"];
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }

  Future<bool> vote(json) async {
    _voteLoading = true;
    notifyListeners();
    bool isSuccess = false;
    final uri = Uri.parse("$API_URL/vote");
    final headers = await vary.getHeaders();
    try {
      final response = await http.post(uri, body: json, headers: headers);
      final data = jsonDecode(response.body);
      if (data["con"]) {
        _msg = data["msg"];
        isSuccess = true;
      } else {
        _error = data["msg"];
      }
    } catch (e) {
      _connErr = true;
      notifyListeners();
    } finally {
      _voteLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }

  Future<bool> specialVote(json) async {
    _voteLoading = true;
    notifyListeners();
    bool isSuccess = false;
    final uri = Uri.parse("$API_URL/voteios");
    final headers = await vary.getHeaders();
    try {
      final response = await http.post(uri, body: json, headers: headers);
      final data = jsonDecode(response.body);
      if (data["con"]) {
        _msg = data["msg"];
        isSuccess = true;
      } else {
        _error = data["msg"];
      }
    } catch (e) {
      _connErr = true;
      notifyListeners();
    } finally {
      _voteLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }

  Future<bool> editVote(json) async {
    _voteLoading = true;
    notifyListeners();
    bool isSuccess = false;
    final uri = Uri.parse("$API_URL/vote");
    final headers = await vary.getHeaders();
    try {
      final response = await http.patch(uri, body: json, headers: headers);
      final data = jsonDecode(response.body);
      if (data["con"]) {
        _msg = data["msg"];
        isSuccess = true;
      } else {
        _error = data["msg"];
      }
    } catch (e) {
      _connErr = true;
      notifyListeners();
    } finally {
      _voteLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }

  Future<bool> getMe() async {
    _isLoading = true;
    notifyListeners();
    bool isSuccess = false;
    final uri = Uri.parse("$API_URL/me");
    final headers = await vary.getHeaders();
    try {
      final response = await http.get(uri, headers: headers);
      final data = jsonDecode(response.body);
      if (data["con"]) {
        _user = User.fromJson(data["result"]);

        await getVotedCont();
        if (user.role == "NORMAL") {
          await getVotedLvl();
        }
        isSuccess = true;
      } else {
        _error = data["msg"];
      }
    } catch (e) {
      _connErr = true;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }

  Future<bool> getAllLevel() async {
    _isLoading = true;
    notifyListeners();
    bool isSuccess = false;
    final uri = Uri.parse("$API_URL/level");
    final headers = await vary.getHeaders();
    try {
      final response = await http.get(uri, headers: headers);
      final data = jsonDecode(response.body);
      if (data["con"]) {
        _msg = data["msg"];
        var lisy = data["result"] as List;
        _levels = lisy.map((e) => Level.fromJson(e)).toList();
        isSuccess = true;
      } else {
        _error = data["msg"];
      }
    } catch (e) {
      _connErr = true;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }

  Future<void> retryAll() async {
    _connErr = false;
    _isLoading = true;
    notifyListeners();
    try {
      await getAllLevel();
      await getMe();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  setSelectedIndex(index) {
    _selectedIndex = index;
    notifyListeners();
  }

  setCodeErr(String err) {
    _codeErr = err;
    ;
    notifyListeners();
  }

  changeEmail(email) {
    _email = email;
    notifyListeners();
  }

  changeSubmitted(value) {
    _isSubmitted = value;
  }

  changeCode(code) {
    _code = code;
    if (_code.length == 6) {
      _isLoginEnable = true;
    } else {
      _isLoginEnable = false;
    }
    notifyListeners();
  }
}
