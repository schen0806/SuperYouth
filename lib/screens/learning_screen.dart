import 'package:flutter/material.dart';
import 'package:super_youth/widgets/nav_drawer.dart';

class LearningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Maslow's Hierarchy of Needs", textAlign: TextAlign.center),
          ],
        ),
      ),
      appBar: AppBar(title: Text("Super Youth")),
      drawer: NavDrawer(),
    );
  }
}
