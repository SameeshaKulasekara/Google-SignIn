import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_signin/constants/routes.dart';
import 'package:google_signin/firebase_options.dart';
import 'package:google_signin/pages/register.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
 );
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 @override
 Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gmail Login App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const LoginForm(), 
      routes: {
        homeRoute: (context) => const HomePage(),
        registerRoute:(context) => const RegisterForm(),
      },
    );
 }
}
