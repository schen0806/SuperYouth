import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:super_youth/providers/auth_provider.dart';

//import the StatelessWidget material version
class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PasswordResetScreenState();
  }
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController(); //control how we submit the values in the form, how we validate the data
  //e.g. password rules, check if the email is valid
  final _confirmEmailController = TextEditingController();

  Future<void> _sendPasswordResetEmail() async {
    try {
      AuthenticationProvider authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.sendPasswordResetEmail(_emailController.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset email successfully sent")),
      );
      context.go('/login');
    } catch (e) {
      //if the app is still active, then stop running the function
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not send password reset email. Try again."),
        ),
      );
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
                    "Reset Password",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      label: Text("Email"),
                      prefixIcon: Icon(Icons.email),
                      hintText: "Enter Email",
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
                    controller: _confirmEmailController,
                    decoration: InputDecoration(
                      hintText: "Confirm email",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Georgia",
                    ),
                    validator: (String? email) {
                      if (email != _emailController.text) {
                        return 'Emails do not match';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //the exclamation point is Dart's syntax to only run the function if currentState is not null
                      if (_formKey.currentState!.validate()) {
                        _sendPasswordResetEmail();
                      }
                    },
                    child: Text("Reset password"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: Text("Back to login"),
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
