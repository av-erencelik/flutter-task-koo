import 'package:flutter/material.dart';
import 'package:flutter_todo_app/components/header.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/pages/register.dart';
import 'package:form_validator/form_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Validators {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String password = "";
  String email = "";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const AuthHeader(),
              const SizedBox(height: 50),
              formHeader(context),
              Form(
                key: _formKey,
                child: Column(children: [
                  const SizedBox(
                    height: 30,
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
                    icon: Icons.lock,
                    savedValue: passChange,
                  ),
                  forgotPassword(context),
                  loginButton(context, _formKey),
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
                        "Or Login With",
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
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                            ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()));
                        },
                        child: Text("Sign Up",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 13,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                      )
                    ],
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container loginButton(BuildContext context, GlobalKey<FormState> _formKey) {
    return Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.only(top: 10, bottom: 40),
        child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Processing Data")));
                _formKey.currentState!.save();
                final AuthResponse res = await supabase.auth
                    .signInWithPassword(email: email, password: password);
                final Session? session = res.session;
                final User? user = res.user;
                print(user);
                print(session);
              }
            },
            child: Text("Login",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 17))));
  }

  Align forgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(vertical: 10)),
        child: Text(
          "Forgot Password?",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSecondary),
        ),
      ),
    );
  }

  Text formHeader(BuildContext context) {
    return Text(
      "Login to your account",
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSecondary),
    );
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.img,
  });
  final String img;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          fixedSize: const Size(60, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          )),
      onPressed: () {},
      child: Image.asset("assets/$img.png"),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.validator,
    this.isPassword = false,
    required this.hint,
    required this.icon,
    this.controller,
    this.savedValue,
  });
  final String? Function(String?) validator;
  final bool isPassword;
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final void Function(String?)? savedValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        return validator(value);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      onSaved: savedValue,
      enableSuggestions: true,
      keyboardType:
          isPassword ? TextInputType.text : TextInputType.emailAddress,
      autocorrect: !isPassword,
      obscureText: isPassword,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.onSecondary),
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        filled: false,
        prefixIcon: Container(
          width: 50,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12))),
          child: Icon(icon),
        ),
      ),
    );
  }
}

class Validators {
  final emailValidator = ValidationBuilder().email().maxLength(50).build();
  final passwordValidator =
      ValidationBuilder().minLength(6).maxLength(50).build();
  final usernameValidator =
      ValidationBuilder().minLength(3).maxLength(20).build();
}
