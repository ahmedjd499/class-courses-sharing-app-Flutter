import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AddDocument extends StatefulWidget {
  const AddDocument({Key? key}) : super(key: key);

  @override
  State<AddDocument> createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {
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

  var user = FirebaseAuth.instance.currentUser;

  String selectedValue = '';

  final _formKey = GlobalKey<FormState>();

  String selectedtype = '';

  PlatformFile? pickedFile;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }


  UploadTask? uploadTask;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Future addFile() async {
    await getUserData('user', FirebaseAuth.instance.currentUser!.email!, 'section');

    if (_formKey.currentState!.validate()) {
      final file = File(pickedFile!.path!);

      final path = 'classes/$section/$selectedValue/${pickedFile!.name}';

      final ref = FirebaseStorage.instance.ref().child(path);
      setState(() {
        uploadTask = ref.putFile(file);
      });

      await uploadTask!.whenComplete(() => {});

      final url = await ref.getDownloadURL();
      await getUser();

      await FirebaseFirestore.instance.collection('AddedDocs_${userData['section']}').doc(pickedFile!.name+DateTime.now().toString()).set({
        'fname': userData['fname'],
        'lname': userData['lname'],
        'subject': selectedValue,
        'email': userData['email'],
        'type': selectedtype,
        'date': '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} at ${DateTime.now().hour}:${DateTime.now().minute}',
        'title': _titleController.text,
        'desc': _descController.text,
        'url' : url ,
      });

      setState(() {

        uploadTask = null;
      });
    }
  }

  Widget getInfo(BuildContext context, String field) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var userDocument = snapshot.data;
          return Text(
            userDocument?[field],
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Colors.grey[800]),
          );
        });
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [];



    for (var element in list1) {
      menuItems.add(DropdownMenuItem(
        value: element,
        child: Text(element),
      ));
    }

    return menuItems;
  }

  List<DropdownMenuItem<String>> items = [
    const DropdownMenuItem(
      value: 'Course',
      child: Text('Course'),
    ),
    const DropdownMenuItem(
      value: 'TD/TP',
      child: Text('TD/TP'),
    ),
    const DropdownMenuItem(
      value: 'Resume',
      child: Text('Resume'),
    ),
    const DropdownMenuItem(
      value: 'other',
      child: Text('other'),
    )
  ];

  List<String> list1 = [];
  String section = '';

  getUserData(String collectionName, String docName, String field) async {
    await FirebaseFirestore.instance.collection(collectionName).doc(docName).get().then((value) {
      setState(() {
        section = value.data()![field];
      });
    });
  }

  getData(String collectionName, String docName, String field) async {
    await FirebaseFirestore.instance.collection(collectionName).doc(docName).get().then((value) {
      setState(() {

        for (var element in List.from(value.data()!['subjects'])) {
          String data = element;

          if (!list1.contains(data)) list1.add(data);
        }
      });
    });
  }

  Widget uploadProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 5.0,
            percent: progress,
            center: Text((100 * progress).roundToDouble() == 100
                ? 'Done'
                : '${(100 * progress).roundToDouble()}%'),
            progressColor: Colors.red,
          );
        } else {
          return const SizedBox(
            height: 50,
          );
        }
      });

  @override
  void initState() {

      getData('classes', 'L3_info', 'subjects');
      super.initState();
    }

  @override


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Add course  ',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
        ),
        centerTitle: true,
        foregroundColor: Colors.blueGrey,
      ),
      body: Stack(
        children: [
          Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.book,
                          size: 30,
                          color: Colors.indigoAccent,
                        ),
                        getInfo(context, 'section'),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DropdownButtonFormField(
                            validator: (value) {
                              if (selectedValue == "") {
                                return "please choose a Subject ";
                              } else {
                                return null;
                              }
                            },
                            items: dropdownItems,
                            hint: const Text('Select a Subject'),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedValue = newValue!;
                              });
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField(
                            validator: (value) {
                              if (selectedtype == "") {
                                return "choose Doc type";
                              } else {
                                return null;
                              }
                            },
                            items: items,
                            hint: const Text('Select a Type'),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedtype = newValue!;
                              });
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _titleController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "choose a title";
                            } else {
                              return null;
                            }
                          },
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            label: Text(
                              'Choose a title : ',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Description is needed';
                            } else {
                              return null;
                            }
                          },
                          controller: _descController,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            label: Text(
                              'Description : ',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            selectFile();
                          },
                          icon: const Icon(Icons.file_open_outlined),
                          label: const Text(
                            'pick up a file',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (pickedFile != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.blueGrey,
                            ),
                            child: Text(
                              pickedFile!.name,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        uploadProgress(),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await addFile();
                          },
                          label: const Text(
                            'ADD FILE',
                            style: TextStyle(fontSize: 18),
                          ),
                          icon: const Icon(Icons.check_box_outlined),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800]),
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
