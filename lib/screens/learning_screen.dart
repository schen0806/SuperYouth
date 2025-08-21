import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                context.go('/home');
              },
              child: Text("Home"),
            ),
            TextButton(
              onPressed: () {
                context.go('/profile');
              },
              child: Text("Profile"),
            ),
            TextButton(
              onPressed: () {
                context.go('/unit/1');
              },
              child: Text("Units"),
            ),
          ],
        ),
      ),
    );
  }
}
