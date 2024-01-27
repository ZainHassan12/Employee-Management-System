import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_attendance/co_bottombar.dart';
import 'package:e_attendance/hrbottombar.dart';
import 'package:flutter/material.dart';
import 'package:e_attendance/bottombar.dart';
import 'ad_dashboard.dart';
import 'package:e_attendance/user.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {

  final TextEditingController eid=TextEditingController();
  final TextEditingController passwordcontroller=TextEditingController();


  String? value;
  List<String> option = ["Director", "HR" , "Manager", "Sales & Support"];


  @override
  void dispose() {
    eid.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Image.asset(
            'assets/background1.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(left: 450,right: 450),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: 300,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/en_logo.png'), fit: BoxFit.fill),
                          ),
                        ),
                        const Text(
                          'Select an option',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
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
                              setState(() {
                                value= newValue!;
                              });
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

                        const SizedBox(
                          height: 40,
                        ),

                        TextField(
                          controller: eid,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Id",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: passwordcontroller,
                          style: const TextStyle(),
                          obscureText: true,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            onPressed: () async{
                              var id=eid.text.trim();
                              var password=passwordcontroller.text.trim();

                              if(id.isEmpty || id == ""){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Employee id is still empty!")
                                ));
                              }
                              else if(password.isEmpty || password == ""){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Password id is still empty!")
                                ));
                              }

                              else if(value == null){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Please select an option")
                                ));
                              }

                              else{
                                QuerySnapshot snap = await FirebaseFirestore.instance.collection(value!)
                                    .where('id', isEqualTo: id).get();
                                if (snap.docs.isEmpty) {

                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Employee ID not found"),
                                  ));
                                } else {
                                  setState(() {
                                    User.Id = snap.docs[0].id;
                                    User.username = snap.docs[0]['id'];
                                    User.Name = snap.docs[0]['name'];
                                    User.Shift = snap.docs[0]['shift'];
                                    User.designation = snap.docs[0]['designation'];
                                  });

                                  try {
                                    if (password == snap.docs[0]['password']) {

                                      if (value == "Director") {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminDashboard()));
                                      } else if (value == "Manager") {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CooordinatorBottomBar()));
                                      } else if (value == "Sales & Support") {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomBar()));
                                      } else if (value == "HR") {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HrBottomBar()));
                                      }
                                      setState(() {
                                        eid.clear();
                                        passwordcontroller.clear();
                                        id = "";
                                        password = "";
                                        value = null;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Incorrect Password"),
                                      ));
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text("An error occurred"),
                                    ));
                                  }
                                }
                              }
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}