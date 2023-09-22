import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SpartySched/newdeets.dart';

class UserDetails extends UpdateUserDetails {
  final String label;
  final String field;
  final String value;
  UserDetails(
      {Key? key, required this.label, required this.field, required this.value})
      : super(key: key, label: label, field: field, value: value);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  Map<String, dynamic> details = {};
  //all of the user details are stored on a map within Firebase
  Future<void> _getUser() async {
    user = _auth.currentUser!;
  }


  Future<void> _retrieveUserData(String collection, String userId) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection(collection)
        .doc(userId)
        .get();

    if (snap.exists) {
      setState(() {
        details = snap.data() as Map<String, dynamic>;
      });
    } else {
      await _createUserData(collection, userId);
      await _retrieveUserData(collection, userId);
    }
  }

  Future<void> _createUserData(String collection, String userId) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(userId)
        .set({});
  }


  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
        controller: ScrollController(),
        shrinkWrap: true,
        itemCount: details.length,
        itemBuilder: (context, index) {
          String key = details.keys.elementAt(index);
          String value =
              details[key] == null ? 'Not Added' : details[key].toString();
          String label = key[0].toUpperCase() + key.substring(1);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: InkWell(
              splashColor: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateUserDetails(
                      label: label,
                      field: key,
                      value: value,
                    ),
                  ),
                ).then((value) {
                  // reload page
                  _getUser();
                  setState(() {});
                });
              },
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  height: MediaQuery.of(context).size.height / 14,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.arvo(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        value.substring(0, min(20, value.length)),
                        style: GoogleFonts.arvo(
                          color: Colors.black54,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
