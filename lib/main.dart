import 'package:flutter/material.dart';
import 'package:flutter_todo_app/pages/home.dart';
import 'package:flutter_todo_app/pages/login.dart';
import 'package:flutter_todo_app/pages/register.dart';
import 'package:flutter_todo_app/pages/welcome.dart';
import 'package:flutter_todo_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

bool? isFirstTime;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Supabase.initialize(
    url: 'https://pxppdldhgixwjyntwxsx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB4cHBkbGRoZ2l4d2p5bnR3eHN4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2Nzk5MTYyODksImV4cCI6MTk5NTQ5MjI4OX0.gUk6ADmU3KoXNFESrg4wz3II4lOLo4DWWoC-q9Joo5g',
  );

  isFirstTime = prefs.getBool('isFirstTime');
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        "/login": (_) => const LoginPage(),
        "/home": (_) => const Home(),
        "/register": (_) => const RegisterPage(),
        "/welcome": (_) => const WelcomePage(),
      },
      theme: AppTheme().theme,
      home: isFirstTime != null
          ? supabase.auth.currentUser != null
              ? const Home()
              : const LoginPage()
          : const WelcomePage(),
    );
  }
}
