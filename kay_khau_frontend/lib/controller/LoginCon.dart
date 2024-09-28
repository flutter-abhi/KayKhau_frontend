import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure storage
import 'package:http/http.dart' as http;
import '../models/user.dart';

class LoginCon extends ChangeNotifier {
  User? _loggedInUser; // Store the logged-in user
  bool isLoading = false; // Loading state
  String? errorMessage; // For storing error messages

  // Create an instance of Flutter Secure Storage
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Getter for logged-in user
  User? get loggedInUser => _loggedInUser;

  // Function to handle login
  Future<void> loginUser(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final url = Uri.parse('http://localhost:3000/login'); // Your login URL
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
        _loggedInUser = User.fromJson(responseData['user']);

        // Store user data securely in Flutter Secure Storage
        await _secureStorage.write(key: 'email', value: _loggedInUser!.email);
        await _secureStorage.write(
            key: 'password',
            value: _loggedInUser!.password); // Optionally store password

        isLoading = false;
        notifyListeners();
      } else {
        errorMessage = 'Login failed. Please check your credentials.';
        isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      log("$error");
      errorMessage = 'An error occurred: $error';
      isLoading = false;
      notifyListeners();
    }
  }

  // Function to check if the user is already logged in
  // Future<void> checkLoginStatus() async {
  //   isLoading = true;
  //   notifyListeners();

  //   try {
  //     // Retrieve user data from secure storage
  //     String? email = await _secureStorage.read(key: 'email');
  //     String? password = await _secureStorage.read(key: 'password');

  //     if (email != null && password != null) {
  //       // Rebuild User object from secure storage data
  //       _loggedInUser = User(
  //         id: ,
  //         email: email,
  //         password: password,
  //         preferredFoods: PreferredFoods(breakfast: [], lunch: [], dinner: []),
  //         groups: [],
  //       );
  //     }
  //   } catch (error) {
  //     errorMessage = 'Error checking login status: $error';
  //   }

  //   isLoading = false;
  //   notifyListeners();
  // }

  // // Log out the user and clear secure storage
  Future<void> logout() async {
    _loggedInUser = null;

    // Clear secure storage data
    await _secureStorage.deleteAll();

    notifyListeners();
  }
}
