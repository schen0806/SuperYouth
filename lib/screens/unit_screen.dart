import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/unit.dart';

class UnitScreen extends StatelessWidget {
  final int id;

  const UnitScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    Unit unit = units[id - 1];
    //Scaffolds always have an appBar and a body
    return Scaffold(
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
          ],
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 35),

          child: Column(
            //actual content/text
            children: [
              Text(
                style: Theme.of(context).textTheme.displayMedium,
                "Unit $id",
              ),
              Text(
                style: Theme.of(context).textTheme.displaySmall,
                unit.name,
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  unit.description,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/learn');
                  },
                  child: Text(
                    "Learn",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              Column(
                spacing: 10,
                children: [
                  for (int i = 1; i <= unit.numScenarios; i++)
                    ElevatedButton(
                      onPressed: () {
                        context.push('/unit/$id/try');
                      },
                      child: Text(
                        "scenario $i",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
