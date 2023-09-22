// This class searches for specified data in a file.
// It imports required packages and defines the TutorOrStudent widget.
// It extends the StatefulWidget class, which means that it can be modified and rebuilt based on user interactions.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SpartySched/TutorHome.dart';
import 'package:SpartySched/StudentHome.dart';

class TutorOrStudent extends StatefulWidget {
  const TutorOrStudent({Key? key}) : super(key: key);

  @override
  State<TutorOrStudent> createState() => _TutorOrStudentState();
}

class _TutorOrStudentState extends State<TutorOrStudent> {
  bool _isLoading = true;

  void _setUser() async {
    final User? user = FirebaseAuth.instance
        .currentUser; // retrieves the current user
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get(); // retrieves the user's data from the Firestore database

    var basicInfo = snap.data() as Map<String,
        dynamic>; // stores the user's data in a Map object

    basicInfo['type'] == 'Tutor'
        ? true
        : false; // sets the isTutor global variable based on the user's data
    // prints out the value of isTutor for debugging purposes
    setState(() {
      _isLoading =
      false; // sets the _isLoading flag to false once the user data is retrieved and processed
    });
  }

  @override
  void initState() {
    super.initState();
    _setUser(); // calls the _setUser function to set the user when the widget is initialized
  }

// This function builds the UI for the widget
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const MainPageTutor() // shows the main page for tutor users if the user is a tutor
        : const MainPageStudent(); // shows the main page for student users if the user is not a tutor
  }
}
