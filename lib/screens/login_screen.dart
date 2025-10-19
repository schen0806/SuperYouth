import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:super_youth/providers/auth_provider.dart';

//import the StatelessWidget material version
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController(); //control how we submit the values in the form, how we validate the data
  //e.g. password rules, check if the email is valid
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    //try blocks are used to run codes that could cause an error
    //try blocks are always paired with the catch blocks(blocks that catch the errors in the try blocks)
    try {
      AuthenticationProvider authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.login(_emailController.text, _passwordController.text);
      //if login finishes without errors, go to the home screen

      //in async functions, make sure that the screen is working/in use properly
      //If screen in use, go to the home screen
      if (mounted) {
        context.go('/home');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == ("user-not-found")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user found for that email.")),
        );
      } else if (e.code == 'invalid-credential' && mounted) {
        //the ScaffoldMessenger is the class responsible for showing the SnackBar at
        //the bottom of the screen
        //ScaffoldMessenger.of(context) gets me the scaffold of the current context
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //param. always start lowercase
        title: Text("Super Youth"),
      ),
      //body holds the actual content
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                spacing: 10,
                //use the TextField class
                children: [
                  Image.asset("assets/SY_Logo.png", width: 100),
                  //organize array by having one item per line
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      label: Text("Username"),
                      prefixIcon: Icon(Icons.email),
                      hintText: "Enter username",
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Georgia",
                    ),
                    validator: (String? email) {
                      if (email == null ||
                          !RegExp(
                            r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$',
                          ).hasMatch(email)) {
                        return 'Invalid email entered.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Georgia",
                    ),
                    validator: (String? password) {
                      if (password == null ||
                          !RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$',
                          ).hasMatch(password)) {
                        return 'Password must have the following:\n'
                            '- Minimum 8 characters long\n'
                            '- 1 uppercase letter\n'
                            '- 1 lowercase letter\n'
                            '- 1 number\n'
                            '- 1 special character';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //the exclamation point is Dart's syntax to only run the function if currentState is not null
                      if (_formKey.currentState!.validate()) {
                        //call _login();
                        //await can only be used in async functions-wait until the function is done and keep going
                        await _login();
                      }
                    },
                    child: Text("Login"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //the exclamation point is Dart's syntax to only run the function if currentState is not null
                      context.go("/signup");
                    },
                    child: Text("Sign Up"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/reset-password');
                    },
                    child: Text("Forgot Password"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
