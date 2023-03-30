import 'package:flutter/material.dart';
import 'package:flutter_todo_app/pages/home.dart';
import 'package:flutter_todo_app/pages/login.dart';
import 'package:flutter_todo_app/pages/register.dart';
import 'package:flutter_todo_app/pages/welcome.dart';
import 'package:flutter_todo_app/services/supabase.dart';
import 'package:flutter_todo_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

bool? isFirstTime;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['ANON_KEY']!, // You can find this in your Supabase dashboard
  );

  isFirstTime = prefs.getBool('isFirstTime');
  runApp(const MyApp());
}

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
          ? SupabaseManager().getCurrentUser() != null
              ? const Home()
              : const LoginPage()
          : const WelcomePage(),
    );
  }
}
