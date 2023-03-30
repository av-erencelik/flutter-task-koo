import 'package:flutter/material.dart';
import 'package:flutter_todo_app/services/todo.dart';
import 'package:intl/intl.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseUrl = "https://pxppdldhgixwjyntwxsx.supabase.co";
const String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB4cHBkbGRoZ2l4d2p5bnR3eHN4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2Nzk5MTYyODksImV4cCI6MTk5NTQ5MjI4OX0.gUk6ADmU3KoXNFESrg4wz3II4lOLo4DWWoC-q9Joo5g";

class SupabaseManager {
  late final client = Supabase.instance.client;

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

  User? getCurrentUser() {
    return client.auth.currentUser;
  }

  getTodos() {
    return client
        .from('todos')
        .stream(primaryKey: ['id'])
        .gte('day', DateTime.now().toIso8601String())
        .order("day", ascending: true);
  }

  updateFinishedStatus(id, finished) async {
    await client.from('todos').update({'finished': finished}).eq('id', id);
  }

  updateNotificationsStatus(id, notifications) async {
    await client.from('todos').update({'notifications': notifications}).eq('id', id);
  }

  deleteTodoById(id) async {
    await client.from('todos').delete().eq('id', id);
  }

  fetchTodaysLatestNotificationsTrueTodo() async {
    final res = await client
        .from('todos')
        .select()
        .eq('day', DateTime.now().toIso8601String())
        .eq('notifications', true)
        .order("time", ascending: true)
        .limit(1);
    return res.map((e) => Todo.fromJson(e)).toList();
  }

  fetchNumberOfTodaysTasks() async {
    final res = await client.from('todos').select().eq('day', DateTime.now().toIso8601String());
    return res.length;
  }

  insetNewTodo(Map todo) async {
    await client.from('todos').insert(todo);
  }
}
