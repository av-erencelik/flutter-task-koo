import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseUrl = "https://pxppdldhgixwjyntwxsx.supabase.co";
const String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB4cHBkbGRoZ2l4d2p5bnR3eHN4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2Nzk5MTYyODksImV4cCI6MTk5NTQ5MjI4OX0.gUk6ADmU3KoXNFESrg4wz3II4lOLo4DWWoC-q9Joo5g";

class SupabaseManager {
  final client = SupabaseClient(supabaseUrl, token);

  Future<void> signUpUser(context, {String? email, String? password, String? username}) async {
    try {
      await client.auth.signUp(email: email, password: password!, data: {
        "username": username,
      });
      Navigator.pushReplacementNamed(context, "/home");
    } on AuthException catch (e) {
      if (e.message.contains("User already registered")) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Email already exists",
          textAlign: TextAlign.center,
        )));
      } else if (e.message.contains("duplicate")) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Username already exists",
          textAlign: TextAlign.center,
        )));
      }
    }
  }

  Future<void> signInUser(context, {String? email, String? password}) async {
    try {
      await client.auth.signInWithPassword(email: email, password: password!);
      Navigator.pushReplacementNamed(context, "/home");
    } on AuthException catch (e) {
      if (e.message.contains("Invalid login credentials")) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Invalid login credentials",
          textAlign: TextAlign.center,
        )));
      } else if (e.message.contains("duplicate")) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Username already exists",
          textAlign: TextAlign.center,
        )));
      }
    }
  }

  Future<void> signOutUser(context) async {
    await client.auth.signOut();
    Navigator.pushReplacementNamed(context, "/login");
  }

  getCurrentUser() {
    return client.auth.currentUser;
  }
}
