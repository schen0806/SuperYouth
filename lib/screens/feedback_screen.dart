import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:super_youth/data/unit.dart';
import 'package:super_youth/providers/auth_provider.dart';
import 'package:super_youth/widgets/nav_drawer.dart';

import '../providers/ai_provider.dart';

class FeedbackScreen extends StatefulWidget {
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

  @override
  State<StatefulWidget> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late Future<Map<String, dynamic>> feedbackData;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    feedbackData = Provider.of<AIProvider>(
      context,
      listen: false,
    ).generateFeedback(widget.scenario, widget.userResponse).then((feedback) {
      authProvider.updateProgress(
        widget.unitNumber,
        feedback,
        widget.scenario,
        widget.userResponse,
      );
      return feedback;
    });
  }

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

  int _calcXP(int score) {
    int XP = 0;
    if (score >= 8 && score <= 10) {
      XP += 10;
    } else if (score >= 5 && score < 8) {
      XP += 5;
    } else {
      XP += 3;
    }
    return XP;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Super Youth")),
      drawer: NavDrawer(),
      body: SafeArea(
        child: Center(
          child:
          //send userresponse from the try screen to the feedback screen
          //futurebuilder builds the UI from the future
          FutureBuilder(
            //get a provider form a widget class
            future: feedbackData,
            builder: (
              BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.done) {
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
                        "You gained ${_calcXP(feedback["score"])} XP.",
                        style: TextTheme.of(context).headlineMedium,
                      ),
                      Text(
                        _buildScoreMessage(feedback["score"]),
                        style: TextTheme.of(context).headlineMedium,
                      ),
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            _buildBulletPoints("Pros", feedback["pros"]),
                            style: TextTheme.of(context).bodyLarge,
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            _buildBulletPoints("Cons", feedback["cons"]),
                            style: TextTheme.of(context).bodyLarge,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.go("/unit/${widget.unitNumber}");
                        },
                        icon: Icon(Icons.arrow_back),
                        label: Text("Back to unit ${widget.unitNumber}"),
                      ),
                      if (widget.scenarioNumber <
                          units[widget.unitNumber - 1].numScenarios)
                        ElevatedButton.icon(
                          onPressed: () {
                            context.go(
                              "/unit/${widget.unitNumber}/try/${widget.scenarioNumber + 1}",
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
      ),
    );
  }
}
