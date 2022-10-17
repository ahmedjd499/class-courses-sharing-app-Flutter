
import 'package:club_house/screens/Homescreen.dart';
import 'package:club_house/screens/signup.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String errorMessage = '';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Widget _erromsg() {
    return Text(errorMessage);
  }
  bool press=false ;

  Widget _subbmmitButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          press=true ;
        });
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
            .then((value) {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  const Homescreen()));
        }).onError((error, stackTrace) {
          setState(() {
            errorMessage = error.toString();
          });
        });
      },
      child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'Log IN',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),


      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
               if(press) if(press)const AlertDialog(
            title: Text(" checking information "),
        content: Text("please wait"),)else const SizedBox(height: 20,),

                Text(
                  'Welcome !',
                  style: GoogleFonts.bebasNeue(fontSize: 36),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Icon(
                  Icons.login,
                  size: 40,
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email : ',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password : ',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _erromsg(),



                _subbmmitButton()

                ,

                const SizedBox(
                  height: 25,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Not a member ? ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context)
                              .push(MaterialPageRoute(fullscreenDialog: true, builder: (_) =>
                              const Signup())),
                      child: const Text(
                        'Register now',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
