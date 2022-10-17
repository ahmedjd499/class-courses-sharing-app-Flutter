// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class UploadingImageToFirebaseStorage extends StatefulWidget {
  final String username;

  const UploadingImageToFirebaseStorage({
    super.key,
    required this.username,
  });

  @override

  _UploadingImageToFirebaseStorageState createState() => _UploadingImageToFirebaseStorageState();
}

class _UploadingImageToFirebaseStorageState extends State<UploadingImageToFirebaseStorage> {
  File? _imageFile;
  String imageURL = "";

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future uploadImageToFirebase(File image) async {
    String fileName = widget.username;

    final firebaseStorage = FirebaseStorage.instance;

    //Upload to Firebase
    var snapshot =
        await firebaseStorage.ref().child('profile_picture/$fileName').putFile(image);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      imageURL = downloadUrl;
    });

    await FirebaseFirestore.instance
        .collection('profile_picture')
        .doc(fileName)
        .set({'url': imageURL});
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: _imageFile != null
            ? Image.file(
                _imageFile!,

          fit: BoxFit.cover,

              )
            : GestureDetector(
                onTap: () async {
                  await pickImage();
                  _imageFile != null ? await uploadImageToFirebase(_imageFile!) : '';
                },
               child: Column(
                 children: const [
                   Icon(CupertinoIcons.camera_on_rectangle,size: 50,),
                   Text('profile picture')
                 ],
               )
              ));

  }
}
