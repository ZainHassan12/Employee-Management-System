import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'leave_model.dart';

class PendingReq extends StatefulWidget {
  const PendingReq({Key? key}) : super(key: key);

  @override
  State<PendingReq> createState() => _PendingReqState();
}

class _PendingReqState extends State<PendingReq> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: Container(),
          backgroundColor: Colors.orange,
          toolbarHeight: 50,
          title: const Text(
            "Leave Requests",
            style: TextStyle(
              fontWeight: FontWeight.bold,
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
                  const SizedBox(
                    height: 10,
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
                    height: screenHeight/1.5,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('Sales & Support').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(color: Colors.orange,);
                        }

                        // Data is ready
                        return ListView(
                          children: snapshot.data!.docs.map((DocumentSnapshot empDocument) {
                            var name = empDocument.get('name');
                            var id = empDocument.get('id');
                            var shift = empDocument.get('shift');

                            return StreamBuilder<QuerySnapshot>(
                              stream: empDocument.reference.collection('leaveRequests').where('Status', isEqualTo: 'Pending').snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> leaveSnapshot) {

                                if (leaveSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Text('Loading...');
                                }

                                var leave = leaveSnapshot.data!.docs;
                                return Column(
                                  children: leave.map((DocumentSnapshot leaveDoc) {
                                    return SingleChildScrollView(
                                      child: Container(
                                        height: 100,
                                        margin: const EdgeInsets.only(top: 15, bottom: 20, right: 80, left: 80),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.orange,
                                              blurRadius: 10,
                                              offset: Offset(2, 2),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(top: 25, bottom: 15),
                                              width : 100,
                                              decoration: const BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
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
                                                            title: const Text("Reason"),
                                                            content: Text(
                                                                leaveDoc['Reason']
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
                                              width: 100,
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 15, right: 5, left: 5),
                                                    child: ElevatedButton(
                                                        onPressed: (){
                                                          FirebaseFirestore.instance
                                                              .collection('Sales & Support')
                                                              .doc(empDocument.id)
                                                              .collection('leaveRequests')
                                                              .doc(leaveDoc.id)
                                                              .update({
                                                            'Status': 'Approved',
                                                          });
                                                          LeaveRequest(
                                                            id: leaveDoc.id,
                                                            type: leaveDoc['Leave Type'],
                                                            startDate: leaveDoc['Start Date'],
                                                            endDate: leaveDoc['End Date'],
                                                            reason: leaveDoc['Reason'],
                                                            status: 'Approved',
                                                          );
                                                        },
                                                        child: Text(
                                                          "Approve",
                                                          style: TextStyle(
                                                            fontSize: screenWidth/90,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 15, right: 5, left: 5),
                                                    child: ElevatedButton(
                                                      onPressed: (){
                                                        FirebaseFirestore.instance
                                                            .collection('Sales & Support')
                                                            .doc(empDocument.id)
                                                            .collection('leaveRequests')
                                                            .doc(leaveDoc.id)
                                                            .update({
                                                          'Status': 'Rejected',
                                                        });
                                                        LeaveRequest(
                                                          id: leaveDoc.id,
                                                          type: leaveDoc['Leave Type'],
                                                          startDate: leaveDoc['Start Date'],
                                                          endDate: leaveDoc['End Date'],
                                                          reason: leaveDoc['Reason'],
                                                          status: leaveDoc['Status'],
                                                        );
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red,
                                                      ),
                                                      child: Text(
                                                        'Reject',
                                                        style: TextStyle(
                                                          fontSize: screenWidth/90,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
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
                      "Manager's Leave Requests",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight/35,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: screenHeight/1.5,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('Manager').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(color: Colors.orange,);
                        }

                        // Data is ready
                        return ListView(
                          children: snapshot.data!.docs.map((DocumentSnapshot empDocument) {
                            var name = empDocument.get('name');
                            var id = empDocument.get('id');
                            var shift = empDocument.get('shift');

                            return StreamBuilder<QuerySnapshot>(
                              stream: empDocument.reference.collection('leaveRequests').where('Status', isEqualTo: 'Pending').snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> leaveSnapshot) {

                                if (leaveSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Text('Loading...');
                                }

                                var leave = leaveSnapshot.data!.docs;
                                return Column(
                                  children: leave.map((DocumentSnapshot leaveDoc) {
                                    return SingleChildScrollView(
                                      child: Container(
                                        height: 100,
                                        margin: const EdgeInsets.only(top: 15, bottom: 20, right: 80, left: 80),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.orange,
                                              blurRadius: 10,
                                              offset: Offset(2, 2),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(top: 25, bottom: 15),
                                              width : 100,
                                              decoration: const BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
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
                                              width: 100,
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 15, right: 5, left: 5),
                                                    child: ElevatedButton(
                                                        onPressed: (){
                                                          FirebaseFirestore.instance
                                                              .collection('Manager')
                                                              .doc(empDocument.id)
                                                              .collection('leaveRequests')
                                                              .doc(leaveDoc.id)
                                                              .update({
                                                            'Status': 'Approved',
                                                          });
                                                          LeaveRequest(
                                                            id: leaveDoc.id,
                                                            type: leaveDoc['Leave Type'],
                                                            startDate: leaveDoc['Start Date'],
                                                            endDate: leaveDoc['End Date'],
                                                            reason: leaveDoc['Reason'],
                                                            status: 'Approved',
                                                          );
                                                        },
                                                        child: Text(
                                                          "Approve",
                                                          style: TextStyle(
                                                            fontSize: screenWidth/90,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 15, right: 5, left: 5),
                                                    child: ElevatedButton(
                                                      onPressed: (){
                                                        FirebaseFirestore.instance
                                                            .collection('Manager')
                                                            .doc(empDocument.id)
                                                            .collection('leaveRequests')
                                                            .doc(leaveDoc.id)
                                                            .update({
                                                          'Status': 'Rejected',
                                                        });
                                                        LeaveRequest(
                                                          id: leaveDoc.id,
                                                          type: leaveDoc['Leave Type'],
                                                          startDate: leaveDoc['Start Date'],
                                                          endDate: leaveDoc['End Date'],
                                                          reason: leaveDoc['Reason'],
                                                          status: leaveDoc['Status'],
                                                        );
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red,
                                                      ),
                                                      child: Text(
                                                        'Reject',
                                                        style: TextStyle(
                                                          fontSize: screenWidth/90,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
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
                    height: screenHeight/1.5,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('HR').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(color: Colors.orange,);
                        }

                        // Data is ready
                        return ListView(
                          children: snapshot.data!.docs.map((DocumentSnapshot empDocument) {
                            var name = empDocument.get('name');
                            var id = empDocument.get('id');
                            var shift = empDocument.get('shift');

                            return StreamBuilder<QuerySnapshot>(
                              stream: empDocument.reference.collection('leaveRequests').where('Status', isEqualTo: 'Pending').snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> leaveSnapshot) {

                                if (leaveSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Text('Loading...');
                                }

                                var leave = leaveSnapshot.data!.docs;
                                return Column(
                                  children: leave.map((DocumentSnapshot leaveDoc) {
                                    return SingleChildScrollView(
                                      child: Container(
                                        height: 100,
                                        margin: const EdgeInsets.only(top: 15, bottom: 20, right: 80, left: 80),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.orange,
                                              blurRadius: 10,
                                              offset: Offset(2, 2),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(top: 25, bottom: 15),
                                              width : 100,
                                              decoration: const BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
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
                                              width: 100,
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 15, right: 5, left: 5),
                                                    child: ElevatedButton(
                                                        onPressed: (){
                                                          FirebaseFirestore.instance
                                                              .collection('HR')
                                                              .doc(empDocument.id)
                                                              .collection('leaveRequests')
                                                              .doc(leaveDoc.id)
                                                              .update({
                                                            'Status': 'Approved',
                                                          });
                                                          LeaveRequest(
                                                            id: leaveDoc.id,
                                                            type: leaveDoc['Leave Type'],
                                                            startDate: leaveDoc['Start Date'],
                                                            endDate: leaveDoc['End Date'],
                                                            reason: leaveDoc['Reason'],
                                                            status: 'Approved',
                                                          );
                                                        },
                                                        child: Text(
                                                          "Approve",
                                                          style: TextStyle(
                                                            fontSize: screenWidth/90,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 15, right: 5, left: 5),
                                                    child: ElevatedButton(
                                                      onPressed: (){
                                                        FirebaseFirestore.instance
                                                            .collection('Manager')
                                                            .doc(empDocument.id)
                                                            .collection('leaveRequests')
                                                            .doc(leaveDoc.id)
                                                            .update({
                                                          'Status': 'Rejected',
                                                        });
                                                        LeaveRequest(
                                                          id: leaveDoc.id,
                                                          type: leaveDoc['Leave Type'],
                                                          startDate: leaveDoc['Start Date'],
                                                          endDate: leaveDoc['End Date'],
                                                          reason: leaveDoc['Reason'],
                                                          status: leaveDoc['Status'],
                                                        );
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red,
                                                      ),
                                                      child: Text(
                                                        'Reject',
                                                        style: TextStyle(
                                                          fontSize: screenWidth/90,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        )
    );
  }
}