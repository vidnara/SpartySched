import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  late String _documentID;

  Future<void> _getUser() async {
    user = _auth.currentUser!;
  }

  String _dateFormatter(String timestamp) {
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(timestamp));
    return formattedDate;
  }

  Future<void> showAlertDialog(BuildContext context, String TutorId, String StudentId) async {
    // No
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );

    //
  }

  // helping in removing pending appointment
  _checkDiff(DateTime date) {
    print(date);
    var diff = DateTime.now().difference(date).inSeconds;
    print('date difference : $diff');
    if (diff > 0) {
      return true;
    } else {
      return false;
    }
  }
  Future<void> deleteAppointment(
      String docID, String TutorId, String StudentId) async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(TutorId)
        .collection('pending')
        .doc(docID)
        .delete()
        .catchError((error) {
      // if the delete fails due to network issues, retry the delete operation after a delay of 1 second
      Future.delayed(const Duration(seconds: 1), () {
        deleteAppointment(docID, TutorId, StudentId);
      });
    });
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(StudentId)
        .collection('pending')
        .doc(docID)
        .delete()
        .catchError((error) {
      // if the delete fails due to network issues, retry the delete operation after a delay of 1 second
      Future.delayed(const Duration(seconds: 1), () {
        deleteAppointment(docID, TutorId, StudentId);
      });
    });
  }


  // for comparing date
  _compareDate(String date) {
    if (_dateFormatter(DateTime.now().toString())
            .compareTo(_dateFormatter(date)) ==
        0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .doc(user.uid)
            .collection('pending')
            .orderBy('date')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data!.size == 0
              ? Center(
                  child: Text(
                    'No Appointment Scheduled',
                    style: GoogleFonts.arvo(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];

                    // each appointment
                    return Card(
                      elevation: 2,
                      child: InkWell(
                        onTap: (
                            {color: const Color(0xFF002707)}
                            ) {},
                        child: ExpansionTile(
                          initiallyExpanded: true,

                          // main info of appointment
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Tutor name
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                       document['StudentName'],
                                  style: GoogleFonts.arvo(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF002707),
                                  ),
                                ),
                              ),

                              // Today label
                              Text(
                                _compareDate(
                                        document['date'].toDate().toString())
                                    ? "TODAY"
                                    : "",
                                style: GoogleFonts.arvo(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(
                                width: 0,
                              ),
                            ],
                          ),

                          // appointment date
                          subtitle: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                                _dateFormatter(
                                  document['date'].toDate().toString()),
                              style: GoogleFonts.arvo(
                                color: Color(0xFF002707),
                              ),
                            ),
                          ),

                          // Student info
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 20, right: 10, left: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Student info
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Student name
                                      Text(
                                       "Student name: ${document['StudentName']}",
                                        style: GoogleFonts.arvo(
                                          fontSize: 16,
                                          color: Color(0xFF002707),
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),

                                      Text(
                                        'Description : ${document['description']}',
                                        style: GoogleFonts.arvo(fontSize: 16),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
