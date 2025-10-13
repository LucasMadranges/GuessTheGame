import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class RemoteApi {
  final http.Client _client;
  RemoteApi(this._client);

  Future<List<Map<String, dynamic>>> fetchRawGames() async {
    // Using jsonplaceholder photos as mock games
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/photos?_limit=30');
    final response = await _retry(() => _client.get(uri));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('HTTP ${response.statusCode}');
  }

  Future<http.Response> _retry(Future<http.Response> Function() action) async {
    int attempt = 0;
    Exception? lastError;
    while (attempt < 3) {
      try {
        final res = await action();
        if (res.statusCode >= 200 && res.statusCode < 500) {
          return res;
        }
        lastError = Exception('HTTP ${res.statusCode}');
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
      }
      attempt++;
      final backoff = pow(2, attempt) * 100; // ms
      await Future.delayed(Duration(milliseconds: backoff.toInt()));
    }
    throw lastError ?? Exception('Network error');
  }
}
