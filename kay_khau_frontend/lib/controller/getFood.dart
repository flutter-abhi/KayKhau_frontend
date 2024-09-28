import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kay_khau_frontend/Models/food.dart';
import "package:http/http.dart" as http;

class GetFood extends ChangeNotifier {
  bool isloading = false;
  List<Food> foodList = []; // General list for all food types
  List<Food> foodListBreakFast = []; // List specifically for breakfast items

  void getFood() async {
    try {
      isloading = true;
      notifyListeners(); // Notify UI that loading has started

      Uri url = Uri.parse("http://localhost:3000/get-food-list");
      var resString = await http.get(url);
      log("${resString.statusCode}");

      if (resString.statusCode == 200 || resString.statusCode == 201) {
        dynamic resBody = jsonDecode(resString.body);

        // Clear the lists before populating them
        foodList.clear();
        foodListBreakFast.clear();

        // Parse and filter the food items
        foodList = (resBody as List)
            .map((data) {
              Food food = Food.fromJson(data);

              // Check if the food type is 'breakfast'
              if (food.type == "breakfast") {
                foodListBreakFast.add(food); // Add to breakfast list
              } else {
                return food; // Add non-breakfast foods to general food list
              }
            })
            .whereType<Food>()
            .toList(); // Ensure we filter out null values

        log("All food items: ${foodList.toString()}");
        log("Breakfast items: ${foodListBreakFast.toString()}");
      }
    } catch (e) {
      log("Error: $e");
    } finally {
      isloading = false;
      notifyListeners(); // Notify UI that data fetching is done
    }
  }
}
