import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget{
  @override
  //creating widgets-create new objects of the classes of the widgets, and
  //provide them with the arguments with the parameters necessary
  //column center-start at the top, and end at the bottom
  //children is an array of widgets
  Widget build(BuildContext context) {
    //build method returns the scaffold
    return Scaffold(
      //create an AppBar with a title
      appBar: AppBar(
        title: Text("Super Youth"),
      ),
      //center the widget by creating a body
      body: Center(
        //the column is the parent widget where children widgets
        // are inherited from it
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          //make a widget array that holds the text and row
          //rows need to be in arrays of length >= 2
          children: [
            Image.asset(
                "assets/SYLogoTemp.webp",
                height: 150
            ), Text("The Road To Empowerment")
          ],
        ),
      )
    );
  }
}