import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_house/models/user_profile_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../screens/userProfilScreen.dart';

class RoomCard extends StatefulWidget {
  const RoomCard({super.key});

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  var _userData = {};

  get userData => _userData;

  set userData(userData) {
    _userData = userData;
  }

  var allDocs = [];

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

  Future<void> getData() async {
    await getUser();

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('AddedDocs_${userData['section']}');
    QuerySnapshot querySnapshot = await collectionRef.orderBy('date',descending: true).get();

    // Get data from docs and convert map to List
    final List<Object?> allData;
    if (querySnapshot.docs.isNotEmpty) {
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();

      setState(() {
        allDocs = allData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    getData();
    return Column(
      children: [
        if (allDocs.isNotEmpty)
          ...allDocs.map((oneRoom) => roomModel(room: oneRoom))
        else
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'please wait for loading to finish',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          )
      ],
    );
  }

  Widget roomModel({required room}) {
    Future<void> launchUrl() async {
      final String url = '${room['url']}';
      if (!await launchUrlString(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    }

    return Card(
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Text(
                    'Course title : ',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.0,
                        ),
                  ),
                  Text(
                    '${room['title']} '.toUpperCase(),
                    style: Theme.of(context).textTheme.overline!.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                        color: Colors.deepPurpleAccent),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'Course type : ',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.0,
                        ),
                  ),
                  Text(
                    '${room['type']} '.toUpperCase(),
                    style: Theme.of(context).textTheme.overline!.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                        color: Colors.deepPurpleAccent),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'subject : ',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.0,
                        ),
                  ),
                  Text(
                    '${room['subject']} '.toUpperCase(),
                    style: Theme.of(context).textTheme.overline!.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                        color: Colors.deepPurpleAccent),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'added by : ',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Colors.deepOrange,
                    ),
              ),
              Row(
                children: [
                  GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (_) => UserProfilScreen(
                                email: room['email'],
                              ))),
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: UserProfileImage(
                            size: 40,
                            userEmail: '${room['email']}',
                          ))),
                  Text(
                    '${room['fname']} ',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                  ),
                  Text(
                    '${room['lname']} '.toUpperCase(),
                    style: Theme.of(context).textTheme.overline!.copyWith(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0,
                        ),
                  ),
                ],
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    launchUrl();
                    // await launch('${room['URL']}') ;
                  },
                  icon: const Icon(Icons.download_for_offline),
                  label: const Text(
                    'View OR Download',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                ' ${room['date']}',
              )
            ]),
          )),
    );
  }
}
