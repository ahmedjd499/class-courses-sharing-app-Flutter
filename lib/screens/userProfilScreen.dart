import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_profile_image.dart';
import 'login.dart';

class UserProfilScreen extends StatelessWidget {
  final String email ;
  const UserProfilScreen({Key? key, required this.email, }) : super(key: key);

   Widget getData(BuildContext context,String field) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('user').doc(email).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var userDocument = snapshot.data;
          return Text(userDocument?[field],
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: Colors.grey[800]
              ),);
        }
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          email== FirebaseAuth.instance.currentUser!.email ?
          'My Profile' : 'profile',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.blueGrey,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                shape: BoxShape.rectangle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  )
                ]),
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: UserProfileImage(size: 100,userEmail: email,),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'First name   ',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Colors.blueGrey
                          ),
                        ),
                        const SizedBox(height: 20,),

                        Text(
                          'Last name   ',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Colors.blueGrey
                          ),
                        ),
                        const SizedBox(height: 20,),

                        Text(
                          'Section        ',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Colors.blueGrey
                          ),
                        ),
                        const SizedBox(height: 20,),

                        Text(
                          'Group ',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Colors.blueGrey
                          ),
                        ),

                        const SizedBox(height: 20,),



                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getData(context, 'fname'),
                        const SizedBox(height: 20,),

                        getData(context, 'lname'),
                        const SizedBox(height: 20,),

                        getData(context, 'section'),
                        const SizedBox(height: 20,),

                        getData(context, 'group'),
                        const SizedBox(height: 20,),
                      ],
                    )
                  ],
                ),


              ],

            ),

          ),

          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width/2-100,
            right:MediaQuery.of(context).size.width/2 -100,
            child:  email== FirebaseAuth.instance.currentUser!.email ? ElevatedButton.icon(onPressed:(){
              FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .push(MaterialPageRoute(fullscreenDialog: true, builder: (_) =>
                  const Login()));} ,
                label: const Text('signout',style: TextStyle(fontSize: 18),),
                icon: const Icon(Icons.logout_sharp),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800]),

            ):const SizedBox(),
          ),

        ],
      ),
    );
  }
}
