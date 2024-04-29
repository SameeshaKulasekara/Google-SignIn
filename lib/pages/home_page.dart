import 'package:flutter/material.dart';
import 'package:google_signin/constants/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
            .pushNamedAndRemoveUntil(registerRoute, (route) => false);
          },
        ),
      ),
      body: const Center(
        child: Text('Welcome to the Home Page :)'),
      ),
    );
 }
}
