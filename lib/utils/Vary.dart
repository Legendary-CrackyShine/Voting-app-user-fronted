import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Vary {
  static String token = "";
  final storage = FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await storage.write(key: 'authToken', value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'authToken');
  }

  Future<void> delToken() async {
    return await storage.delete(key: 'authToken');
  }

  Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
