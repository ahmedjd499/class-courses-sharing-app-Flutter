import 'package:club_house/constants.dart';
import 'package:club_house/screens/signup.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class OpeningScreen extends StatelessWidget {
  const OpeningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      color: kbackgroundcolor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Welcome , ',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none
                  ),
                ),
                Text(
                  'Here to get started',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none
                  ),
                ),
              ],
            ),
          ),
          Card(
            color: Colors.blueGrey[200],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0,vertical: 60),
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(fullscreenDialog: true, builder: (_) => const Login())),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700]),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(fullscreenDialog: true, builder: (_) => const Signup())),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 15),
                        child: Text('Sign Up',
                          style:
                          TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
