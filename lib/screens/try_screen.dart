import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:super_youth/data/unit.dart';
import 'package:super_youth/providers/ai_provider.dart';
import 'package:super_youth/widgets/nav_drawer.dart';

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

  //not initialized at the time of state creation
  late Future<Map<String, dynamic>> scenarioData;

  @override
  void initState() {
    super.initState();
    _responseController.clear();
    scenarioData = Provider.of<AIProvider>(
      context,
      listen: false,
    ).generateContent(units[widget.unitNumber - 1].name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Super Youth")),
      drawer: NavDrawer(),
      body: Center(
        child: FutureBuilder(
          future: scenarioData,
          builder: (
            BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot,
            //use dynamic to cover multiple data types that AI generator produces
          ) {
            if (snapshot.connectionState == ConnectionState.done) {
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
