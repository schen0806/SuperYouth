import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}
class _ProfileScreenState extends State<ProfileScreen>{
  String _name = "Sunny";
  void _changeName(){
    setState(() {
      _name = "world";
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Super Youth"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Profile"
              , style: TextStyle(fontSize: 40)
              ),
              Text("Hello $_name", style: TextStyle(fontSize: 40),
              ),
              TextButton(onPressed: _changeName, child: Text("Change user"))
            ],
          ),
        )
    );
  }
}