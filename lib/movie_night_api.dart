import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService {
  static const String _baseUrl = 'https://movie-night-api.onrender.com';

  // Common logic for sending GET requests
  Future<Map<String, dynamic>> _get(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception(
          'Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  // API Method: Start a Session
  Future<Map<String, String>> startSession(String deviceId) async {
    final data = await _get('/start-session?device_id=$deviceId');
    return {
      'message': data['message'],
      'session_id': data['session_id'],
      'code': data['code'],
    };
  }

  // API Method: Join a Session
  Future<Map<String, String>> joinSession(String deviceId, String code) async {
    final data = await _get('/join-session?device_id=$deviceId&code=$code');
    return {
      'message': data['message'],
      'session_id': data['session_id'],
    };
  }

  // API Method: Vote for a Movie
  Future<Map<String, dynamic>> voteMovie(
      String sessionId, int movieId, bool match) async {
    final data = await _get(
        '/vote-movie?session_id=$sessionId&movie_id=$movieId&vote=$match');
    return {
      'session_id': data['sessionId'],
      'movie_id': data['movieId'],
      'liked': data['match'],
    };
  }
}
