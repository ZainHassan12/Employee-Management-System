import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:e_attendance/user.dart';
import 'package:intl/intl.dart';

import 'leave_model.dart';

class HrRequest extends StatefulWidget {
  const HrRequest({super.key});

  @override
  _HrRequest createState() => _HrRequest();
}

class _HrRequest extends State<HrRequest> {

  String leaveType="Regular Leave";
  String start = "Start";
  String end = "End";
  TextEditingController reasonController = TextEditingController();
  String reason = "";
  String _month = DateFormat('MMMM').format(DateTime.now());
  Timestamp date = Timestamp.now();
  late String status;

  void submitLeaveRequest() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Request Submitted")
    ));
    final leaveRequest = LeaveRequest(
      id: '',
      type: leaveType,
      startDate: start,
      endDate: end,
      reason: reason,
      status: 'Pending',
    );
    final DocumentReference leaveDocRef = await FirebaseFirestore.instance.collection('HR').doc(User.Id).collection('leaveRequests').add({
      'Leave Type' : leaveRequest.type,
      'Start Date' : leaveRequest.startDate,
      'End Date' : leaveRequest.endDate,
      'Reason' : leaveRequest.reason,
      'Status' : leaveRequest.status,
      'Date' :  date,
    });
    setState(() {
      leaveRequest.id = leaveDocRef.id;
    });
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
          title: const Text('Leave Request')),
      body: Stack(
        children: [
          Image.asset(
            'assets/background5.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight/55,
                  ),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(top: 3,bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.orange,
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: leaveType,
                      onChanged: (newValue) {
                        setState(() {
                          leaveType = newValue!;
                          start = "Start";
                          end = "End";
                          reasonController.clear();
                        });
                      },
                      items: ['Regular Leave', 'Short Leave']
                          .map<DropdownMenuItem<String>>(
                            (value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      if(leaveType == "Regular Leave") {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2050),
                        ).then((value) =>
                        {
                          setState(() {
                            start = DateFormat("dd MMMM yyyy").format(value!);
                          })
                        });
                      }else{
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((value) => {
                          setState(() {
                            start = value!.format(context).toString();
                          })
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Container(
                        height: kToolbarHeight,
                        margin: const EdgeInsets.only(top: 3, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.black54,
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 11),
                          child: Text(
                            start,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      if(leaveType == "Regular Leave") {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2050),
                        ).then((value) =>
                        {
                          setState(() {
                            end = DateFormat("dd MMMM yyyy").format(value!);
                          })
                        });
                      }else{
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((value) => {
                          setState(() {
                            end = value!.format(context).toString();
                          })
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Container(
                        height: kToolbarHeight,
                        margin: const EdgeInsets.only(top: 3, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.black54,
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 11),
                          child: Text(
                            end,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: TextFormField(
                      controller: reasonController,
                      onChanged: (value) {
                        reason = value;
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Reason',
                          border: const OutlineInputBorder(
                          )),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: (){
                      if(start == "Start" || end == "End" || reason == ""){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Please fill leave request form")
                        ));
                      }else{
                        submitLeaveRequest();
                        setState(() {
                          start = "Start";
                          end  = "End";
                          reasonController.clear();
                          reason = "";
                        });
                      }
                    },
                    child: const Text('Submit Request',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),),
                  ),

                  const SizedBox(
                    height: 30,
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
                      stream: FirebaseFirestore.instance.collection("HR")
                          .doc(User.Id).collection("leaveRequests").snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                        if(snapshot.hasData){
                          final snap = snapshot.data!.docs;
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snap.length,
                            itemBuilder: (context, index){
                              status = snap[index]['Status'];
                              Color mycol;

                              if(status == 'Approved') {
                                mycol = Colors.green;
                              }else if(status == 'Rejected'){
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
                                          Row(
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
                                                width: 70,
                                              ),
                                              snap[index]['Status'] == 'Pending'? Padding(
                                                padding: const EdgeInsets.only(top: 20),
                                                child: ElevatedButton(
                                                  onPressed: (){
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                        content: Text("Request Declined")
                                                    ));
                                                    DocumentReference dref = FirebaseFirestore.instance.collection("HR")
                                                        .doc(User.Id).collection("leaveRequests").doc(snap[index].id);
                                                    dref.delete();
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                                  ),
                                                  child: const Text(
                                                      "Decline"
                                                  ),
                                                ),
                                              ) : const SizedBox(),
                                            ],
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
                                        width: 100,
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
                                            Text(
                                              snap[index]['Status'],
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
