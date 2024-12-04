import 'package:flutter/material.dart';
import 'package:project2/movie_night_api.dart';
import 'package:project2/screens/movie_screen.dart';

class GenerateCodeScreen extends StatelessWidget {
  final String? deviceId;
  const GenerateCodeScreen({super.key, this.deviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Code")),
      body: FutureBuilder<Map<String, String>>(
        future: ApiService().startSession(deviceId!),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          // Success state
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final generatedCode = data['code'];

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Generated Code:',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        generatedCode ?? 'No code',
                        style: const TextStyle(fontSize: 40),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final apiService = ApiService();
                        final sessionData = await apiService.joinSession(
                          deviceId!,
                          generatedCode!, // Use the extracted code
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieScreen(
                              sessionId: sessionData['session_id']!,
                            ),
                          ),
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text("Begin"),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text("Something went wrong."));
        },
      ),
    );
  }
}
