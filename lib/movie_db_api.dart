import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TMDBApiService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  final _apiKey = dotenv.env['API_KEY'];

  // Fetch movies from TMDB
  Future<List<Map<String, dynamic>>> fetchMovies(
      String category, int page) async {
    final url = Uri.parse(
        '$_baseUrl/movie/$category?api_key=$_apiKey&language=en-US&page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception(
          'Failed to fetch movies. Status code: ${response.statusCode}');
    }
  }
}
