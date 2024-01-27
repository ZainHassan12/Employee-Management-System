import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_attendance/ad_resign.dart';
import 'package:e_attendance/addEmp.dart';
import 'package:e_attendance/ad_announcement.dart';
import 'package:e_attendance/add_hr.dart';
import 'package:e_attendance/pendingReqs.dart';
import 'package:flutter/material.dart';
import 'all_requests.dart';
import 'emp_info_ad.dart';
import 'hrinfo.dart';
import 'user.dart';
import 'cordInfo.dart';
import 'package:e_attendance/addCoordinator.dart';
import 'package:e_attendance/login.dart';
import 'package:badges/badges.dart' as badges;

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  int count= 0;
  int Count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAnnouncement();
    fetchResign();
  }

  void logoutConfirmation(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text('Logout Confirmation'),
            content: const Text('Are you sure you want to log out?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No', style: TextStyle(color: Colors.orange),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                    'Yes',
                  style: TextStyle(
                    color: Colors.orange
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyLogin()));
                },
              ),
            ],
          );
        }
    );
  }

  Future<int> fetchPendingRequests() async {
    final managerSnapshot = await FirebaseFirestore.instance.collection('Manager').get();

    final List<Future<int>> pendingRequestsFutures = [];

    for (var empDocument in managerSnapshot.docs) {
      final leaveSnapshot = await empDocument
          .reference
          .collection('leaveRequests')
          .where('Status', isEqualTo: 'Pending')
          .get();

      final managerPendingRequests = leaveSnapshot.docs.length;
      pendingRequestsFutures.add(Future.value(managerPendingRequests));
    }

    final employeeSnapshot = await FirebaseFirestore.instance.collection('Sales & Support').get();

    for (var empDocument in employeeSnapshot.docs) {
      final leaveSnapshot = await empDocument
          .reference
          .collection('leaveRequests')
          .where('Status', isEqualTo: 'Pending')
          .get();

      final employeePendingRequests = leaveSnapshot.docs.length;
      pendingRequestsFutures.add(Future.value(employeePendingRequests));
    }

    final hrSnapshot = await FirebaseFirestore.instance.collection('HR').get();

    for (var hrDocument in hrSnapshot.docs) {
      final leaveSnapshot = await hrDocument
          .reference
          .collection('leaveRequests')
          .where('Status', isEqualTo: 'Pending')
          .get();

      final hrPendingRequests = leaveSnapshot.docs.length;
      pendingRequestsFutures.add(Future.value(hrPendingRequests));
    }

    final results = await Future.wait(pendingRequestsFutures);

    int totalPendingRequests = 0;
    for (var count in results) {
      totalPendingRequests += count;
    }

    return totalPendingRequests;
  }


  Future<void> fetchAnnouncement() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Director')
        .doc(User.Id)
        .collection('Announcement')
        .where('isChecked', isEqualTo: false)
        .get();

    setState(() {
      count = querySnapshot.docs.length;
    });
  }

  Future<void> fetchResign() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Director')
        .doc(User.Id)
        .collection('Resignation')
        .where('isChecked', isEqualTo: false)
        .get();

    setState(() {
      Count = querySnapshot.docs.length;
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        bool? confirm = await showConfirmationDialog(context) ?? false;
        return confirm;
      },
      child: Scaffold(

        backgroundColor: Colors.black,

        appBar: AppBar(
          backgroundColor: Colors.orange,
          toolbarHeight: 50,
          leading: Container(),
          title: const Text(
            "Dashboard",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        body: Stack(
          children: [
            Image.asset(
              'assets/background5.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Column(
                            children: [
                              Text(
                                "Welcome",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: screenWidth/60,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                "${User.Name} - ${User.username}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth / 60,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.exit_to_app, color: Colors.white,), // Icon to display
                            onPressed: () {
                              logoutConfirmation();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight/9,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const CoordinatorInfo()));
                      },
                      child: const Text(
                        'Managers',
                        style: TextStyle(
                            fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight/30,
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const EmpInfoAd()));
                      },
                      child: const Text(
                        'Sales & Support',
                        style: TextStyle(
                            fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight/30,
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const HrInfo()));
                      },
                      child: const Text(
                        'HR',
                        style: TextStyle(
                            fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight/30,
                    ),

                    FutureBuilder<int>(
                      future: fetchPendingRequests(),
                      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(color: Colors.orange,);
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        int totalPendingRequests = snapshot.data ?? 0;

                        return badges.Badge(
                          badgeContent: Text(totalPendingRequests.toString(), style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),),
                          badgeStyle: const badges.BadgeStyle(
                            badgeColor: Colors.white,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PendingReq()),
                              );
                            },
                            child: const Text(
                              'Pending Leave Requests',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(
                      height: screenHeight/30,
                    ),

                    badges.Badge(
                      badgeContent: Text(count.toString(), style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),),
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: Colors.white,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const Announcement()));
                        },
                        child: const Text(
                          'Announcements',
                          style: TextStyle(
                              fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight/30,
                    ),

                    badges.Badge(
                      badgeContent: Text(Count.toString(), style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),),
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: Colors.white,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdResign()));
                        },
                        child: const Text(
                          'Resignation',
                          style: TextStyle(
                              fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: screenHeight/30,
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const AllRequests()));
                      },
                      child: const Text(
                        "Leave Requests",
                        style: TextStyle(
                            fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: screenHeight/30,
                    ),


                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Add_Coordinator()));
                      },
                      child: const Text(
                        'Add a Manager',
                        style: TextStyle(
                            fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight/30,
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Add_HR()));
                      },
                      child: const Text(
                        'Add HR',
                        style: TextStyle(
                            fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight/30,
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Add_Employee()));
                      },
                      child: const Text(
                        'Add an Employee',
                        style: TextStyle(
                            fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
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