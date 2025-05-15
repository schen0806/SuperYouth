import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //Scaffolds always have an appBar and a body
    return Scaffold(
      appBar: AppBar(
        title: Text("Super Youth")
      ),
      body: Center(
        child: Column(
          //actual content/text
          children: [
            Text("Home")
          ],
        )
      )
    );
  }
}