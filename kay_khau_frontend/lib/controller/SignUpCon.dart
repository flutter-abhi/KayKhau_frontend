
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure storage
import 'package:http/http.dart' as http;
import '../models/user.dart'; // Assuming User model is in models/user.dart

class   SignUpCon extends ChangeNotifier {
  User? _signedUpUser; // Store the signed-up user
  bool isLoading = false; // Loading state
  String? errorMessage; // For storing error messages

  // Create an instance of Flutter Secure Storage
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Getter for signed-up user
  User? get signedUpUser => _signedUpUser;

  // Function to handle sign-up
  Future<void> signUpUser(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final url = Uri.parse('http://localhost:3000/signup'); // Your sign-up URL
    final requestBody = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Deserialize the user data from response
        _signedUpUser = User.fromJson(responseData['user']);

        // Store user data securely in Flutter Secure Storage
        await _secureStorage.write(key: 'email', value: _signedUpUser!.email);
        await _secureStorage.write(
            key: 'password', value: _signedUpUser!.password); // Optionally store password

        isLoading = false;
        notifyListeners();
      } else {
        errorMessage = 'Sign-up failed. Please check your details.';
        isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      errorMessage = 'An error occurred: $error';
      isLoading = false;
      notifyListeners();
    }
  }

  // Function to log out the user
  Future<void> logout() async {
    _signedUpUser = null;

    // Clear secure storage data
    await _secureStorage.deleteAll();

    notifyListeners();
  }
}
