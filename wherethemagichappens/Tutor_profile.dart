import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SpartySched/Chatbox.dart';
import 'package:SpartySched/BookAppointment.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorProfile extends StatefulWidget {
  String? Tutor = "P";

  TutorProfile({Key? key, this.Tutor}) : super(key: key);
  @override
  State<TutorProfile> createState() => _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfile> {
  // for making phone call
  _launchCaller(String phoneNumber) async {
    String url = "tel:$phoneNumber";
    launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Tutor')
              .orderBy('name')
              .startAt([widget.Tutor]).endAt(
                  ['${widget.Tutor!}\uf8ff']).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  return Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 250,
                          child: Image.asset(
                            'assets/RUBI2.jpg',
                            scale: 1,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Tutor name
                        Text(
                          document['name'] ?? '-',
                          style: GoogleFonts.arvo(
                            fontWeight: FontWeight.w500,
                            fontSize: 36,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        // Tutor category
                        Text(
                          document['category'],
                          style: GoogleFonts.arvo(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black54),
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        // description
                        Container(
                          padding: const EdgeInsets.only(left: 22, right: 22),
                          alignment: Alignment.center,
                          child: Text(
                            document['subjectation'] ?? '-',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.arvo(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 22, right: 22),
                          alignment: Alignment.center,
                          child: Text(
                            document['bio'] ?? '-',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.arvo(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 30),
                              height: 20,
                              child: Text(
                                'First, negotiate a time over chat:',
                                style: GoogleFonts.arvo(
                                  color: Color(0xFF002707),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 30),
                              height: 60,
                              // width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 2,
                                    primary: Color(0xFF002707).withOpacity(0.9),
                                    onPrimary: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatRoom(
                                            user2Id: document['id'] ?? ' ',
                                            user2Name: document['name'] ?? ' ',
                                          ),
                                        ));
                                  },
                                  child: const Icon(Icons
                                      .message_outlined,
                                    color: Colors.white,)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              primary: Color(0xFF002707).withOpacity(0.9),
                              onPrimary: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingScreen(
                                    TutorUid: document['id'],
                                    Tutor: document['name'],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Schedule Meeting!',
                              style: GoogleFonts.arvo(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
