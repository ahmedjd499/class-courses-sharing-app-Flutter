import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UserProfileImage extends StatelessWidget {
  final double size ;
  final String userEmail ;

  Widget getImage(BuildContext context) {
    String url= 'https://firebasestorage.googleapis.com/v0/b/clubhouse-12c0f.appspot.com/o/profile_picture%2Fgg.png?alt=media&token=d5c9ecca-8fd2-4bf9-957b-089cf9474f6b';

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('profile_picture').doc(userEmail).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            {
              return  ClipRRect(
                borderRadius: BorderRadius.circular(size/2 - size/10),
                child:const Text('loading',

                  style: TextStyle(color: Colors.black),
                ));
            }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return  ClipRRect(
              borderRadius: BorderRadius.circular(size/2 - size/10),
              child:Image.network(
                url,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            );
          }
          var userImage = snapshot.data ;

          return  ClipRRect(
            borderRadius: BorderRadius.circular(size/2 - size/10),
            child: Image.network(
              userImage?['url'],
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          );
        }
    );
  }

  const UserProfileImage({super.key, required this.size, required this.userEmail, });

  @override
  Widget build(BuildContext context) {
    return getImage(context);
  }
}

