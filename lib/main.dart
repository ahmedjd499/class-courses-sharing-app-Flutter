
import 'package:club_house/screens/opening_screen.dart';
import 'package:flutter/material.dart' ;
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COURY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        iconTheme: const IconThemeData(color: Colors.black),
        appBarTheme: const AppBarTheme(backgroundColor: kbackgroundcolor ),
        scaffoldBackgroundColor: kbackgroundcolor,
        primaryColor: Colors.white,
        fontFamily: GoogleFonts.montserrat().fontFamily,
        textTheme: GoogleFonts.montserratTextTheme(), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kaccentcolor) ,
      ),
      home: (
      const OpeningScreen()
      ),
    );
  }
}
