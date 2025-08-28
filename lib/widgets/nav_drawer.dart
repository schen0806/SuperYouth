import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //onPressed serves as a function that responds to a specific input i.e. press
          TextButton(
            onPressed: () {
              context.go('/home');
            },
            child: Text("Home", style: TextTheme.of(context).headlineMedium),
          ),

          TextButton(
            onPressed: () {
              context.go('/profile');
            },
            child: Text("Profile", style: TextTheme.of(context).headlineMedium),
          ),
        ],
        spacing: 20,
      ),
    );
  }
}
