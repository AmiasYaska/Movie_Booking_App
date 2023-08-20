import 'package:flutter/material.dart';
import 'package:ticketflix/components/my_button.dart';
import 'package:ticketflix/components/my_textfield.dart';
import 'package:ticketflix/components/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (passwordController.text != confirmPasswordController.text) {
        Navigator.pop(context);
        showErrorMessage("Passwords don't match");
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

      await usersCollection.doc(userCredential.user!.uid).set({
        'email': emailController.text,
      });

      Navigator.pop(context); // Close loading dialog

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close loading dialog
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                const Icon(
                  Icons.lock,
                  size: 50,
                ),
                const SizedBox(height: 15),
                Text(
                  'Let\'s create an account for you.',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: 'Sign Up',
                  onTap: signUserUp,
                ),
                // ... Other widgets ...


                const SizedBox(height: 50),

                // Or continue with
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('Or continue with'),
                      ),
                      Expanded(
                          child: Divider(
                            thickness: 1,
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // google and apple buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //google button
                    SquareTile(
                       onTap: () {},
                        imagePath: 'assets/images/google.png'),

                    const SizedBox(width: 25),

                    SquareTile(
                      onTap: (){},
                        imagePath: 'assets/images/apple.png'),
                  ],
                ),

                // not a member, register now
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Already have an account'),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text('Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        )),
                  ),

                ])
              ]),
            ),
          ),
        ));
  }
}
     
