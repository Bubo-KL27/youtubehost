import 'package:flutter/material.dart';
import 'package:youtube/Widget/loginform.dart';

class LoginScreenWeb extends StatefulWidget {
  const LoginScreenWeb({super.key});

  @override
  State<LoginScreenWeb> createState() => _LoginScreenWebState();
}

class _LoginScreenWebState extends State<LoginScreenWeb> {
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
                          top: 50,
                          bottom: 8,
                          left: 50,
                          right: 50,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Login ", style: TextStyle(fontSize: 50)),
                            SizedBox(height: 50),
                            Loginform(),
                          ],
                        ),
                      ),
                    ),
                  )
                  :
                  //mobile
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 50,
                        bottom: 8,
                        left: 50,
                        right: 50,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Login ", style: TextStyle(fontSize: 50)),
                          SizedBox(height: 50),
                          Loginform(),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
