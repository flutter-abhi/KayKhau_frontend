import 'package:flutter/material.dart';
import 'package:kay_khau_frontend/controller/LoginCon.dart';
import 'package:kay_khau_frontend/controller/SignUpCon.dart';
import 'package:kay_khau_frontend/view/HomeScreen.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:kay_khau_frontend/view/addprefrenceList.dart'; // Replace with your AddPrefredList page

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true; // Toggle between login and sign-up

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginCon>(context);
    final signUpProvider = Provider.of<SignUpCon>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10)),
          height: 400,
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: (isLogin
                        ? loginProvider.isLoading
                        : signUpProvider.isLoading)
                    ? null
                    : () async {
                        String email = _emailController.text;
                        String password = _passwordController.text;

                        if (isLogin) {
                          // Login action
                          await loginProvider.loginUser(email, password);
                          if (loginProvider.loggedInUser != null) {
                            if (loginProvider.loggedInUser!.preferredFoods
                                .breakfast.isNotEmpty) {
                              //home screen
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return const Homescreen();
                              }));
                            } else {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return const AddPrefredList();
                              }));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(loginProvider.errorMessage ??
                                    'Login failed'),
                              ),
                            );
                          }
                        } else {
                          // Sign-up action
                          await signUpProvider.signUpUser(email, password);
                          if (signUpProvider.signedUpUser != null) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const AddPrefredList();
                            }));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(signUpProvider.errorMessage ??
                                    'Sign-up failed'),
                              ),
                            );
                          }
                        }
                      },
                child: (isLogin
                        ? loginProvider.isLoading
                        : signUpProvider.isLoading)
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(isLogin ? 'Login' : 'Sign Up'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin; // Toggle between login and sign-up
                  });
                },
                child: Text(isLogin
                    ? 'Don\'t have an account? Sign Up'
                    : 'Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
