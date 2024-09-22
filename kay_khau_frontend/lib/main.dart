import 'package:flutter/material.dart';
import 'package:kay_khau_frontend/controller/getFood.dart';
import 'package:kay_khau_frontend/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return GetFood();
        }),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Login(),
        ),
      ),
    );
  }
}
