import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/unit.dart';
import '../providers/ai_provider.dart';
import '../widgets/nav_drawer.dart';

class TryScreen extends StatefulWidget {
  final int unitNumber;
  final int scenarioNumber;

  const TryScreen({
    super.key,
    required this.unitNumber,
    required this.scenarioNumber,
  });

  @override
  State<StatefulWidget> createState() => _TryScreenState();
}

class _TryScreenState extends State<TryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _responseController = TextEditingController();
  late Future<Map<String, dynamic>> scenarioData;

  @override
  void initState() {
    super.initState();
    scenarioData = Provider.of<AIProvider>(
      context,
      listen: false,
    ).generateContent(units[widget.unitNumber - 1].name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: const Text('Super Youth')),
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: scenarioData,
            builder: (
              BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: 25,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Scenario ${widget.scenarioNumber}",
                          style: TextTheme.of(context).displaySmall,
                        ),
                        //Expanded fills in the remaining space of the column
                        Expanded(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              child: Text(
                                snapshot.data!['scenario'],
                                style: TextTheme.of(context).bodyLarge,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          maxLines: 8,
                          controller: _responseController,
                          decoration: InputDecoration(
                            labelText: 'Response',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (String? response) {
                            if (response == null || response.isEmpty) {
                              return 'Please enter a response.';
                            }
                            return null;
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.go(
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
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Could not generate scenario. Try again.",
                      style: TextTheme.of(context).bodyLarge?.apply(
                        color: Theme.of(context).colorScheme.error,
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
      ),
    );
  }
}
