import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_attendance/user.dart';
import 'package:flutter/material.dart';

import 'bottombar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  TextEditingController previousController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmationController = TextEditingController();
  String? previouspass;

  @override
  void initState(){
    super.initState();
    getPassword();
  }

  void showSnackBar(String text){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(text)
        ));
  }

  void getPassword() async {
    try{
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Sales & Support").where('id', isEqualTo: User.username)
          .get();

      setState(() {
        previouspass =snap.docs[0]['password'];
      });

    }catch(e){
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("An Error occured"),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        toolbarHeight: 50,
        title: const Text(
          "Employee Data",
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
                height: 20,
              ),
              textformfield("Enter Previous Password", "Previous Password", previousController),
              textformfield("Enter New Password", "New Password", newController),
              textformfield("Re_Enter New Password", "Password Confirmation", confirmationController),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 350),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () async {
                    String previous = previousController.text;
                    String newpass = newController.text;
                    String confirmpass = confirmationController.text;

                    if (previous.isEmpty) {
                      showSnackBar("Enter Previous Password");
                    }
                    else if (newpass.isEmpty) {
                      showSnackBar("Enter New Password");
                    }
                    else if (confirmpass.isEmpty) {
                      showSnackBar("Re_Enter Password");
                    }
                    else if (previous != previouspass) {
                      showSnackBar("Wrong Previous Password, Enter Correct Password");
                    } else if (newpass != confirmpass) {
                      showSnackBar("Re_Enter Correct New Password");
                    } else {
                      QuerySnapshot snap = await FirebaseFirestore.instance
                          .collection("Sales & Support").where(
                          'id', isEqualTo: User.username)
                          .get();

                      await FirebaseFirestore.instance
                          .collection("Sales & Support")
                          .doc(snap.docs[0].id)
                          .get();

                      try {
                        await FirebaseFirestore.instance.collection("Sales & Support")
                            .doc(snap.docs[0].id)
                            .update({
                          'password':newpass,

                        });
                      } catch (e) {
                        showSnackBar("Error Occured");
                      }
                      showSnackBar("Password Has Been Changed!!");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const BottomBar()));
                    }
                  },
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Widget textformfield(String hint, String title, TextEditingController controller){
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 500),
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 3 ,bottom: 15),
          child: TextField(
            controller: controller,
            obscureText: true,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                fillColor: Colors.grey.shade100,
                filled: true,
                hintText: hint,
                border: const OutlineInputBorder(
                )),
          ),
        ),
      ],
    ),
  );
}
