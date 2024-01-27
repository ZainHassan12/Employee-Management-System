import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_attendance/emp_announcement.dart';
import 'package:e_attendance/emp_resignation.dart';
import 'package:e_attendance/emp_salary_month.dart';
import 'package:flutter/material.dart';
import 'package:e_attendance/user_data.dart';
import 'package:e_attendance/checkIncheckOut.dart';
import 'package:e_attendance/user.dart';
import 'package:e_attendance/activity.dart';
import 'package:e_attendance/empleaveRequest.dart';
import 'package:badges/badges.dart' as badges;
class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int currindex=0;
  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAnnouncement();
  }

  Future<void> fetchAnnouncement() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Sales & Support')
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
        bottomNavigationBar : BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.orange,
          currentIndex: currindex,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.check_box,  size: 30, color: Colors.black54,),
              label: 'Attendance',
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.timer,  size: 30, color: Colors.black54,),
              label: 'Activity',
            ),

            BottomNavigationBarItem(
              icon: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset('assets/leave.png', width: 25, height: 25, color: Colors.black38, colorBlendMode: BlendMode.saturation,)),
              label: 'Leave Request',
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
                  Icons.notifications_active,
                  size: 30,
                  color: Colors.black54,
                ),
              ),
              label: 'Announcements',
            ),

            BottomNavigationBarItem(
              icon: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset('assets/resign.png', width: 25, height: 25, color: Colors.black38, colorBlendMode: BlendMode.saturation,)),
              label: 'Resignation',
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.request_page,  size: 30, color: Colors.black54,),
              label: 'Salary',
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.account_box,  size: 30, color: Colors.black54,),
              label: 'Profile',
            ),
          ],
          onTap: (index){
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

  Widget selectedwidget({required int index}){
    Widget widget;
    switch(index){
      case 0:
        if(User.timer != 0){
          widget = const ActivityTimer();
        }else{
          widget = const CheckInCheckOut();
        }
        break;

      case 1:
        if(User.timer != 0){
          widget = const ActivityTimer();
        }else {
          widget = const ActivityTimer();
        }
        break;

      case 2:
        if(User.timer != 0){
          widget = const ActivityTimer();
        }else {
          widget = const LeaveRequestForm();
        }
        break;

      case 3:
        if(User.timer != 0){
          widget = const ActivityTimer();
        }else {
          widget = const EmpAnnouncement();
        }
        break;

      case 4:
        if(User.timer != 0){
          widget = const ActivityTimer();
        }else {
          widget = const Emp_Resignation();
        }
        break;

      case 5:
        if(User.timer != 0){
          widget = const ActivityTimer();
        }else {
          widget = const EmpSalaryMonth();
        }
        break;

      case 6:
        if(User.timer != 0){
          widget = const ActivityTimer();
        }else {
          widget = const UserData();
        }
        break;

      default:
        if(User.timer != 0){
          widget = const ActivityTimer();
        }else {
          widget = const CheckInCheckOut();
        }
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