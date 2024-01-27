import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_attendance/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class LeaveRequests extends StatefulWidget {
  final User user;
  const LeaveRequests({super.key, required this.user});


  @override
  State<LeaveRequests> createState() => _LeaveRequestsState();
}

class _LeaveRequestsState extends State<LeaveRequests> {
  String _month = DateFormat('MMMM').format(DateTime.now());
  String? id;

  @override
  void initState() {
    getDocumentId();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            leading: Container(),
            backgroundColor: Colors.orange,
            title: const Text('Leave Request')
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
                        Text('Employee: ${widget.user.id}',
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
                      stream: FirebaseFirestore.instance.collection(widget.user.Designation).doc(id).collection('leaveRequests').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                        if(snapshot.hasData){
                          final snap = snapshot.data!.docs;
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snap.length,
                            itemBuilder: (context, index){
                              Color mycol;

                              if(snap[index]['Status'] == 'Approved') {
                                mycol = Colors.green;
                              }else if(snap[index]['Status'] == 'Rejected'){
                                mycol = Colors.red;
                              }else{
                                mycol = Colors.orange;
                              }


                              return DateFormat('MMMM').format(snap[index]['Date'].toDate()) == _month ?
                              SingleChildScrollView(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 80,
                                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: mycol,
                                        blurRadius: 10,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                                        width : 100,
                                        decoration: BoxDecoration(
                                          color: mycol,
                                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              snap[index]['Leave Type'],
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
                                        width: 20,
                                      ),

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            child: Container(
                                              padding: const EdgeInsets.only(top: 10),
                                              alignment: Alignment.centerLeft,
                                              width : screenWidth/1.5,
                                              height: 50,
                                              child: Text(
                                                snap[index]['Reason'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: screenWidth/60,
                                                  color: Colors.black54,
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
                                                        snap[index]['Reason'],
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
                                            width: 90,
                                          ),

                                          const Spacer(),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.only(bottom: 15),
                                            width : screenWidth/1.5,
                                            child: Text(
                                              '${snap[index]['Start Date']} - ${snap[index]['End Date']}',
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
                                        width: 120,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: mycol,
                                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Status',
                                              style: TextStyle(
                                                fontSize: screenWidth/80,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              snap[index]['Status'],
                                              style: TextStyle(
                                                fontSize: screenWidth/80,
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
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}
