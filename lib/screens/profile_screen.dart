import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:super_youth/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Super Youth")),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //onPressed serves as a function that responds to a specific input i.e. press
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
        child: Consumer<AuthenticationProvider>(
          builder: (context, auth, _) {
            String firstName = auth.userData?['firstName'];
            String lastName = auth.userData?['lastName'];
            String username = auth.userData?['username'];
            String email = auth.userData?['email'];

            return Container(
              margin: EdgeInsets.only(top: 35),
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Profile",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Image.asset("assets/blank_avatar.webp", width: 125),
                  Text(
                    firstName,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    lastName,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    username,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    email,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  //on button press, function runs
                  ElevatedButton(
                    onPressed: () async {
                      await Provider.of<AuthenticationProvider>(
                        context,
                        listen: false,
                      ).signOut();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                    child: Text("sign out"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
