import 'package:flutter/material.dart';
import 'package:kay_khau_frontend/controller/AddFood.dart';
import 'package:kay_khau_frontend/controller/LoginCon.dart';
import 'package:kay_khau_frontend/controller/SignUpCon.dart';
import 'package:kay_khau_frontend/controller/getFood.dart';
import 'package:provider/provider.dart';
import 'view/AuthScreen.dart';

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
          return AddFood();
        }),
        ChangeNotifierProvider(create: (context) {
          return GetFood();
        }),
        ChangeNotifierProvider(create: (context) {
          return LoginCon();
        }),
        ChangeNotifierProvider(create: (context) {
          return SignUpCon();
        }),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: AuthScreen(),
        ),
      ),
    );
  }
}
