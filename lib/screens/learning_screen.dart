import 'package:flutter/material.dart';
import 'package:super_youth/widgets/nav_drawer.dart';

class LearningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Love it or hate it, learn it",
              textAlign: TextAlign.start,
              style: TextTheme.of(context).headlineMedium,
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text("Super Youth")),
      drawer: NavDrawer(),
    );
  }
}
