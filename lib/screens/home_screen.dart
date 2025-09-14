import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:super_youth/providers/auth_provider.dart';
import 'package:super_youth/widgets/nav_drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Scaffolds always have an appBar and a body
    return Scaffold(
      appBar: AppBar(title: Text("Super Youth")),
      drawer: NavDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/homeScreenBackground.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 24,
            children: [
              Consumer<AuthenticationProvider>(
                builder: (context, authProvider, _) {
                  final name = authProvider.userData?['firstName'] ?? 'there';

                  return Text(
                    "Hello $name!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium,
                  );
                },
              ),
              Text(
                style: Theme.of(context).textTheme.displaySmall,
                "Your Journey",
              ),

              Text(style: Theme.of(context).textTheme.displaySmall, "Units"),
              Align(
                alignment: Alignment(0, -0.8),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/unit/6');
                  },
                  child: Text(
                    style: Theme.of(context).textTheme.displaySmall,
                    "6",
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.4, 1),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/unit/5');
                  },
                  child: Text(
                    style: Theme.of(context).textTheme.displaySmall,
                    "5",
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 1),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/unit/4');
                  },
                  child: Text(
                    style: Theme.of(context).textTheme.displaySmall,
                    "4",
                  ),
                ),
              ),
              Align(
                alignment: Alignment(-0.4, 1),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/unit/3');
                  },
                  child: Text(
                    style: Theme.of(context).textTheme.displaySmall,
                    "3",
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 1),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/unit/2');
                  },
                  child: Text(
                    style: Theme.of(context).textTheme.displaySmall,
                    "2",
                  ),
                ),
              ),
              Align(
                alignment: Alignment(-0.4, 1),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/unit/1');
                  },
                  child: Text(
                    style: Theme.of(context).textTheme.displaySmall,
                    "1",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
