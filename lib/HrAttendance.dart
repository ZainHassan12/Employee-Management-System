import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:e_attendance/user.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:ntp/ntp.dart';
import 'login.dart';

class HrCheckInCheckOut extends StatefulWidget {
  const HrCheckInCheckOut({Key? key}) : super(key: key);

  @override
  State<HrCheckInCheckOut> createState() => _HrCheckInCheckOutState();
}

class _HrCheckInCheckOutState extends State<HrCheckInCheckOut> {

  DateTime date = DateTime.now();
  String _month = DateFormat('MMMM').format(DateTime.now());
  String CheckIn = "--/--";
  String CheckOut = "--/--";
  String formattedDate = "";
  int count = 0;

  @override
  void initState(){
    super.initState();
    getRecord();
    getNtp();
    getCount();
  }


  void getNtp() async{
    setState(() async {
      date = await NTP.now();
    });
  }

  void getRecord() async{

    DateTime dayEndTime = DateTime(date.year, date.month, date.day, 0, 0);
    DateTime nightEnd = DateTime(date.year, date.month, date.day, 6, 30);

    if (date.isAfter(dayEndTime) && date.isBefore(nightEnd)) {
      formattedDate = DateFormat('dd MMMM yy').format(
          date.subtract(const Duration(days: 1)));
    }else{
      formattedDate = DateFormat('dd MMMM yy').format(date);
    }

    try{
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("HR").where('id', isEqualTo: User.username)
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("HR")
          .doc(snap.docs[0].id).collection("Record").doc(formattedDate)
          .get();

      setState(() {
        CheckIn = snap2['CheckIn'];
        CheckOut = snap2['CheckOut'];

      });

      if (CheckIn == "--/--") {
        User.textHolder = "Check In";
        User.canCheck = true;
      } else {
        User.textHolder = "Check Out";
      }

      if(CheckOut == "--/--"){
        User.canCheck = true;
      }else{
        User.canCheck = false;
      }

    }catch(e){
      setState(() {
        CheckIn = "--/--";
        CheckOut = "--/--";
        User.textHolder = "Check In";
        User.canCheck = true;
      });
    }
  }

