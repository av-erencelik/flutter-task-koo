import 'package:flutter/material.dart';
import 'package:flutter_todo_app/components/header.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/pages/login.dart';
import 'package:flutter_todo_app/services/supabase.dart';
import 'package:form_validator/form_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with Validators {
  final _supabaseController = SupabaseManager();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController pass = TextEditingController();
  String email = "";
  String username = "";
  String password = "";

  void emailChange(String? value) {
    setState(() {
      email = value ?? "";
    });
  }

  void passChange(String? value) {
    setState(() {
      password = value ?? "";
    });
  }

  void userChange(String? value) {
    setState(() {
      username = value ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    pass.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passwordCheck = ValidationBuilder().minLength(6).passwordCheck(pass.text).maxLength(50).build();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const AuthHeader(),
            const SizedBox(height: 30),
            formHeader(context),
            Form(
                key: _formKey,
                child: Column(children: [
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    validator: usernameValidator,
                    hint: "Username",
                    icon: Icons.person,
                    savedValue: userChange,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    validator: emailValidator,
                    hint: "Email",
                    icon: Icons.email,
                    savedValue: emailChange,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    validator: passwordValidator,
                    isPassword: true,
                    hint: "Password",
                    controller: pass,
                    icon: Icons.lock,
                    savedValue: passChange,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    validator: passwordCheck,
                    isPassword: true,
                    hint: "Confirm Password",
                    icon: Icons.lock,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  registerButton(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 3),
                        child: Icon(
                          Icons.horizontal_rule,
                          size: 15,
                        ),
                      ),
                      Text(
                        "Or Register With",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 3),
                        child: Icon(
                          Icons.horizontal_rule,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      SocialButton(img: "google"),
                      SocialButton(img: "facebook"),
                      SocialButton(img: "twitter")
                    ],
                  ),
                ])),
          ],
        ),
      )),
    );
  }

  Container registerButton(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.only(top: 10, bottom: 40),
        child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                try {
                  await _supabaseController.signUpUser(
                    context,
                    email: email,
                    password: password,
                    username: username,
                  );
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
            },
            child: Text("Register",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 17))));
  }

  Text formHeader(BuildContext context) {
    return Text(
      "Create your account",
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontSize: 15.5, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSecondary),
    );
  }
}

extension CustomValidationBuilder on ValidationBuilder {
  passwordCheck(password) => add((value) {
        if (value != password) {
          return 'Passwords do not match';
        }
        return null;
      });
}
