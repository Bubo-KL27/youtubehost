import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube/Screens/web_Screen/signup_screen.dart';
import 'package:youtube/Screens/web_Screen/webHomescreen.dart';


class Loginform extends StatefulWidget {
 const Loginform({super.key});

  @override
  State<Loginform> createState() => _LoginformState();
}

class _LoginformState extends State<Loginform> {
  

  Future<void> signInWithGoogleWeb(BuildContext context) async {
    try {
      // This works only on web
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      await FirebaseAuth.instance.signInWithPopup(authProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login successful!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Youtubewebhomescreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login failed: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            labelText: "Username",
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            labelText: "Password",
          ),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            final email = _emailController.text.trim();
            final password = _passwordController.text.trim();

            try {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: email,
                password: password,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Login succesful",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return Youtubewebhomescreen();
                  },
                ),
              );
            } on FirebaseAuthException catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    e.message ?? "Login failed",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Text("Login"),
        ),
        SizedBox(height: 20),
        Text("Or "),
        SizedBox(height: 20),
        TextButton(
          onPressed: () async {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => SignupScreenWeb()));
          },
          child: Text("Sign In"),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => signInWithGoogleWeb(context),

          child: Text("Google"),
        ),
      ],
    );
  }
}
