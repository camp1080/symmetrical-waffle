import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project2/movie_night_api.dart';
import 'package:project2/screens/movie_screen.dart';

class InputCodeScreen extends StatefulWidget {
  final String? deviceId;
  const InputCodeScreen({super.key, this.deviceId});

  @override
  State<InputCodeScreen> createState() => _InputCodeScreenState();
}

class _InputCodeScreenState extends State<InputCodeScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter the Code")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                style: const TextStyle(fontSize: 40),
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: "Enter the code",
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final enteredCode = _codeController.text;
                  if (enteredCode.isNotEmpty && enteredCode.length == 4) {
                    try {
                      final apiService = ApiService();
                      final sessionData = await apiService.joinSession(
                        widget.deviceId!,
                        enteredCode,
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
                        const SnackBar(
                          content: Text('Error!This code does not match. :('),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid 4-digit code."),
                      ),
                    );
                  }
                },
                child: const Text("Begin"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
