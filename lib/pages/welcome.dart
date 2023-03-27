import 'package:flutter/material.dart';
import 'package:flutter_todo_app/pages/login.dart';
import 'package:flutter_todo_app/components/header.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const AuthHeader(),
            const SizedBox(height: 30),
            Image.asset(
              "assets/welcome.png",
              height: 250,
            ),
            const SizedBox(
              height: 60,
            ),
            Text(
              "Reminders Made Simple",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 26,
                    fontFamily: GoogleFonts.notoSans().fontFamily,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 300,
              child: Text(
                "Organize all your To-do’s in lists and projects. Color tag them to set priorities and categories.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(child: Container()),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: Text("Get Started",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
