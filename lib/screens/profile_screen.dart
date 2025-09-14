import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:super_youth/providers/auth_provider.dart';
import 'package:super_youth/widgets/nav_drawer.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Super Youth")),
      drawer: NavDrawer(),
      body: Center(
        child: Consumer<AuthenticationProvider>(
          builder: (context, auth, _) {
            String firstName = auth.userData?['firstName'];
            String lastName = auth.userData?['lastName'];
            String username = auth.userData?['username'];
            String email = auth.userData?['email'];

            return Container(
              margin: EdgeInsets.only(top: 35),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Profile",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    if (!_isEditing) ...[
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
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        child: Text("Edit Profile"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Delete Account"),
                      ),
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
                        child: Text("Sign Out"),
                      ),
                    ] else
                      _buildEditProfile(),
                    //on button press, function runs
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEditProfile() {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 25,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(hintText: "Username"),
            validator: (String? username) {
              if (username == null ||
                  username.length < 3 ||
                  username.length > 20) {
                return 'Username must be between 3 and 20 characters long.';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(hintText: "First Name"),
            validator: (String? fname) {
              if (fname == null || fname.length < 3 || fname.length > 10) {
                return 'Name must be between 3 and 10 characters long.';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(hintText: "Last name"),
            validator: (String? lname) {
              if (lname == null || lname.length < 3 || lname.length > 10) {
                return 'Username must be between 3 and 10 characters long.';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              _updateProfile();
            },
            child: Text("Update Profile"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isEditing = false;
              });
            },
            label: Text("Back"),
            icon: Icon(Icons.arrow_back),
          ),
        ],
      ),
    );
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      AuthenticationProvider authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.updateProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
      );
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Profile updated successfully")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to update profile")));
    }
  }
}
