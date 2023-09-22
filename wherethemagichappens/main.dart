
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:SpartySched/TutorHome.dart';
import 'package:SpartySched/FirebaseStartup.dart';
import 'package:SpartySched/myprof.dart';
import 'package:SpartySched/Tutor_profile.dart';
import 'package:SpartySched/StudentHome.dart';

import 'ListOfAppointments.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase for all platforms(android, ios, web)
  await Firebase.initializeApp(
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    _getUser();
    return MaterialApp(
      home: FireBaseAuth(),
      routes: {
        '/login': (context) => const FireBaseAuth(),
        '/home': (context) =>
             MainPageStudent(),
        '/profile': (context) => const MyProfile(),
        '/MyAppointments': (context) => const AppointmentList(),
        '/TutorProfile': (context) => TutorProfile(),
      },
      theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,

    );
  }
}
