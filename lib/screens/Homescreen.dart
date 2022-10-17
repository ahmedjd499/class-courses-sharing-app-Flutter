import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_house/screens/userProfilScreen.dart';
import 'package:club_house/screens/addDocument.dart';
import 'package:club_house/models/room_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user_profile_image.dart';


class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  var userData={};

  getUser() async {
    String? fname;
    String? lname;
    String? section;
    String? group;
    final String email = FirebaseAuth.instance.currentUser!.email!;

    await FirebaseFirestore.instance.collection('user').doc(email).get().then((value) {
      fname = value.data()!['fname'];
      lname = value.data()!['lname'];
      section = value.data()!['section'];
      group = value.data()!['group'];
      setState(() {
        userData = {
          'fname': fname,
          'lname': lname,
          'section': section,
          'group': group,
          'email': email,
        };
      });
    });
  }
  @override
  void initState() {

    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Center(
            child: Text(
               userData.isNotEmpty ? '${userData['section']} Courses' : 'loading',
              style: const TextStyle( fontWeight: FontWeight.bold),
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.search,
              size: 28,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(
                CupertinoIcons.bell_fill,
                size: 24,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(fullscreenDialog: true, builder: (_) => UserProfilScreen(email:userData['email'],))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: UserProfileImage(
                  size: 40,
                  userEmail: userData.isNotEmpty ?userData['email']:'email',
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          
          children: [

            ListView(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 100),
              children:  [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Colors.white,),

                  child: const Text('Latest updates 👇👇👇',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.indigo),)),

                const SizedBox(height: 10,),
                const RoomCard(),

              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
                      Theme.of(context).scaffoldBackgroundColor,
                    ])),
              ),
            ),
            Positioned(
              bottom: 40,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddDocument()));
                },
                icon: const Icon(
                  CupertinoIcons.add,
                  size: 21,
                  color: Colors.white,
                ),
                label: const Text(
                  'Add Course',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12), backgroundColor: Theme.of(context).colorScheme.secondary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
