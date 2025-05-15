import 'package:flutter/material.dart';
import 'package:super_youth/Course%20Screen.dart';

import 'Home Screen.dart';

//import the StatelessWidget material version
class LoginScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //param. always start lowercase
          title: Text("Super Youth")
      ),
      //body holds the actual content
      body: Center(
          child: Column(
            //use the TextField class
            children: [
              //organize array by having one item per line
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700
                )
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter username",
                  hintStyle: TextStyle(
                    color: Colors.teal.shade100,
                    fontFamily: "Georgia"
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                  ),
                ),
                style: const TextStyle(
                  color: Colors.blue,
                  fontFamily: "Georgia"
                ),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  hintStyle: TextStyle(
                    color: Colors.blue.withOpacity(0.5),
                    fontFamily: "Georgia"
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                  ),
                ),
                style: const TextStyle(
                  color: Colors.blue,
                  fontFamily: "Georgia"
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Text("Login")
              )
            ],
          )
      ),
    );
  }
}
