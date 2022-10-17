
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_house/models/upload_image.dart';
import 'package:club_house/screens/login.dart';
import 'package:flutter/material.dart';

class CompleteSignup extends StatefulWidget {
  final String docId;


   const CompleteSignup({Key? key, required this.docId,}) : super(key: key);

  @override
  State<CompleteSignup> createState() => _CompleteSignupState();
}

class _CompleteSignupState extends State<CompleteSignup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();

  String selectedValue = "";
  String selectedGroupValue = "TP1";
  String? errorMessage = '';

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "L1_INFO", child: Text("L1_INFO")),
      const DropdownMenuItem(value: "L2_INFO", child: Text("L2_INFO")),
      const DropdownMenuItem(value: "L3_INFO", child: Text("L3_INFO")),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> grouplist = [
    const DropdownMenuItem(value: "TP1", child: Text("TP1")),
    const DropdownMenuItem(value: "TP2", child: Text("TP2")),
    const DropdownMenuItem(value: "TP3", child: Text("TP3")),
    const DropdownMenuItem(value: "TP4", child: Text("TP4")),
    const DropdownMenuItem(value: "TP5", child: Text("TP5")),
    const DropdownMenuItem(value: "TP6", child: Text("TP6")),
    const DropdownMenuItem(value: "TP7", child: Text("TP7")),
    const DropdownMenuItem(value: "TP8", child: Text("TP8")),
    const DropdownMenuItem(value: "TP9", child: Text("TP9")),
    const DropdownMenuItem(value: "TP10", child: Text("TP10")),
    const DropdownMenuItem(value: "TP11", child: Text("TP11")),
    const DropdownMenuItem(value: "TP12", child: Text("TP12")),
    const DropdownMenuItem(value: "TP13", child: Text("TP13")),
    const DropdownMenuItem(value: "TP14", child: Text("TP14")),
    const DropdownMenuItem(value: "TP15", child: Text("TP15")),
    const DropdownMenuItem(value: "TP16", child: Text("TP16")),
  ];
  List<DropdownMenuItem<String>> grouplistsub = [];

  List<DropdownMenuItem<String>> dropdownItemsGroup(selectedValue) {
    List<DropdownMenuItem<String>> ll = [];
    if (selectedValue == 'L1_INFO') {
      ll = grouplist.sublist(0, 16);
    } else if (selectedValue == 'L2_INFO') {
      ll = grouplist.sublist(0, 10);
    } else if (selectedValue == 'L3_INFO') {
      ll = grouplist.sublist(0, 10);
    }

    return ll;
  }

  Widget _finichSignupButton() {
    return Container(
      decoration: BoxDecoration(color: Colors.indigo, borderRadius: BorderRadius.circular(100)),
      child: IconButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await FirebaseFirestore.instance.collection('user').doc(widget.docId).set({
              'fname': _fnameController.text,
              'lname': _lnameController.text,
              'section': selectedValue,
              'group': selectedGroupValue,
            }).then((value) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
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

  Widget _erromsg() {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          '$errorMessage',
          style: const TextStyle(color: Colors.red),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(40),
              child: Form(
                key: _formKey,
                child: ListView(padding: const EdgeInsets.all(8), children: [
                  const Text(
                    'Complete your',
                    style: TextStyle(fontSize: 30, color: Colors.grey),
                  ),
                  const Text(
                    'Signing Up information!!',
                    style: TextStyle(fontSize: 30, color: Colors.grey),
                  ),
                  SizedBox(height: height * 0.03),
                  UploadingImageToFirebaseStorage(username: widget.docId,),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    controller: _fnameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter ur Firstname : ',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !RegExp(r'^[a-z A-Z]').hasMatch(value)) {
                        return "please enter a valid name ";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    controller: _lnameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter your Lastname : ',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !RegExp(r'^[a-z A-Z]').hasMatch(value)) {
                        return "please a valid name ";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  DropdownButtonFormField(
                      validator: (value) {
                        if (selectedValue == "") {
                          return "please choose a section ";
                        } else {
                          return null;
                        }
                      },
                      items: dropdownItems,
                      hint: const Text('Select your Section'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                          grouplistsub = dropdownItemsGroup(selectedValue);
                        });
                      }),
                  SizedBox(height: height * 0.02),
                  DropdownButtonFormField(
                      validator: (value) {
                        if (selectedGroupValue == "") {
                          return "please choose a group ";
                        } else {
                          return null;
                        }
                      },
                      isExpanded: true,
                      items: grouplistsub,
                      hint: const Text('Select your Group'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGroupValue = newValue!;
                        });
                      }),
                  SizedBox(height: height * 0.05),






              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'click to Continue',
                    style: TextStyle(fontSize: 22, color: Colors.indigoAccent),
                  ),
                  _finichSignupButton(),
                ],
              ),
              _erromsg(),
              ]),
        ),
      ),
    )),
    );
  }
}
