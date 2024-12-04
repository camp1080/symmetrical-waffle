import 'package:flutter/material.dart';
import 'package:project2/movie_night_api.dart';
import 'package:project2/movie_db_api.dart';
import 'package:project2/screens/home_screen.dart';

class MovieScreen extends StatefulWidget {
  final String sessionId;
  const MovieScreen({super.key, required this.sessionId});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final TMDBApiService _tmdbApi = TMDBApiService();
  final ApiService _movieNightApi = ApiService();
  final List<Map<String, dynamic>> _movies = [];
  int _currentIndex = 0;
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    if (_isLoading) return; // Prevent multiple calls simultaneously
    setState(() => _isLoading = true);

    try {
      final newMovies = await _tmdbApi.fetchMovies('upcoming', _currentPage);
      setState(() {
        _movies.addAll(newMovies);
        _currentPage++;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching movies: $error')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _voteMovie(int movieId, bool vote) async {
    try {
      final result =
          await _movieNightApi.voteMovie(widget.sessionId, movieId, vote);

      // Only show match dialog if there's a match
      if (result['match'] == true) {
        if (!mounted) return; // Check if widget is still mounted

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('It\'s a Match! 🎉'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Both of you liked:'),
                const SizedBox(height: 8),
                Text(
                  _movies[_currentIndex]['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error voting for movie: $error')),
      );
    }
  }

  void _handleDismiss(DismissDirection direction) async {
    final movie = _movies[_currentIndex];
    final vote = direction == DismissDirection.endToStart; // Right swipe = yes
    await _voteMovie(movie['id'], vote);

    if (mounted) {
      // Check if widget is still mounted
      setState(() {
        _currentIndex++;
        if (_currentIndex >= _movies.length - 1) {
          _fetchMovies();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_movies.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_movies.isEmpty) {
      return const Center(child: Text('No movies available.'));
    }

    final movie = _movies[_currentIndex];
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Selection')),
      body: Dismissible(
        key: ValueKey(movie['id']),
        direction: DismissDirection.horizontal,
        onDismissed: _handleDismiss,
        background: Container(
          color: Colors.green,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Icon(Icons.thumb_up, color: Colors.white, size: 40),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.thumb_down, color: Colors.white, size: 40),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 0), // Adds space to the top
            child: SizedBox(
              width: 350,
              height: 550,
              child: Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.grey[200], // Slightly light background color
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start, // Align to top
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center horizontally
                    children: [
                      Text(
                        movie['title'],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Release Date: ${movie['release_date'] ?? 'N/A'}', // Display release date
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Image.network(
                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                        height: 350, // Adjusted height for the poster image
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Rating: ${movie['vote_average'] ?? 'N/A'}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