  void getCount() async {
    try {
      QuerySnapshot snap2 = await FirebaseFirestore.instance
          .collection('HR').doc(User.Id)
          .collection('Record').get();

      int presentDays = 0;

      snap2.docs.forEach((document) {
        DateTime documentDate = document['date'].toDate();
        if (DateFormat('MMMM').format(documentDate) == _month) {
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
      _month = DateFormat('MMMM').format(selectedMonth);
    });
    getCount();
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
            icon: const Icon(Icons.exit_to_app, color: Colors.white,),
            onPressed: () {
              logoutConfirmation();
            },
          ),
        ],
        title: const Text(
          "Today's Screen",
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
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 8),
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: screenWidth /60,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 8),
                    child: Text(
                      "${User.Name} - ${User.username}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth / 55,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 8),
                    child: Text(
                      "Todays Status",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth / 45,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 150, right: 150),
                    height: 80,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Check In",
                                style: TextStyle(
                                  fontSize: screenWidth/45,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                CheckIn,
                                style: TextStyle(
                                  fontSize: screenWidth/40,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Check Out",
                                style: TextStyle(
                                  fontSize: screenWidth/45,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                CheckOut,
                                style: TextStyle(
                                  fontSize: screenWidth/40,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 8),
                    child: Text(
                      DateFormat('dd MMMM yy').format(date),
                      style: TextStyle(
                        fontSize: screenWidth/55,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                      stream: Stream.periodic(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 8),
                          child: Text(
                            DateFormat('hh:mm:ss a').format(date),
                            style: TextStyle(
                              fontSize: screenWidth/50,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () async {

                      String formattedDate = "";
                      DateTime dayEndTime = DateTime(date.year, date.month, date.day, 0, 0);
                      DateTime nightEnd = DateTime(date.year, date.month, date.day, 6, 30);

                      if (date.isAfter(dayEndTime) && date.isBefore(nightEnd)){
                        formattedDate = DateFormat('dd MMMM yy').format(date.subtract(const Duration(days: 1)));
                        DateTime dateTime = DateTime.now().subtract(const Duration(days: 1));
                        Timestamp timestamp = Timestamp.fromDate(dateTime);

                        if(User.canCheck) {
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("HR").where(
                              'id', isEqualTo: User.username)
                              .get();

                          DocumentSnapshot snap2 = await FirebaseFirestore.instance
                              .collection("HR")
                              .doc(snap.docs[0].id).collection("Record").doc(
                              formattedDate)
                              .get();

                          try {
                            String checkIn = snap2['CheckIn'];
                            await FirebaseFirestore.instance.collection("HR")
                                .doc(snap.docs[0].id).collection("Record").doc(
                                formattedDate)
                                .update({
                              'date': timestamp,
                              'CheckIn': checkIn,
                              'CheckOut': DateFormat('hh:mm a').format(DateTime.now()),
                            });
                          } catch (e) {
                            setState(() {
                              CheckIn = DateFormat('hh:mm a').format(DateTime.now());
                            });

                            await FirebaseFirestore.instance.collection("HR")
                                .doc(snap.docs[0].id).collection("Record").doc(
                                formattedDate)
                                .set({
                              'date': timestamp,
                              'CheckIn': DateFormat('hh:mm a').format(DateTime.now()),
                              'CheckOut': "--/--",
                            });
                          }
                          if (User.textHolder == "Check Out") {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    title: Text("Congratulations"),
                                    content: Text("You have completed the day!!. Don't forget to submit your today's performance summary..."),
                                  );
                                }
                            );
                            setState(() {
                              User.canCheck = false;
                            });
                          } else {
                            setState(() {
                              User.textHolder = "Check Out";
                            });
                          }
                        }else{
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text("Oops"),
                                  content: Text("You already have completed the day!!"),
                                );
                              }
                          );
                        }
                      }else{
                        formattedDate = DateFormat('dd MMMM yy').format(date);
                        DateTime dateTime = DateTime.now();
                        Timestamp timestamp = Timestamp.fromDate(dateTime);

                        if(User.canCheck) {
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("HR").where(
                              'id', isEqualTo: User.username)
                              .get();


                          DocumentSnapshot snap2 = await FirebaseFirestore.instance
                              .collection("HR")
                              .doc(snap.docs[0].id).collection("Record").doc(
                              formattedDate)
                              .get();

                          try {
                            String checkIn = snap2['CheckIn'];
                            await FirebaseFirestore.instance.collection("HR")
                                .doc(snap.docs[0].id).collection("Record").doc(
                                formattedDate)
                                .update({
                              'date': timestamp,
                              'CheckIn': checkIn,
                              'CheckOut': DateFormat('hh:mm a').format(DateTime.now()),
                            });
                          } catch (e) {
                            setState(() {
                              CheckIn = DateFormat('hh:mm').format(DateTime.now());
                            });
                            await FirebaseFirestore.instance.collection("HR")
                                .doc(snap.docs[0].id).collection("Record").doc(
                                formattedDate)
                                .set({
                              'date': timestamp,
                              'CheckIn': DateFormat('hh:mm a').format(DateTime.now()),
                              'CheckOut': "--/--",
                            });
                          }
                          if (User.textHolder == "Check Out") {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    title: Text("Congratulations"),
                                    content: Text("You have completed the day!!"),
                                  );
                                }
                            );
                            setState(() {
                              User.canCheck = false;
                            });
                          } else {
                            setState(() {
                              User.textHolder = "Check Out";
                            });
                          }
                        }else{
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text("Oops"),
                                  content: Text("You already have completed the day!!"),
                                );
                              }
                          );
                        }
                      }
                    },
                    child: Text(
                      User.textHolder,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  const SizedBox(
                    height: 20,
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
                          )

                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      'Total Days : $count',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: screenHeight/1.5,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("HR")
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
          ),
        ],
      )
    );
  }
}