import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'ListOfAppointments.dart';

class BookingScreen extends StatefulWidget {
  final String Tutor;
  final String TutorUid;

  const BookingScreen({Key? key, required this.Tutor, required this.TutorUid})
      : super(key: key);
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _TutorController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String timeText = 'Select Time';
  late String dateUTC;
  late String dateTime;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;

  Future<void> _getUser() async {
    user = _auth.currentUser!;
  }

  // function for selecting appointment date
  Future<void> selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    ).then(
      (date) {
        setState(
          () {
            selectedDate = date!;
            String formattedDate =
                DateFormat('dd-MM-yyyy').format(selectedDate);
            _dateController.text = formattedDate;
            dateUTC = DateFormat('yyyy-MM-dd').format(selectedDate);
          },
        );
      },
    );
  }
  showAlertDialog(BuildContext context) {
    // OK button
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: GoogleFonts.arvo(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            // view all pending appointments
            builder: (context) => const AppointmentList(),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "OK",
        style: GoogleFonts.arvo(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Appointment is in!",
        style: GoogleFonts.arvo(),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // for showing appointment booked


  @override
  void initState() {
    super.initState();
    _getUser();
    _TutorController.text = widget.Tutor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 10,
              ),
              // form
              Form(
                key: _formKey,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      // enter Student details
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Enter Student Details',
                          style: GoogleFonts.arvo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      // Student Name
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Student Name';
                          }
                          return null;
                        },
                        style: GoogleFonts.arvo(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 10),
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[350],
                          hintText: 'Student Name*',
                          hintStyle: GoogleFonts.arvo(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onFieldSubmitted: (String value) {
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // disease description
                      TextFormField(
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: GoogleFonts.arvo(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 10),
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[350],
                          hintText: 'Enter the subject, time, and additional details to remind your tutor of your needs',
                          hintStyle: GoogleFonts.arvo(
                            color: Colors.black26,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onFieldSubmitted: (String value) {
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Doctor name
                      TextFormField(
                        readOnly: true,
                        controller: _TutorController,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter Tutor name';
                          return null;
                        },
                        style: GoogleFonts.arvo(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 10),
                          border: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[350],
                          hintText: 'Tutor Name',
                          hintStyle: GoogleFonts.arvo(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextFormField(
                              onTap: () {
                                selectDate(context);
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                  left: 20,
                                  top: 10,
                                  bottom: 10,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(90.0)),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[350],
                                hintText: 'Select Date*',
                                hintStyle: GoogleFonts.arvo(
                                  color: Colors.black26,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              controller: _dateController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter the Date';
                                }
                                return null;
                              },
                              onFieldSubmitted: (String value) {
                              },
                              textInputAction: TextInputAction.next,
                              style: GoogleFonts.arvo(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: ClipOval(
                                child: Material(
                                  color: Color(0xFF002707), // button color
                                  child: InkWell(
                                    // inkwell color
                                    child: const SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                        Icons.date_range_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      selectDate(context);
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            primary: Color(0xFF002707),
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print(_nameController.text);
                              print(_dateController.text);
                              print(widget.Tutor);
                              showAlertDialog(context);
                              _createAppointment();
                            }
                          },
                          child: Text(
                            "Book Appointment",
                            style: GoogleFonts.arvo(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createAppointment() async {
    // print(dateUTC + ' ' + date_Time + ':00');
    String appointId = '${user.uid}${widget.TutorUid}$dateUTC}';
    print('${widget.TutorUid}.');
    print('${user.uid}.');

    var details = {
      'StudentName': _nameController.text,
      'TutorName': _TutorController.text,
      'description': _descriptionController.text,
      'date': DateTime.parse('$dateUTC'),
      'StudentId': user.uid,
      'TutorId': widget.TutorUid,
      //help in cancelling appointment
      'appointmentID': appointId,
    };

    FirebaseFirestore.instance
        .collection('appointments')
        .doc(user.uid)
        .collection('pending')
        .doc(appointId)
        .set(details, SetOptions(merge: true));

    FirebaseFirestore.instance
        .collection('appointments')
        .doc(user.uid)
        .collection('all')
        .doc(appointId)
        .set(details, SetOptions(merge: true));

    // add to Tutor data
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(widget.TutorUid)
        .collection('pending')
        .doc(appointId)
        .set(details, SetOptions(merge: true));

    FirebaseFirestore.instance
        .collection('appointments')
        .doc(widget.TutorUid)
        .collection('all')
        .doc(appointId)
        .set(details, SetOptions(merge: true));
  }
}
