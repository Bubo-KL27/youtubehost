import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube/Screens/Android/home_screen.dart';
import 'package:youtube/Screens/Android/signup_screen.dart';



class LoginScreenAndroid extends StatelessWidget {
  LoginScreenAndroid({super.key});
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                  TextFormField(
                    controller: _usernameController,
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
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final user = _usernameController.text.trim();
                      final pass = _passwordController.text.trim();

                      final prefes = await SharedPreferences.getInstance();
                      final savedUsername = prefes.getString('username');
                      final savedPassword = prefes.getString("password");

                      if (pass == savedPassword && user == savedUsername) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup successfully",style: TextStyle(color: Colors.white),),backgroundColor:Colors.green,),);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => Mobileyoutubehome()
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Invalid username or password",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text("Login"),
                  ),
                  SizedBox(height: 16),
                  Text("Or "),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>SignupScreenAndroid(),),
                      );
                    },
                    child: Text("Sign In"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.g_mobiledata),
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
