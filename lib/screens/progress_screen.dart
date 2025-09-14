import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_youth/providers/auth_provider.dart';
import 'package:super_youth/widgets/nav_drawer.dart';

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Super Youth")),
      drawer: NavDrawer(),
      body: Center(
        child: FutureBuilder(
          future:
              Provider.of<AuthenticationProvider>(
                context,
                listen: false,
              ).getAvgScore(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<double>> snapshot,
          ) {
            if (snapshot.hasData) {
              return Column(
                spacing: 20,
                children: [
                  Text("Progress", style: TextTheme.of(context).displayMedium),
                  //loop through each avg score in the snapshot data
                  for (int i = 0; i < snapshot.data!.length; i++)
                    Card(
                      child: SizedBox(
                        height: 80,
                        width: 230,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Average Score for Unit ${i + 1}: ",
                              style: TextTheme.of(context).bodyLarge,
                            ),
                            Text(
                              "${snapshot.data![i].toStringAsFixed(2)}",
                              style: TextTheme.of(context).displaySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
