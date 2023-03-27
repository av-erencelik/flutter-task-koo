import 'package:flutter/material.dart';
import 'package:flutter_todo_app/components/header.dart';
import 'package:form_validator/form_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Validators {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(children: [
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    validator: emailValidator,
                    hint: "Email",
                    icon: Icons.email,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    validator: passwordValidator,
                    isPassword: true,
                    hint: "Password",
                    icon: Icons.lock,
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
                        onTap: () {},
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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Processing Data")));
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
  });
  final String? Function(String?) validator;
  final bool isPassword;
  final String hint;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        return validator(value);
      },
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
}
