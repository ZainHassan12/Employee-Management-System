import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_attendance/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'login.dart';

class Emp_Resignation extends StatefulWidget {
  const Emp_Resignation({Key? key}) : super(key: key);

  @override
  State<Emp_Resignation> createState() => _Emp_ResignationState();
}

class _Emp_ResignationState extends State<Emp_Resignation> {

  String resignLetter = "";
  TextEditingController letterController = TextEditingController();

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
          "Resignation",
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
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Enter Your Resignation Application",
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
                      controller: letterController,
                      onChanged: (value){
                        resignLetter = value;
                      },
                      maxLines: 20,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Enter Application',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: ()async{
                      if(resignLetter == ""){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Please Enter Application")
                        ));
                      }else{
                        final QuerySnapshot employeeDocs = await FirebaseFirestore.instance
                            .collection("Sales & Support").where('id', isEqualTo: User.username).get();

                        for (final doc in employeeDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Resignation")
                              .doc();

                          await subcollectionReference.set({
                            'Resignation' : resignLetter,
                            'Date' : Timestamp.now(),
                          });
                        }

                        final QuerySnapshot adDocs = await FirebaseFirestore.instance
                            .collection("Director").get();

                        for (final doc in adDocs.docs) {
                          final DocumentReference subcollectionReference = doc.reference.collection(
                              "Resignation")
                              .doc();

                          await subcollectionReference.set({
                            'Resignation' : resignLetter,
                            'Date' : Timestamp.now(),
                            'shift' : User.Shift,
                            "name" : User.Name,
                            "isChecked" : false,
                          });
                        }
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Resignation Application Sent! ")
                        ));
                        setState(() {
                          resignLetter = "";
                          letterController.clear();
                        });
                      }
                    },
                    child: const Text(
                      'Send',
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  SizedBox(
                    height: screenHeight/1.5,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("Sales & Support")
                          .doc(User.Id).collection("Resignation").snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                        if(snapshot.hasData){
                          final snap = snapshot.data!.docs;

                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snap.length,
                            itemBuilder: (context, index){

                             return SingleChildScrollView(
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
                                        width : 130,
                                        height: 80,
                                        decoration: const BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            DateFormat('dd MMMM yyyy').format(snap[index]['Date'].toDate()),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
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
                                              "Application",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            child: Container(
                                              padding: const EdgeInsets.only(top: 10),
                                              alignment: Alignment.centerLeft,
                                              width: screenWidth/1.15,
                                              height: 50,
                                              child: Text(
                                                snap[index]['Resignation'],
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
                                                      title: const Text("Resignation Application", style: TextStyle(color: Colors.orange),),
                                                      content: Text(
                                                        snap[index]['Resignation'],
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
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
