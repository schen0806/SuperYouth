import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_youth/widgets/nav_drawer.dart';

import '../data/unit.dart';

class UnitScreen extends StatelessWidget {
  final int unitNumber;

  const UnitScreen({super.key, required this.unitNumber});

  @override
  Widget build(BuildContext context) {
    Unit unit = units[unitNumber - 1];
    //Scaffolds always have an appBar and a body
    return Scaffold(
      appBar: AppBar(title: Text("Super Youth")),
      drawer: NavDrawer(),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 35),

          child: Column(
            //actual content/text
            children: [
              Text(
                style: Theme.of(context).textTheme.displayMedium,
                "Unit $unitNumber",
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
              Column(
                spacing: 10,
                children: [
                  for (int i = 1; i <= unit.numScenarios; i++)
                    ElevatedButton(
                      onPressed: () {
                        context.push('/unit/$unitNumber/try/$i');
                      },
                      child: Text(
                        "scenario $i",
                        style: Theme.of(context).textTheme.headlineSmall,
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
