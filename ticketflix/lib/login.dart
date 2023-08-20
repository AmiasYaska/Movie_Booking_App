import 'package:flutter/material.dart';
import 'package:ticketflix/components/my_button.dart';
import 'package:ticketflix/components/my_textfield.dart';
import 'package:ticketflix/components/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});
  static const routeName = '/login';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user In method
  void signUserIn() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    // try signing in the user
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      // show error message
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
            )),
          );
        });
  }
    void navigateToLogoutPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LogoutPage()),
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
                    const SizedBox(height: 10),

                    // Image.asset("assets/images/up.png"),
                    // logo
                    const Icon(
                      Icons.lock,
                      size: 100,
                    ),

                    const SizedBox(height: 25),

                    // welcome back text
                    Text(
                      'Welcome to Ticketflix.',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // email Textfield
                    MyTextField(
                      controller: emailController,
                      hintText: 'email',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    // password textfield
                    MyTextField(
                      controller: passwordController,
                      hintText: 'password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 10),

                    // forgot password?
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'forgot password?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        )),
                    const SizedBox(height: 25),

                    // Sign In button
                    MyButton(
                      text: 'Sign In',
                      onTap: signUserIn,
                    ),

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
                            onTap: () {}, imagePath: 'assets/images/apple.png'),
                      ],
                    ),

                    // not a member, register now
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('Not a member?'),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text('Register now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ])
                    
                  ]),
            ),
          ),
          
        )
        );
  }
}
