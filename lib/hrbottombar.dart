import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_attendance/HM_data.dart';
import 'package:e_attendance/HrAttendance.dart';
import 'package:e_attendance/cordInfo.dart';
import 'package:e_attendance/hr_leave.dart';
import 'package:e_attendance/hr_salary.dart';
import 'package:e_attendance/user.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart'as badges;

import 'empInfo_hr.dart';
import 'hr_announcement.dart';

class HrBottomBar extends StatefulWidget {
  const HrBottomBar({Key? key}) : super(key: key);

  @override
  State<HrBottomBar> createState() => _HrBottomBarState();
}

class _HrBottomBarState extends State<HrBottomBar> {
  int currindex = 0;
  int count = 0;
  int pendingReqs = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAnnouncement();
  }

  Future<void> fetchAnnouncement() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('HR')
        .doc(User.Id)
        .collection('Announcement')
        .where('isChecked', isEqualTo: false)
        .get();

    setState(() {
      count = querySnapshot.docs.length;
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? confirm = await showConfirmationDialog(context) ?? false;
        return confirm;
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.orange,
          currentIndex: currindex,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.check,
                size: 30,
                color: Colors.black54,
              ),
              label: 'Attendance',
            ),

            BottomNavigationBarItem(
              icon: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset('assets/leave.png', width: 25, height: 25, color: Colors.black38, colorBlendMode: BlendMode.saturation,)),
              label: 'Leave Request',
            ),

            const BottomNavigationBarItem(
              icon: Icon(
                Icons.request_page,
                size: 30,
                color: Colors.black54,
              ),
              label: 'Salary',
            ),

            const BottomNavigationBarItem(
              icon: Icon(
                Icons.group,
                size: 30,
                color: Colors.black54,
              ),
              label: 'Sales & Support',
            ),


            BottomNavigationBarItem(
              icon: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset('assets/manager.png', width: 30, height: 30, color: Colors.black54)),
              label: 'Managers',
            ),

            BottomNavigationBarItem(
              icon: badges.Badge(
                position: badges.BadgePosition.topEnd(top: -8, end: -8),
                badgeContent:
                Text(
                  count.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.orange,
                ),
                child: const Icon(
                  Icons.notifications,
                  size: 30,
                  color: Colors.black54,
                ),
              ),
              label: 'Announcements',
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.account_box,
                size: 30,
                color: Colors.black54,
              ),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            setState(() {
              currindex = index;
            });
          },
        ),

        body: Container(
          child: selectedwidget(index: currindex),
        ),
      ),
    );
  }

  Widget selectedwidget({required int index}) {
    Widget widget;
    switch (index) {
      case 0:
        widget = const HrCheckInCheckOut();
        break;

      case 1:
        widget = const HrRequest();
        break;

      case 2:
        widget = const HrSalary();
        break;


      case 3:
        widget = const HrEmpInfo();
        break;

      case 4:
        widget = const CoordinatorInfo();
        break;

      case 5:
        widget = const HrAnnouncement();
        break;

      case 6:
        widget = const HM_Data();
        break;

      default:
        widget = const HrCheckInCheckOut();
        break;
    }
    return widget;
  }
  Future<bool?> showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Action'),
          content: const Text('Do you want to leave this page?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.orange),),
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled the action.
              },
            ),
            TextButton(
              child: const Text('Confirm', style: TextStyle(color: Colors.orange),),
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed the action.
              },
            ),
          ],
        );
      },
    );
  }
}
