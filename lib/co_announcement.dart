import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_attendance/user.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:intl/intl.dart';

import 'login.dart';

class CoAnnouncement extends StatefulWidget {
  const CoAnnouncement({Key? key}) : super(key: key);

  @override
  State<CoAnnouncement> createState() => _CoAnnouncementState();
}

class _CoAnnouncementState extends State<CoAnnouncement> {

  String _month = DateFormat('MMMM').format(DateTime.now());
  String? announcement;
  TextEditingController announcementController = TextEditingController();

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
                  }
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        toolbarHeight: 50,
        leading: Container(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white,), // Icon for the button
            onPressed: () {
              logoutConfirmation();
            },
          ),
        ],
        title: const Text(
          "Announcement",
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
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 8),
                        child: Text(
                          _month,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth / 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(right: 8),
                          child : GestureDetector(
                            onTap: ()async {
                              final month  = await showMonthYearPicker(
                                context : context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2099),
                              );
                              if(month!=null){
                                setState(() {
                                  _month = DateFormat('MMMM').format(month);
                                });
                              }
                            },
                            child: Text(
                              "Pick a month",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth / 60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                      ),
                    ],
                  ),

                  SizedBox(
                    height: screenHeight/1.5,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("Manager")
                          .doc(User.Id).collection("Announcement").snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                        if(snapshot.hasData){
                          final snap = snapshot.data!.docs;

                          snap.sort((a, b) => b['Date'].toDate().compareTo(a['Date'].toDate()));
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snap.length,
                            itemBuilder: (context, index){

                              return DateFormat('MMMM').format(snap[index]['Date'].toDate()) == _month ?
                              SingleChildScrollView(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 80,
                                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange,
                                        blurRadius: 10,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                                        width : 100,
                                        decoration: const BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              snap[index]['shift'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              DateFormat('EE dd').format(snap[index]['Date'].toDate()),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),

                                      Column(
                                        children: [
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Announcement",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                child: Container(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  alignment: Alignment.centerLeft,
                                                  width : screenWidth/1.5,
                                                  height: 50,
                                                  child: Text(
                                                    snap[index]['announcement'],
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: screenWidth/70,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                                onTap: (){
                                                  showDialog(
                                                      context: context,
                                                      builder: (context){
                                                        return AlertDialog(
                                                          title: const Text("Announcement", style: TextStyle(color: Colors.orange)),
                                                          content: Text(
                                                            snap[index]['announcement'],
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                  );
                                                },
                                              ),
                                              const SizedBox(
                                                width: 30,
                                              ),
                                              snap[index]['isChecked'] == false? Padding(
                                                padding: const EdgeInsets.only(top: 20),
                                                child: ElevatedButton(
                                                  onPressed: (){
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                        content: Text("Checked")
                                                    ));
                                                    FirebaseFirestore.instance.collection("Manager")
                                                        .doc(User.Id).collection("Announcement").doc(snap[index].id).update({
                                                      'isChecked' : true,
                                                    });
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                                                  ),
                                                  child: const Text(
                                                      "Check"
                                                  ),
                                                ),
                                              ) : const SizedBox(),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Container(
                                        width: 180,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Announced By",
                                              style: TextStyle(
                                                fontSize: screenWidth/90,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              snap[index]['Announced by'],
                                              style: TextStyle(
                                                fontSize: screenWidth/70,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ): const SizedBox();
                            },
                          );
                        }else{
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
