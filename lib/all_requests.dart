import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class AllRequests extends StatefulWidget {
  const AllRequests({Key? key}) : super(key: key);

  @override
  State<AllRequests> createState() => _AllRequestsState();
}

class _AllRequestsState extends State<AllRequests> {

  String _month = DateFormat('MMMM').format(DateTime.now());
  Timestamp date = Timestamp.now();

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
        title: const Text(
          "Leave Requests",
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
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 8, top: 15),
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
                      margin: const EdgeInsets.only(right: 8, top: 15),
                      child : GestureDetector(
                        onTap: () async {
                          final month  = await showMonthYearPicker(
                            context : context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2099),
                          );
                          if(month != null) {
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
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Manager's Leave Requests",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight/35,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight / 1.5,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('Manager').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading...');
                      }


                      return ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot empDocument) {
                          var name = empDocument.get('name');
                          var id = empDocument.get('id');
                          var shift = empDocument.get('shift');

                          return StreamBuilder<QuerySnapshot>(
                            stream: empDocument.reference.collection('leaveRequests').snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> leaveSnapshot) {

                              if (leaveSnapshot.connectionState == ConnectionState.waiting) {
                                return const Text('Loading...');
                              }

                              // Data is ready
                              var leave = leaveSnapshot.data!.docs;
                              return Column(
                                children: leave.map((DocumentSnapshot leaveDoc) {

                                  Color mycol;

                                  if(leaveDoc['Status'] == 'Approved') {
                                    mycol = Colors.green;
                                  } else if(leaveDoc['Status'] == 'Rejected'){
                                    mycol = Colors.red;
                                  } else {
                                    mycol = Colors.orange;
                                  }

                                  return DateFormat('MMMM').format(leaveDoc['Date'].toDate()) == _month ? SingleChildScrollView(
                                    child: Container(
                                      height: 100,
                                      margin: const EdgeInsets.only(top: 15, bottom: 20, right: 80, left: 80),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: mycol,
                                            blurRadius: 10,
                                            offset: const Offset(2, 2),
                                          ),
                                        ],
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(top: 25, bottom: 15),
                                            width : 100,
                                            decoration: BoxDecoration(
                                              color: mycol,
                                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  leaveDoc['Leave Type'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  DateFormat('EE dd').format(leaveDoc['Date'].toDate()),
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
                                            width: 20,
                                          ),

                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(top : 5),
                                                width : screenWidth/1.5,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "$name - $id - $shift",
                                                  style: TextStyle(
                                                    fontSize: screenWidth/90,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                child: Container(
                                                  padding: const EdgeInsets.only(top: 5),
                                                  alignment: Alignment.centerLeft,
                                                  width : screenWidth/1.5,
                                                  child: Expanded(
                                                    child: Text(
                                                      leaveDoc['Reason'],
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: screenWidth/80,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                onTap: (){
                                                  showDialog(
                                                      context: context,
                                                      builder: (context){
                                                        return AlertDialog(
                                                          title: const Text("Reason", style: TextStyle(color: Colors.orange)),
                                                          content: Text(
                                                            leaveDoc['Reason'],
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                  );
                                                },
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding: const EdgeInsets.only(bottom: 8),
                                                width : screenWidth/1.5,
                                                child: Text(
                                                  '${leaveDoc['Start Date']} - ${leaveDoc['End Date']}',
                                                  style: TextStyle(
                                                    fontSize: screenWidth/100,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Container(
                                            width: 140,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: mycol,
                                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Status",
                                                  style: TextStyle(
                                                    fontSize: screenWidth/90,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  leaveDoc['Status'],
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
                                  ) : const SizedBox();
                                }).toList(),
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Sales & Support's Leave Requests",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight/35,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight / 1.5,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('Sales & Support').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading...');
                      }

                      return ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot empDocument) {
                          var name = empDocument.get('name');
                          var id = empDocument.get('id');
                          var shift = empDocument.get('shift');

                          return StreamBuilder<QuerySnapshot>(
                            stream: empDocument.reference.collection('leaveRequests').snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> leaveSnapshot) {

                              if (leaveSnapshot.connectionState == ConnectionState.waiting) {
                                return const Text('Loading...');
                              }

                              // Data is ready
                              var leave = leaveSnapshot.data!.docs;
                              return Column(
                                children: leave.map((DocumentSnapshot leaveDoc) {

                                  Color mycol;

                                  if(leaveDoc['Status'] == 'Approved') {
                                    mycol = Colors.green;
                                  } else if(leaveDoc['Status'] == 'Rejected'){
                                    mycol = Colors.red;
                                  } else {
                                    mycol = Colors.orange;
                                  }

                                  return DateFormat('MMMM').format(leaveDoc['Date'].toDate()) == _month ? SingleChildScrollView(
                                    child: Container(
                                      height: 100,
                                      margin: const EdgeInsets.only(top: 15, bottom: 20, right: 80, left: 80),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: mycol,
                                            blurRadius: 10,
                                            offset: const Offset(2, 2),
                                          ),
                                        ],
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(top: 25, bottom: 15),
                                            width : 100,
                                            decoration: BoxDecoration(
                                              color: mycol,
                                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  leaveDoc['Leave Type'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  DateFormat('EE dd').format(leaveDoc['Date'].toDate()),
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
                                            width: 20,
                                          ),

                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(top : 5),
                                                width : screenWidth/1.5,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "$name - $id - $shift",
                                                  style: TextStyle(
                                                    fontSize: screenWidth/90,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                child: Container(
                                                  padding: const EdgeInsets.only(top: 5),
                                                  alignment: Alignment.centerLeft,
                                                  width : screenWidth/1.5,
                                                  child: Expanded(
                                                    child: Text(
                                                      leaveDoc['Reason'],
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: screenWidth/80,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                onTap: (){
                                                  showDialog(
                                                      context: context,
                                                      builder: (context){
                                                        return AlertDialog(
                                                          title: const Text("Reason", style: TextStyle(color: Colors.orange)),
                                                          content: Text(
                                                            leaveDoc['Reason'],
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                  );
                                                },
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding: const EdgeInsets.only(bottom: 8),
                                                width : screenWidth/1.5,
                                                child: Text(
                                                  '${leaveDoc['Start Date']} - ${leaveDoc['End Date']}',
                                                  style: TextStyle(
                                                    fontSize: screenWidth/100,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Container(
                                            width: 140,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: mycol,
                                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Status",
                                                  style: TextStyle(
                                                    fontSize: screenWidth/90,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  leaveDoc['Status'],
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
                                  ) : const SizedBox();
                                }).toList(),
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    "HR's Leave Requests",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight/35,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight / 1.5,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('HR').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading...');
                      }

                      return ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot empDocument) {
                          var name = empDocument.get('name');
                          var id = empDocument.get('id');
                          var shift = empDocument.get('shift');

                          return StreamBuilder<QuerySnapshot>(
                            stream: empDocument.reference.collection('leaveRequests').snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> leaveSnapshot) {

                              if (leaveSnapshot.connectionState == ConnectionState.waiting) {
                                return const Text('Loading...');
                              }

                              // Data is ready
                              var leave = leaveSnapshot.data!.docs;
                              return Column(
                                children: leave.map((DocumentSnapshot leaveDoc) {

                                  Color mycol;

                                  if(leaveDoc['Status'] == 'Approved') {
                                    mycol = Colors.green;
                                  } else if(leaveDoc['Status'] == 'Rejected'){
                                    mycol = Colors.red;
                                  } else {
                                    mycol = Colors.orange;
                                  }

                                  return DateFormat('MMMM').format(leaveDoc['Date'].toDate()) == _month ? SingleChildScrollView(
                                    child: Container(
                                      height: 100,
                                      margin: const EdgeInsets.only(top: 15, bottom: 20, right: 80, left: 80),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: mycol,
                                            blurRadius: 10,
                                            offset: const Offset(2, 2),
                                          ),
                                        ],
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(top: 25, bottom: 15),
                                            width : 100,
                                            decoration: BoxDecoration(
                                              color: mycol,
                                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  leaveDoc['Leave Type'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  DateFormat('EE dd').format(leaveDoc['Date'].toDate()),
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
                                            width: 20,
                                          ),

                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(top : 5),
                                                width : screenWidth/1.5,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "$name - $id - $shift",
                                                  style: TextStyle(
                                                    fontSize: screenWidth/90,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                child: Container(
                                                  padding: const EdgeInsets.only(top: 5),
                                                  alignment: Alignment.centerLeft,
                                                  width : screenWidth/1.5,
                                                  child: Expanded(
                                                    child: Text(
                                                      leaveDoc['Reason'],
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: screenWidth/80,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                onTap: (){
                                                  showDialog(
                                                      context: context,
                                                      builder: (context){
                                                        return AlertDialog(
                                                          title: const Text("Reason", style: TextStyle(color: Colors.orange)),
                                                          content: Text(
                                                            leaveDoc['Reason'],
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                  );
                                                },
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding: const EdgeInsets.only(bottom: 8),
                                                width : screenWidth/1.5,
                                                child: Text(
                                                  '${leaveDoc['Start Date']} - ${leaveDoc['End Date']}',
                                                  style: TextStyle(
                                                    fontSize: screenWidth/100,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Container(
                                            width: 140,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: mycol,
                                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Status",
                                                  style: TextStyle(
                                                    fontSize: screenWidth/90,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  leaveDoc['Status'],
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
                                  ) : const SizedBox();
                                }).toList(),
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}