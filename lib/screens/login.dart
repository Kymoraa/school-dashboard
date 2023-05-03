import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:school_dashboard/themes/text_theme.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _firebaseAuth = FirebaseAuth.instance;
  late String email; // admin@mysticrose.com
  late String password;
  bool showSpinner = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when the user taps outside the TextField
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            children: [
              showSpinner
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SpinKitChasingDots(
                          color: Colors.pinkAccent,
                          size: 50.0,
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Image.asset('assets/logos/image-1.png'),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 70),
                          child: Text(
                            'MYSTIC ROSE SCHOOL',
                            style: context.bodyText1.copyWith(color: Colors.grey[600]),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14.0,
                            ),
                            cursorColor: Colors.pinkAccent[100],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90.0),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90.0),
                                borderSide: const BorderSide(
                                  color: Colors.pinkAccent,
                                ),
                              ),
                              labelText: 'Email',
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14.0,
                              ),
                            ),
                            onChanged: (value) {
                              email = value;
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: TextField(
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14.0,
                            ),
                            cursorColor: Colors.pinkAccent[100],
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  hidePassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                                  size: 18,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90.0),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90.0),
                                borderSide: const BorderSide(
                                  color: Colors.pinkAccent,
                                ),
                              ),
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14.0,
                              ),
                            ),
                            onChanged: (value) {
                              password = value;
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              final user = await _firebaseAuth.signInWithEmailAndPassword(
                                email: email.trim(),
                                password: password.trim(),
                              );
                              if (user != null) {
                                Future.delayed(const Duration(seconds: 3), () {
                                  Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                      builder: (_) => const HomeScreen(),
                                    ),
                                  );
                                });
                              }
                            } catch (e) {
                              setState(() {
                                showSpinner = false;
                              });
                              var snackBar = SnackBar(
                                content: Text(
                                  e.toString(),
                                ),
                                behavior: SnackBarBehavior.floating,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent[200],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  "Log In",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                          child: TextButton(
                            onPressed: () {
                              // implement forgot password functionality
                            },
                            child: Text(
                              'Forgot Password?',
                              style: context.bodyText1.copyWith(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
