import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/food.dart';

class AddFood extends ChangeNotifier {
  bool success = false;
  String message = "";

  // Function to add the food preferences list
  Future<void> addPreferenceList(String userId, Set<Food> selectedBreakfast,
      Set<Food> selectedLunch, Set<Food> selectedDinner) async {
    message = "";
    success = false;
    notifyListeners();

    final requestData = {
      'userId': userId,
      'breakfast': selectedBreakfast.map((food) => food.id).toList(),
      'lunch': selectedLunch.map((food) => food.id).toList(),
      'dinner': selectedDinner.map((food) => food.id).toList(),
    };

    final url = Uri.parse('http://localhost:3000/add-preference-list');

    try {
      // Send the POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Food preference list added successfully!');
        success = true;
        notifyListeners();
      } else {
        message = response.body;
        log('Failed to add food preference list. Status code: ${response.body}');
      }
    } catch (error) {
      // Handle any exceptions (network errors, etc.)
      log('Error occurred: $error');
    }
  }
}
