import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;
  final int age;

  const ProfilePage({Key? key, required this.username, required this.email, required this.age})
      : super(key: key);
 

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.username;
    _emailController.text = widget.email;
    _ageController.text = widget.age.toString();
  }

  void _updateProfile() {
    String newUsername = _usernameController.text;
    String newEmail = _emailController.text;
    int newAge = int.tryParse(_ageController.text) ?? 0;

    // Perform logic to update the user's profile
    // For now, let's just print the updated data
    print('Updated Username: $newUsername');
    print('Updated Email: $newEmail');
    print('Updated Age: $newAge');
  }
  void register() {
  // Perform registration logic here
  String username = _usernameController.text;
  String email = _emailController.text;
  int age = int.tryParse(_ageController.text) ?? 0;

  // Navigate to the profile page and pass the user's information
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(username: username, email: email, age: age),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
