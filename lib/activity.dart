import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:e_attendance/user.dart';
import 'package:month_year_picker/month_year_picker.dart';

import 'login.dart';

class ActivityTimer extends StatefulWidget {
  const ActivityTimer({Key? key}) : super(key: key);

  @override
  State<ActivityTimer> createState() => _ActivityTimerState();
}

class _ActivityTimerState extends State<ActivityTimer> {
  Timer? _timer;
  Timer? timerr;
  DateTime date = DateTime.now();
  String? value;
  List<String> option = ["Break", "Meeting", "Mock-Session"];
  String _month = DateFormat('MMMM').format(DateTime.now());
  bool canStart = true;
  String comment = "";
  TextEditingController commentController = TextEditingController();
  String formattedDate = "";

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    if(value == null){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Please Select an Option")
          ));
    }else{
      if(canStart){
        setState(() {
          canStart = false;
        });
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Attention"),
                content: Text("Activity Started!! You cannot navigate to other screen until you finish the activity"),
              );
            }
        );

        timerr = Timer.periodic(const Duration(seconds: 1,), (Timer timer) {
          setState(() {
            User.timer++;
          });
        });

        _timer = Timer.periodic(const Duration(minutes: 1,), (Timer timer) {
          setState(() {
            User.time++;
          });
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text("Activity Already Started")
            ));
      }
    }
  }

  void saveComment() async {
    if (comment == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please enter a comment!"),
        ),
      );
    } else {
      DateTime dayEndTime = DateTime(date.year, date.month, date.day, 0, 0);
      DateTime nightShiftEndTime = DateTime(date.year, date.month, date.day, 5, 30);

      if (date.isAfter(dayEndTime) && date.isBefore(nightShiftEndTime)) {
        formattedDate = DateFormat('dd MMMM yy').format(date.subtract(const Duration(days: 1)));
      } else {
        formattedDate = DateFormat('dd MMMM yy').format(date);
      }

      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Sales & Support")
          .where('id', isEqualTo: User.username)
          .get();

      DocumentReference recordDocRef = FirebaseFirestore.instance
          .collection("Sales & Support")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(formattedDate);

      try {

        DocumentSnapshot recordSnapshot = await recordDocRef.get();
        List<String> comments = [];

        if (recordSnapshot.exists) {
          Map<String, dynamic> data = recordSnapshot.data() as Map<String, dynamic>;

          if (data.containsKey('comments')) {
            comments = List<String>.from(data['comments']);
          }
        }

        // Append the new comment
        comments.add(comment);

        await recordDocRef.set(
          {
            'comments': comments,
          },
          SetOptions(merge: true),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Comment added successfully!"),
          ),
        );

        setState(() {
          commentController.clear();
          comment = "";
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Something went wrong, Try again!"),
          ),
        );
      }
    }
  }


  void resetTimer() {
    setState(() {
      User.timer = 0;
      User.time = 0;
    });
    if (_timer != null) {
      _timer!.cancel();
    }
    if(timerr != null){
      timerr!.cancel();
    }
  }

  void saveTimer() async {
    if(canStart){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please Start an Acitvity"),
        ),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Activity Ended"),
        ),
      );


      DateTime dayEndTime = DateTime(date.year, date.month, date.day, 0, 0);
      DateTime nightShiftEndTime = DateTime(date.year, date.month, date.day, 6, 30);

      if (date.isAfter(dayEndTime) && date.isBefore(nightShiftEndTime)){
        formattedDate = DateFormat('dd MMMM yy').format(date.subtract(const Duration(days: 1)));
      }else{
        formattedDate = DateFormat('dd MMMM yy').format(date);
      }

      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Sales & Support").where('id', isEqualTo: User.username)
          .get();

      await FirebaseFirestore.instance
          .collection("Sales & Support")
          .doc(snap.docs[0].id).collection("Record").doc(formattedDate)
          .get();

      try{
        DocumentReference recordDocRef = FirebaseFirestore.instance
            .collection("Sales & Support")
            .doc(snap.docs[0].id)
            .collection("Record")
            .doc(formattedDate);

        DocumentSnapshot recordSnapshot = await recordDocRef.get();

        int newTime = User.time;

        if (recordSnapshot.exists) {
          Map<String, dynamic> data = recordSnapshot.data() as Map<String, dynamic>;

          if (data.containsKey('$value')) {
            int existingTime = data['$value'] as int;
            newTime += existingTime;
          }
        }

        await recordDocRef.set({
          '$value': newTime,
        }, SetOptions(merge: true));
      }catch(e){
        await FirebaseFirestore.instance.collection("Sales & Support")
            .doc(snap.docs[0].id).collection("Record").doc(formattedDate)
            .set({
          '$value' : User.time,
        });
      }
      resetTimer();
      setState(() {
        canStart = true;
      });
    }
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
                  }
              ),
            ],
          );
        }
    );
  }


  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
          "Activity",
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
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(top: 5, right: 10),
                    child: const Text(
                      "Total Break Time : 90 minutes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Select an option',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    margin: const EdgeInsets.only(left: 400, right: 400),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: value,
                      iconSize: 36,
                      dropdownColor: Colors.blueGrey,
                      iconEnabledColor: Colors.orange,
                      isExpanded : true,
                      onChanged: (newValue) {
                        if(canStart == false){
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text("Attention"),
                                  content: Text("Please Finish Activity First! "),
                                );
                              }
                          );
                        }else{
                          setState(() {
                            value= newValue!;
                          });
                        }
                      },
                      items: option.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: commentController,
                            onChanged: (value) {
                              comment = value;
                            },
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: 'Comment Box',
                                border: const OutlineInputBorder(
                                )),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          onPressed: () async {
                            saveComment();
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Minutes: ${User.time}',
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: startTimer,
                    child: const Text(
                      'Start',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
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
                    onPressed:() {
                      saveTimer();
                    },
                    child: const Text(
                      'Finish',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                    ),
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
                                  _month = DateFormat('MMMM').format(month);
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
                          )

                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: screenHeight/1.5,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("Sales & Support")
                          .doc(User.Id).collection("Record").snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if(snapshot.hasData){
                          final snap = snapshot.data!.docs;
                          return ListView.builder(

                            itemCount: snap.length,
                            itemBuilder: (context, index){

                              return DateFormat('MMMM').format(snap[index]['date'].toDate()) == _month ?
                              Container(
                                height: 90,
                                margin: const EdgeInsets.only(top: 12, bottom: 20, left: 200, right: 200),
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
                                    Container(
                                      margin: const EdgeInsets.only(right: 50),
                                      width: 130,
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
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Break",
                                            style: TextStyle(
                                              fontSize: screenWidth/70,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Text(
                                            "${snap[index]['Break']} min",
                                            style: TextStyle(
                                              fontSize: screenWidth/55,
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
                                            "Meeting",
                                            style: TextStyle(
                                              fontSize: screenWidth/70,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Text(
                                            "${snap[index]['Meeting']} min",
                                            style: TextStyle(
                                              fontSize: screenWidth/55,
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
                                            "Mock Session",
                                            style: TextStyle(
                                              fontSize: screenWidth/70,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Text(
                                            "${snap[index]['Mock-Session']} min",
                                            style: TextStyle(
                                              fontSize: screenWidth/55,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15, left: 15),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                        ),
                                        onPressed: () {

                                          Map<String, dynamic> documentData = snap[index].data() as Map<String, dynamic>;

                                          if (documentData.containsKey('comments')) {

                                            List<String> comments = (documentData['comments'] as List<dynamic>).cast<String>();
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Comments"),
                                                  content: Column(
                                                    children: comments
                                                        .asMap()
                                                        .entries
                                                        .map((entry) => ListTile(
                                                      title: Text(
                                                        '${entry.key + 1}.  ${entry.value}',
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ))
                                                        .toList(),
                                                  ),
                                                );
                                              },
                                            );
                                          } else {

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return const AlertDialog(
                                                  title: Text("No Comments Found", style: TextStyle(color: Colors.orange),),
                                                  content: Text("There are no comments for this record."),
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: const Text(
                                          "Comments",
                                        ),
                                      ),
                                    )
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
          ),
        ],
      )
    );
  }
}