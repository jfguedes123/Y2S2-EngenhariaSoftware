import 'package:flutter/material.dart';

class HomePagePage extends StatelessWidget {
  const HomePagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/f1_logo.png',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome, F1 fans!',
                  style: TextStyle(
                    fontFamily: 'F1',
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
