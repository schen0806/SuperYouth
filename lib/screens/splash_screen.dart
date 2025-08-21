import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    //equivalent of time.sleep in python
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) {
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    //gets user from AuthProvider
    //get AuthProvider
    //check if the user had logged in before
    //move user to corresponding screen whether they are logged in or not
    if (currentUser == null) {
      context.go('/login');
    } else {
      context.go('/home');
    }
  }

  @override
  //creating widgets-create new objects of the classes of the widgets, and
  //provide them with the arguments with the parameters necessary
  //column center-start at the top, and end at the bottom
  //children is an array of widgets
  //build method builds the UI and widgets
  Widget build(BuildContext context) {
    //build method returns the scaffold
    return Scaffold(
      //create an AppBar with a title
      //center the widget by creating a body
      body: Center(
        //the column is the parent widget where children widgets
        // are inherited from it
        child: Container(
          margin: EdgeInsets.only(top: 250),
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            //make a widget array that holds the text and row
            //rows need to be in arrays of length >= 2
            children: [
              Image.asset("assets/SY_Logo.png", width: 300),
              Text(
                "Super Youth",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
