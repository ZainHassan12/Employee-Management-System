import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_attendance/salarySlip_HM.dart';
import 'package:e_attendance/detail.dart';
import 'package:flutter/material.dart';
import 'salaryView_HM.dart';
import 'Attendance_HM.dart';
import 'leaveReq_HM.dart';
import 'user.dart';

class HrInfo extends StatefulWidget {
  const HrInfo({Key? key}) : super(key: key);

  @override
  State<HrInfo> createState() => _HrInfoState();
}

class _HrInfoState extends State<HrInfo> {

  String name = "";

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.orange,
        toolbarHeight: 50,
        title: const Text(
          "HR",
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
          Column(
            children: [
              SizedBox(
                height: screenHeight/50,
              ),
              Container(
                height: screenHeight/23,
                width: screenWidth/1.4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange,
                      blurRadius: 10,
                      //offset: Offset(1, 1),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Here...",
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                  ),
                  onChanged: (val){
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),

              SizedBox(
                height: screenHeight/40,
              ),

              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('HR')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(snapshot.hasData) {

                      final List user = snapshot.data!.docs.map((doc) {
                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                        return User(
                          name: data['name'],
                          id: data['id'],
                          shift: data['shift'],
                          cnic: data['cnic'],
                          address: data['address'],
                          birthDate: data['birthDate'],
                          contact: data['contact'],
                          email: data['email'],
                          Designation: data['designation'],
                        );
                      }).toList();

                      return (snapshot.connectionState == ConnectionState.waiting)
                          ? const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      )
                          : ListView.builder(
                          shrinkWrap: true,
                          itemCount: user.length,
                          itemBuilder: (context, index) {
                            if(name.isEmpty){
                              return GestureDetector(
                                onTap: (){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Select an Option', style: TextStyle(fontWeight: FontWeight.bold),),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              title: const Text("Detail"),
                                              onTap: () {
                                                Navigator.pop(context, "Detail");
                                              },
                                            ),
                                            ListTile(
                                              title: const Text('Attendance'),
                                              onTap: () {
                                                Navigator.pop(context, 'Attendance');
                                              },
                                            ),
                                            ListTile(
                                              title: const Text('Leave Request'),
                                              onTap: () {
                                                Navigator.pop(context, 'Leave Request');
                                              },
                                            ),
                                            ListTile(
                                              title: const Text('Compose Salary'),
                                              onTap: () {
                                                Navigator.pop(context, 'Compose Salary');
                                              },
                                            ),
                                            ListTile(
                                              title: const Text('Salary'),
                                              onTap: () {
                                                Navigator.pop(context, 'Salary');
                                              },
                                            ),
                                            ListTile(
                                              title: const Text('Remove'),
                                              onTap: () {
                                                Navigator.pop(context, 'Remove');
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ).then((result) async {
                                    if (result != null) {
                                      switch (result) {
                                        case "Detail":
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Detail(user: user[index]),
                                              )
                                          );
                                          break;
                                        case 'Attendance':
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Attendance(user: user[index]),
                                              )
                                          );
                                          break;
                                        case 'Leave Request':
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LeaveRequests(user: user[index]),
                                              )
                                          );
                                          break;
                                        case 'Compose Salary':
                                          if(User.designation == "CFO"){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Salary(user: user[index]),
                                                )
                                            );
                                          }else{
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return const AlertDialog(
                                                    title: Text("Opps"),
                                                    content: Text("Sorry! You are not allowed to compose salary slip"),
                                                  );
                                                }
                                            );
                                          }
                                          break;
                                        case 'Salary':
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SalaryView(user: user[index]),
                                              )
                                          );
                                          break;
                                        case 'Remove':
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Confirmation'),
                                                content: const SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text('Do you want to remove this employee?'),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('Yes', style: TextStyle(color: Colors.orange)),
                                                    onPressed: () async {
                                                      late String id;
                                                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                                          .collection('HR')
                                                          .where('id', isEqualTo: user[index].id)
                                                          .get();

                                                      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
                                                        setState(() {
                                                          id = documentSnapshot.id;
                                                        });
                                                      }
                                                      DocumentReference dref = FirebaseFirestore.instance.collection("HR")
                                                          .doc(id);
                                                      dref.delete();
                                                      Navigator.of(context).pop(); // Close the dialog
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('No', style: TextStyle(color: Colors.orange)),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          break;
                                      }
                                    }
                                  }
                                  );
                                },
                                child: Container(
                                  height: 35,
                                  margin: const EdgeInsets.only(
                                      bottom: 4, left: 50, right: 50),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange,
                                        blurRadius: 12,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "${user[index].name} - ${user[index].shift}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            if(user[index].name.toString().toLowerCase().startsWith(name.toLowerCase())){
                              return GestureDetector(
                                onTap: (){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Select an Option', style: TextStyle(fontWeight: FontWeight.bold),),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              title: const Text("Detail"),
                                              onTap: () {
                                                Navigator.pop(context, "Detail");
                                              },
                                            ),
                                            ListTile(
                                              title: const Text('Attendance'),
                                              onTap: () {
                                                Navigator.pop(context, 'Attendance');
                                              },
                                            ),
                                            ListTile(
                                              title: const Text('Leave Request'),
                                              onTap: () {
                                                Navigator.pop(context, 'Leave Request');
                                              },
                                            ),
                                            ListTile(
                                              title: const Text('Compose Salary'),
                                              onTap: () {
                                                Navigator.pop(context, 'Compose Salary');
                                              },
                                            ),
                                            ListTile(
                                              title: const Text('Salary'),
                                              onTap: () {
                                                Navigator.pop(context, 'Salary');
                                              },
                                            ),
                                            ListTile(
                                              title: const Text('Remove'),
                                              onTap: () {
                                                Navigator.pop(context, 'Remove');
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ).then((result) async {
                                    if (result != null) {
                                      switch (result) {
                                        case "Detail":
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Detail(user: user[index]),
                                              )
                                          );
                                          break;
                                        case 'Attendance':
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Attendance(user: user[index]),
                                              )
                                          );
                                          break;
                                        case 'Leave Request':
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LeaveRequests(user: user[index]),
                                              )
                                          );
                                          break;
                                        case 'Compose Salary':
                                          if(User.designation == "CFO"){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Salary(user: user[index]),
                                                )
                                            );
                                          }else{
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return const AlertDialog(
                                                    title: Text("Opps"),
                                                    content: Text("Sorry! You are not allowed to compose salary slip"),
                                                  );
                                                }
                                            );
                                          }
                                          break;
                                        case 'Salary':
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SalaryView(user: user[index]),
                                              )
                                          );
                                          break;
                                        case 'Remove':
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Confirmation'),
                                                content: const SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text('Do you want to remove this employee?'),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('Yes'),
                                                    onPressed: () async {
                                                      late String id;
                                                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                                          .collection('Manager')
                                                          .where('id', isEqualTo: user[index].id)
                                                          .get();

                                                      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
                                                        setState(() {
                                                          id = documentSnapshot.id;
                                                        });
                                                      }
                                                      DocumentReference dref = FirebaseFirestore.instance.collection("Manager")
                                                          .doc(id);
                                                      dref.delete();
                                                      Navigator.of(context).pop(); // Close the dialog
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          break;

                                      }
                                    }
                                  }
                                  );
                                },
                                child: Container(
                                  height: 35,
                                  margin: const EdgeInsets.only(
                                      bottom: 4, left: 50, right: 50),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange,
                                        blurRadius: 12,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "${user[index].name} - ${user[index].shift}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }else{
                              return Container();
                            }
                          }
                      );
                    }else{
                      return const SizedBox();
                    }
                  }
              )
            ],
          ),
        ],
      )
    );
  }
}
