import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'user.dart';
import 'package:intl/intl.dart';

class Attendance extends StatefulWidget {
  final User user;
  const Attendance({super.key, required this.user});

  @override
  State<Attendance> createState() => _Attendance();
}

class _Attendance extends State<Attendance> {
  String date = DateFormat('MMMM').format(DateTime.now());
  String? id;
  int count = 0;
  @override
  void initState() {
    super.initState();
    getDocumentId();
    getCount();
  }

  Future<void> getDocumentId() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(widget.user.Designation)
        .where('id', isEqualTo: widget.user.id)
        .get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      setState(() {
        id = documentSnapshot.id;
      });
    }
  }

  void getCount() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection(widget.user.Designation)
          .where('id', isEqualTo: widget.user.id)
          .get();

      QuerySnapshot snap2 = await FirebaseFirestore.instance
          .collection(widget.user.Designation).doc(snap.docs[0].id)
          .collection('Record').get();

      int presentDays = 0;

      snap2.docs.forEach((document) {
        DateTime documentDate = document['date'].toDate();
        if (DateFormat('MMMM').format(documentDate) == date) {
          presentDays++;
        }
      });

      setState(() {
        count = presentDays;
      });

    } catch (e) {
      setState(() {
        count = 0;
      });
    }
  }

  void updateMonth(DateTime selectedMonth) {
    setState(() {
      date = DateFormat('MMMM').format(selectedMonth);
    });
    getCount();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.orange,
        toolbarHeight: 50,
        title: const Text('Attendance',
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
                  height: 20,
                ),

                Center(
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.orange
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      Text('Name: ${widget.user.name}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),),
                      const SizedBox(height: 15),
                      Text('Employee Id: ${widget.user.id}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),),
                      const SizedBox(height: 15),
                      Text('Shift: ${widget.user.shift}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 8),
                      child: Text(
                        date,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth / 50,
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
                              updateMonth(month);
                            });
                          }
                        },
                        child: Text(
                          "Pick a month",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth / 50,
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

                SizedBox(
                  height: screenHeight/1.5,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection(widget.user.Designation)
                        .doc(id).collection("Record").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(color: Colors.orange,);
                      }

                      if(snapshot.hasData){
                        final snap = snapshot.data!.docs;
                        return ListView.builder(

                          itemCount: snap.length,
                          itemBuilder: (context, index){

                            return DateFormat('MMMM').format(snap[index]['date'].toDate()) == date ?
                            Container(
                              height: 90,
                              margin: const EdgeInsets.only(top: 12, bottom: 20, left: 150, right: 150),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 100),
                                      decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          DateFormat('EE\ndd').format(snap[index]['date'].toDate()),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Check In",
                                          style: TextStyle(
                                            fontSize: screenWidth/50,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          snap[index]['CheckIn'],
                                          style: TextStyle(
                                            fontSize: screenWidth/50,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Check Out",
                                          style: TextStyle(
                                            fontSize: screenWidth/50,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          snap[index]['CheckOut'],
                                          style: TextStyle(
                                            fontSize: screenWidth/50,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
        ],
      )
    );
  }
}