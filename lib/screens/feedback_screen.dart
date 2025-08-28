import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_youth/data/unit.dart';
import 'package:super_youth/widgets/nav_drawer.dart';

import '../services/ai_service.dart';

class FeedbackScreen extends StatelessWidget {
  final AIService ai = AIService();
  final String userResponse;
  final String scenario;
  final int unitNumber;
  final int scenarioNumber;

  FeedbackScreen({
    super.key,
    required this.unitNumber,
    required this.scenario,
    required this.userResponse,
    required this.scenarioNumber,
  });

  String _buildScoreMessage(int score) {
    if (score >= 9)
      return "Amazing";
    else if (score <= 8 && score >= 6)
      return "Good job";
    else
      return "Nice try";
  }

  String _buildBulletPoints(String title, List<dynamic> bulletPoints) {
    if (bulletPoints.isEmpty) {
      return "";
    }
    String output = "$title:\n";

    for (int i = 0; i < bulletPoints.length; i++) {
      String currBP = bulletPoints[i];
      output += "- $currBP\n";
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Super Youth")),
      drawer: NavDrawer(),
      body: Center(
        child:
        //send userresponse from the try screen to the feedback screen
        //futurebuilder builds the UI from the future
        FutureBuilder(
          future: ai.generateFeedback(scenario, userResponse),
          builder: (
            BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot,
          ) {
            if (snapshot.hasData) {
              //access the feedback/actual data in the s
              //maps are dictionaries in flutter-key-value pair
              Map<String, dynamic> feedback = snapshot.data!;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  spacing: 15,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Feedback screen",
                      style: TextTheme.of(context).headlineMedium,
                    ),
                    Text(
                      "Score: ${feedback["score"]}/10",
                      style: TextTheme.of(context).headlineMedium,
                    ),
                    Text(
                      _buildScoreMessage(feedback["score"]),
                      style: TextTheme.of(context).headlineMedium,
                    ),
                    Text(
                      _buildBulletPoints("Pros", feedback["pros"]),
                      style: TextTheme.of(context).headlineSmall,
                    ),
                    Text(
                      _buildBulletPoints("Cons", feedback["cons"]),
                      style: TextTheme.of(context).headlineSmall,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.go("/unit/$unitNumber");
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text("Back to unit $unitNumber"),
                    ),
                    if (scenarioNumber < units[unitNumber - 1].numScenarios)
                      ElevatedButton.icon(
                        onPressed: () {
                          context.go(
                            "/unit/$unitNumber/try/${scenarioNumber + 1}",
                          );
                        },
                        icon: Icon(Icons.arrow_forward),
                        label: Text("Next scenario"),
                      ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text("Could not generate feedback. Try again.");
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
