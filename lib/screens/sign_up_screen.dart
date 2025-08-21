import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:super_youth/providers/auth_provider.dart';

//import the StatelessWidget material version
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  }); //flutter pass the key to bring back the exact state
  @override
  State<StatefulWidget> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController(); //control how we submit the values in the form, how we validate the data
  //e.g. password rules, check if the email is valid
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _usernameController = TextEditingController();

  Future<void> _signUp() async {
    //the function attempts to sign up a new user
    //email and password
    try {
      await Provider.of<AuthenticationProvider>(context, listen: false).signUp(
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _firstnameController.text,
        lastName: _lastnameController.text,
        username: _usernameController.text,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'email-already-in-use' && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Email already in use")));
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
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            //use the TextField class
            children: [
              //organize array by having one item per line
              Text(
                "Sign up",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: "Email"),
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
                controller: _usernameController,
                decoration: const InputDecoration(hintText: "Username"),
                validator: (String? username) {
                  if (username == null ||
                      username.length < 3 ||
                      username.length > 20) {
                    return 'Username must be between 3 and 20 characters long.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _firstnameController,
                decoration: const InputDecoration(hintText: "First Name"),
                validator: (String? fname) {
                  if (fname == null || fname.length < 3 || fname.length > 10) {
                    return 'Name must be between 3 and 10 characters long.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastnameController,
                decoration: const InputDecoration(hintText: "Last name"),
                validator: (String? lname) {
                  if (lname == null || lname.length < 3 || lname.length > 10) {
                    return 'Username must be between 3 and 10 characters long.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(hintText: 'Password'),
                obscureText: true,
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
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(hintText: 'Confirm password'),
                obscureText: true,
                validator: (String? password) {
                  if (password != _passwordController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    //in flutter, values can be null.
                    //using the exclamation point forces Flutter to treat the value that can't be null.'
                    await _signUp();
                  }
                },
                child: Text("Sign up"),
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
    );
  }
}
