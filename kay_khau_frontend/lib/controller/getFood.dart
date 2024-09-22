import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kay_khau_frontend/Models/food.dart';
import "package:http/http.dart" as http;

class GetFood extends ChangeNotifier {
  bool isloading = false;
  List<Food> foodList = [];

  void getFood() async {
    try {
      isloading = true;
      //notifyListeners();

      Uri url = Uri.parse("http://localhost:3000/get-food-list");
      var resString = await http.get(url);
      log("${resString.statusCode}");

      if (resString.statusCode == 200 || resString.statusCode == 201) {
        dynamic resBody = jsonDecode(resString.body);

        foodList =
            (resBody as List).map((data) => Food.fromJson(data)).toList();
        log(foodList.toString());
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isloading = false;
      notifyListeners();
    }
  }
}
