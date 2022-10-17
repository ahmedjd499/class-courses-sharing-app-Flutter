import 'package:club_house/screens/completeSignup.dart';
import 'package:club_house/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? errorMessage = '';

  Widget _erromsg() {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          '$errorMessage',
          style: const TextStyle(color: Colors.red),
        ));
  }
  bool press=false ;
  Widget signupButton() {
    return Container(
      decoration: BoxDecoration(color: Colors.indigo,
        borderRadius: BorderRadius.circular(100)
      ),
      child: IconButton(
        onPressed: () {




          if (_formKey.currentState!.validate()) {
            setState(() {
              press=true ;
            });
            FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: _emailController.text, password: _passwordController.text)
                .then((value) {

              Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteSignup(docId: _emailController.text,)));
            }).onError((error, stackTrace) {
              setState(() {
                errorMessage = error.toString();
              });
            });
          }

        },
        icon: const Icon(
          Icons.keyboard_arrow_right,
        ),
          color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.grey,),
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: [
              const Text(
                'Here to Get',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              const Text(
                'Welcomed!!',
                style: TextStyle(fontSize: 30, color: Colors.white,fontWeight: FontWeight.bold),
              ),
          if(press)AlertDialog(
            title: const Text("Creating account"),
            content: const Text("please wait"),),

              SizedBox(height: height * 0.05),

              TextFormField(
                controller: _emailController,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                  ),
                  labelText: 'Enter your University  Email :',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
                ),

                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'^([a-zA-z]+\.[a-zA-z]+@isimm.u-monastir.tn)$').hasMatch(value)) {
                    return "please enter a valid Email ";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: height * 0.05),
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: _passwordController,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock_outlined,
                    color: Colors.white,
                  ),
                  labelText: 'Choose a password :',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
                ),
                validator: (value) {
                  if (value!.isEmpty || !RegExp(r'^[\w]').hasMatch(value)) {
                    return "please  enter a valid password ";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: height * 0.05),
              TextFormField(
                controller: _cpasswordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                  ),
                  labelText: 'Confirm your password :',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
                ),
                validator: (value) {
                  if (_passwordController.text != _cpasswordController.text) {
                    return "please a valid passworld ";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sign up now',
                    style: TextStyle(fontSize: 22, color: Colors.indigoAccent,fontWeight: FontWeight.bold),
                  ),
                  signupButton(),
                ],
              ),
              _erromsg(),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already Registred? ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(fullscreenDialog: true, builder: (_) => const Login())),
                    child:  Text(
                      'Log In now',
                      style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold,fontSize: 20),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
