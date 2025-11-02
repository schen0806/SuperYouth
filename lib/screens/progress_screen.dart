import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_youth/providers/auth_provider.dart';
import 'package:super_youth/widgets/nav_drawer.dart';

class ProgressScreen extends StatefulWidget {
  @override
  @override
  State<StatefulWidget> createState() {
    return _ProgressScreenState();
  }
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Super Youth")),
      drawer: NavDrawer(),
      body: SafeArea(
        child: Center(
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
                      if (snapshot.data![i] != 0)
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
                    Consumer<AuthenticationProvider>(
                      builder: (
                          BuildContext context,
                          AuthenticationProvider auth,
                          Widget? child,
                          ) {
                        return Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            spacing: 20,
                            children: [
                              Text(
                                "Level: ${auth.userData?['level']}",
                                style: TextTheme.of(context).displayMedium,
                              ),
                              _buildXPBar(auth.userData?['level'], auth.userData?['xp']),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildXPBar(int level, int xp) {
    int xpCost = 15 + 5 * (level - 1);
    //percentage conversion for progress bar
    double percentXP = xp / xpCost;
    print(percentXP);
    return LinearProgressIndicator.new(value: percentXP, color: Colors.cyan);
  }
}

/*

 */
