import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:team/login/initPage.dart';
import 'package:team/login/signInPage.dart';
import 'package:team/login/signUpPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          //login
          '/': (context) => const InitPage(),
          '/toSignInPage': (context) => const SignInPage(),
          '/toSignUpPage': (context) => const SignUpPage(),

          //chat
          //'/toChatloungPage': (context) => const ,
        });
  }
}
