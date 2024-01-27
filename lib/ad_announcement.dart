import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_attendance/user.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:intl/intl.dart';

class Announcement extends StatefulWidget {
  const Announcement({Key? key}) : super(key: key);

  @override
  State<Announcement> createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {

  String _month = DateFormat('MMMM').format(DateTime.now());
  String announcement= "";
  TextEditingController announcementController = TextEditingController();

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
          "Announcement",
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
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Announcement",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: announcementController,
                      onChanged: (value){
                        announcement = value;
                      },
                      maxLines: 10,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Enter Announcement',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () async {
                      if(announcement == ""){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Please Enter an Announcement")
                        ));
                      }else{
                        final QuerySnapshot employeeDocs = await FirebaseFirestore.instance
                            .collection("Sales & Support").where('shift', isEqualTo: 'UK').get();

                        for (final doc in employeeDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          // Add data to the subcollection document as needed
                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "UK",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        final QuerySnapshot coDocs = await FirebaseFirestore.instance
                            .collection("Manager").where('shift', isEqualTo: 'UK').get();

                        for (final doc in coDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          // Add data to the subcollection document as needed
                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "UK",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        final QuerySnapshot adDocs = await FirebaseFirestore.instance
                            .collection("Director").get();

                        for (final doc in adDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "UK",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        final QuerySnapshot hrDocs = await FirebaseFirestore.instance
                            .collection("HR").get();

                        for (final doc in hrDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "UK",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Announcement Sent")
                        ));
                        setState(() {
                          announcement = "";
                          announcementController.clear();
                        });
                      }
                    },
                    child: const Text(
                      'Send to UK',
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () async {
                      if(announcement == ""){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Please Enter an Announcement")
                        ));
                      }else{
                        final QuerySnapshot employeeDocs = await FirebaseFirestore.instance
                            .collection("Sales & Support").where('shift', isEqualTo: 'USA').get();

                        for (final doc in employeeDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          // Add data to the subcollection document as needed
                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "USA",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        final QuerySnapshot coDocs = await FirebaseFirestore.instance
                            .collection("Manager").where('shift', isEqualTo: 'USA').get();

                        for (final doc in coDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          // Add data to the subcollection document as needed
                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "USA",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        final QuerySnapshot adDocs = await FirebaseFirestore.instance
                            .collection("Director").get();

                        for (final doc in adDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "USA",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        final QuerySnapshot hrDocs = await FirebaseFirestore.instance
                            .collection("HR").get();

                        for (final doc in hrDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "USA",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Announcement Sent")
                        ));
                        setState(() {
                          announcement = "";
                          announcementController.clear();
                        });
                      }
                    },
                    child: const Text(
                      'Send to USA',
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () async {
                      if(announcement == ""){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Please Enter an Announcement")
                        ));
                      }else{
                        final QuerySnapshot employeeDocs = await FirebaseFirestore.instance
                            .collection("Sales & Support").where('shift', isEqualTo: 'IT').get();

                        for (final doc in employeeDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          // Add data to the subcollection document as needed
                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "IT",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        final QuerySnapshot coDocs = await FirebaseFirestore.instance
                            .collection("Manager").where('shift', isEqualTo: 'IT').get();

                        for (final doc in coDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          // Add data to the subcollection document as needed
                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "IT",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        final QuerySnapshot adDocs = await FirebaseFirestore.instance
                            .collection("Director").get();

                        for (final doc in adDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "IT",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        final QuerySnapshot hrDocs = await FirebaseFirestore.instance
                            .collection("HR").get();

                        for (final doc in hrDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "IT",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Announcement Sent")
                        ));
                        setState(() {
                          announcement = "";
                          announcementController.clear();
                        });
                      }
                    },
                    child: const Text(
                      'Send to IT',
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),

                  const SizedBox(height: 15,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () async {
                      if(announcement == ""){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Please Enter an Announcement")
                        ));
                      }else{
                        final QuerySnapshot employeeDocs = await FirebaseFirestore.instance
                            .collection("Sales & Support").get();

                        for (final doc in employeeDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          // Add data to the subcollection document as needed
                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "All",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        final QuerySnapshot coDocs = await FirebaseFirestore.instance
                            .collection("Manager").get();

                        for (final doc in coDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "All",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        final QuerySnapshot adDocs = await FirebaseFirestore.instance
                            .collection("Director").get();

                        for (final doc in adDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "All",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        final QuerySnapshot hrDocs = await FirebaseFirestore.instance
                            .collection("HR").get();

                        for (final doc in hrDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Announcement")
                              .doc();

                          await subcollectionReference.set({
                            'announcement' : announcement,
                            'Date' : Timestamp.now(),
                            'shift' : "All",
                            "Announced by" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Announcement Sent")
                        ));
                        setState(() {
                          announcement = "";
                          announcementController.clear();
                        });
                      }
                    },
                    child: const Text(
                      'Send to All',
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                      stream: FirebaseFirestore.instance.collection("Director")
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
                                                color: Colors.orange,
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
                                                          title: const Text("Announcement", style: TextStyle(color: Colors.orange),),
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
                                                    FirebaseFirestore.instance.collection("Director")
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
