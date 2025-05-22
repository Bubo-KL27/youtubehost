import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube/Screens/web_Screen/webHomescreen.dart';

class Signupform extends StatefulWidget {
  const Signupform({super.key});

  @override
  State<Signupform> createState() => _SignupformState();
}

class _SignupformState extends State<Signupform> {

  final _emailController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return      Column(
      spacing: 20,
      children: [
        TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                          icon: Icon(Icons.email),
                        ),
                      ),


                  TextFormField(
                    controller: _phonenumberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Phone Number",
                      icon: Icon(Icons.phone),
                    ),
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Username",
                      icon: Icon(Icons.man),
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      icon: Icon(Icons.password),
                    ),
                  ),
                      
                  TextFormField(
                    controller: _repasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "conform Password",
                      icon: Icon(Icons.password_rounded),
                    ),
                  ),
                      
                  ElevatedButton(
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      final repassword = _repasswordController.text.trim();
                      final username = _usernameController.text.trim();
                      final phone = _phonenumberController.text.trim();
                      final password = _passwordController.text.trim();
                      
                      final phoneRegex = RegExp(r"^\d{10}$");
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      
                      if (email.isEmpty ||
                          username.isEmpty ||
                          phone.isEmpty ||
                          password.isEmpty ||
                          repassword.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Please fill the blank ",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      if (!emailRegex.hasMatch(email)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Please Enter valid email adress",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      if (username.length < 3) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "username must be atleast 3 characters",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      if (!phoneRegex.hasMatch(phone)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "please enter phone number",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (password.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Password must be at least 6 characters",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (repassword != password) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Password Not matching",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      // Save credentials using SharedPreferences
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                      
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Signup Successfully",
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
                      // ignore: unused_catch_clause
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Signup failed",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        
                      }
                      
                     
                    },
                      
                    child: Text("Signup"),
                      
                  ),
      ]
    );
  }
}