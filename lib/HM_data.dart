import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:e_attendance/user.dart';

import 'HM_PasswordChange.dart';
import 'HM_dataEdit.dart';
import 'login.dart';

class HM_Data extends StatefulWidget {
  const HM_Data({Key? key}) : super(key: key);

  @override
  State<HM_Data> createState() => _HM_DataState();
}

class _HM_DataState extends State<HM_Data> {

  String name = "";
  String id = "";
  String email = "";
  String contact = "";
  String birthdate = "";
  String address = "";
  String shift = "";
  String designation = "";

  @override
  void initState(){
    super.initState();
    getRecord();
  }

  void getRecord() async{
    try{
      QuerySnapshot snap =await FirebaseFirestore.instance
          .collection(User.designation).where('id', isEqualTo: User.username)
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection(User.designation)
          .doc(snap.docs[0].id)
          .get();
      setState(() {
        name = snap2['name'];
        id = snap2['cnic'];
        email = snap2['email'];
        contact = snap2['contact'];
        address = snap2['address'];
        birthdate = snap2['birthDate'];
        shift = snap2['shift'];
        designation = snap2['designation'];
      });
    }catch(e){
      setState(() {
        name = "Not Found";
        id = "Not Found";
        email = "Not Found";
        contact = "Not Found";
        address = "Not Found";
        birthdate = "Not Found";
        shift = "Not Found";
        designation = "Not Found";
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
  Widget build(BuildContext context) {
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
            "Employee Data",
          ),
        ),
        body : Stack(
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
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        Container(
                          height: 150,
                          width: 200,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/en_logo.png'), fit: BoxFit.fill),
                          ),
                        ),

                        Text('Name  :   $name',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                        const SizedBox(height: 15),

                        Text('Designation  :   $designation',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                        const SizedBox(height: 15),

                        Text('CNIC  :   $id',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                        const SizedBox(height: 15),

                        Text('Contact No.   :   $contact',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                        const SizedBox(height: 15),

                        Text('Email   :   $email',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                        const SizedBox(height: 15),

                        Text('Shift   :   $shift',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                        const SizedBox(height: 15),
                        Text('Date of Birth   :   $birthdate',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                        const SizedBox(height: 15),
                        Text('Address   :   $address',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const HM_InfoEdit()));
                          },
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const HM_ChangePassword()));
                          },
                          child: const Text(
                            'Change Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        )
    );
  }
}