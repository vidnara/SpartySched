import 'package:SpartySched/ListOfAppointments.dart';
import 'package:SpartySched/setting.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:SpartySched/chats.dart';
import 'package:SpartySched/myprof.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class MainPageTutor extends StatefulWidget {
  const MainPageTutor({Key? key}) : super(key: key);

  @override
  State<MainPageTutor> createState() => _MainPageTutorState();
}

class _MainPageTutorState extends State<MainPageTutor> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 2;
  final List<Widget> _pages = [
    const Chats(),
    const AppointmentList(),
    UserSettings(label: '', field: '', value: '',),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: GNav(
                curve: Curves.easeOutExpo,
                rippleColor: Colors.grey.shade300,
                hoverColor: Colors.grey.shade100,
                haptic: true,
                tabBorderRadius: 20,
                gap: 5,
                activeColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 200),
                tabBackgroundColor: Color(0xFF002707).withOpacity(1),
                textStyle: GoogleFonts.arvo(
                  color: Colors.white,
                ),
                iconSize: 30,
                tabs: const [
                  GButton(
                    icon: Icons.chat_outlined /* Typicons.group_outline */,
                    text: 'Chats',
                  ),
                  GButton(
                    icon: Typicons.calendar,
                    text: 'All Appointments',
                  ),
                  GButton(
                    icon: Typicons.user,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: _onItemTapped,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
