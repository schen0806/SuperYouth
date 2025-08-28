import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_youth/data/unit.dart';
import 'package:super_youth/widgets/nav_drawer.dart';

import '../services/ai_service.dart';

class TryScreen extends StatefulWidget {
  final int unitNumber;
  final int scenarioNumber;

  TryScreen({
    super.key,
    required this.unitNumber,
    required this.scenarioNumber,
  });

  @override
  State<StatefulWidget> createState() {
    return _TryScreenState();
  }
}

class _TryScreenState extends State<TryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _responseController = TextEditingController();
  final AIService ai = AIService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Super Youth")),
      drawer: NavDrawer(),
      body: Center(
        child: FutureBuilder(
          future: ai.generateContent(units[widget.unitNumber - 1].name),
          builder: (
            BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot,
            //use dynamic to cover multiple data types that AI generator produces
          ) {
            if (snapshot.hasData) {
              return Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 17),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Your turn!",
                            style: TextTheme.of(context).headlineMedium,
                          ),
                          Text(
                            "Scenario ${widget.scenarioNumber}",
                            style: TextTheme.of(context).headlineLarge,
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          snapshot.data!['scenario'],
                          style: TextTheme.of(context).bodyLarge,
                        ),
                      ),
                      TextFormField(
                        maxLines: 5,
                        controller: _responseController,
                        validator: (String? response) {
                          if (response == null || response.isEmpty) {
                            return "Please enter a response.";
                          }
                          return null;
                        },
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              //context.push maintains screen history so the user can go back
                              context.push(
                                '/unit/${widget.unitNumber}/feedback/${widget.scenarioNumber}',
                                extra: Map.of({
                                  'scenario': snapshot.data!['scenario'],
                                  'userResponse': _responseController.text,
                                }),
                              );
                            }
                          },
                          child: Text("Submit"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text(
                "No scenarios at this moment. Come back soon!",
                style: TextTheme.of(context).headlineLarge,
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
