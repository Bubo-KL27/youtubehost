// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:youtube/Screens/web_Screen/login_screen.dart';
import 'package:youtube/Widget/signup.dart';

class SignupScreenWeb extends StatelessWidget {
 const SignupScreenWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child:
              width > 600
                  ? Center(
                    child: Container(
                      width: width * 0.4,
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 10,
                          right: 10,
                        ),
                        child: Column(
                          spacing: 20,
                          children: [
                            Text("Signup", style: TextStyle(fontSize: 50)),
                            Signupform(),

                            SizedBox(height: 20),

                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreenWeb(),
                                  ),
                                );
                              },
                              child: Text("Back"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 10,
                        right: 10,
                      ),
                      child: Column(
                        spacing: 20,
                        children: [
                          Text("Signup", style: TextStyle(fontSize: 50)),
                          Signupform(),
                          SizedBox(height: 20),

                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreenWeb(),
                                ),
                              );
                            },
                            child: Text("Back"),
                          ),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
