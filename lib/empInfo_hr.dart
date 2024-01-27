import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_attendance/detail.dart';
import 'package:e_attendance/emp_activity_ad.dart';
import 'package:e_attendance/emp_salaryView_ad.dart';
import 'package:flutter/material.dart';
import 'empRequests.dart';
import 'login.dart';
import 'user.dart';
import 'empAttendance.dart';

class HrEmpInfo extends StatefulWidget {
  const HrEmpInfo({Key? key}) : super(key: key);

  @override
  State<HrEmpInfo> createState() => _HrEmpInfoState();
}

class _HrEmpInfoState extends State<HrEmpInfo> {

  String name = "";
  String shift = "";

  @override
  void initState() {
    super.initState();
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
            "Sales & Support",
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
                const SizedBox(
                  height: 10,
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
                        //offset: Offset(2, 2),
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
                        .collection('Sales & Support').where('shift', whereIn: [User.Shift, 'IT'])
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
                              Designation: data['designation']
                          );
                        }).toList();

                        return (snapshot.connectionState == ConnectionState.waiting)
                            ? SizedBox(
                          height: screenHeight/2,
                          child: const Center(
                            child: CircularProgressIndicator(color: Colors.orange),
                          ),
                        )
                            : ListView.builder(
                            shrinkWrap: true,
                            itemCount:  user.length,
                            itemBuilder: (context, index) {

                              if(name.isEmpty){
                                return GestureDetector(
                                  onTap: (){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Select an Option', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),),
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
                                                title: const Text('Activity'),
                                                onTap: () {
                                                  Navigator.pop(context, 'Activity');
                                                },
                                              ),
                                              ListTile(
                                                title: const Text('Leave Request'),
                                                onTap: () {
                                                  Navigator.pop(context, 'Leave Request');
                                                },
                                              ),
                                              ListTile(
                                                title: const Text('Salary'),
                                                onTap: () {
                                                  Navigator.pop(context, 'Salary');
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
                                                  builder: (context) => EmpAttendance(user: user[index]),
                                                )
                                            );
                                            break;
                                          case 'Activity':
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => EmpActivity(user: user[index]),
                                                )
                                            );
                                            break;
                                          case 'Leave Request':
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => EmpRequests(user: user[index]),
                                                )
                                            );
                                            break;
                                          case 'Salary':
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => SalaryView(user: user[index]),
                                                )
                                            );
                                            break;
                                        }
                                      }
                                    }
                                    );

                                  },
                                  child: Container(
                                    height: 50,
                                    margin: const EdgeInsets.only(
                                        top: 2, bottom: 4, left: 50, right: 50),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange,
                                          blurRadius: 12,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
                                          '${user[index].name} - ${user[index].id}',
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
                                                title: const Text('Activity'),
                                                onTap: () {
                                                  Navigator.pop(context, 'Activity');
                                                },
                                              ),
                                              ListTile(
                                                title: const Text('Leave Request'),
                                                onTap: () {
                                                  Navigator.pop(context, 'Leave Request');
                                                },
                                              ),
                                              ListTile(
                                                title: const Text('Salary'),
                                                onTap: () {
                                                  Navigator.pop(context, 'Salary');
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
                                                  builder: (context) => EmpAttendance(user: user[index]),
                                                )
                                            );
                                            break;
                                          case 'Activity':
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => EmpActivity(user: user[index]),
                                                )
                                            );
                                            break;
                                          case 'Leave Request':
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => EmpRequests(user: user[index]),
                                                )
                                            );
                                            break;
                                            case 'Salary':
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => SalaryView(user: user[index]),
                                                )
                                            );
                                          }
                                      }
                                    }
                                    );
                                  },
                                  child: Container(
                                    height: 50,
                                    margin: const EdgeInsets.only(
                                        top: 2, bottom: 4, left: 50, right: 50),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange,
                                          blurRadius: 12,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
                                          '${user[index].name} - ${user[index].id}',
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
