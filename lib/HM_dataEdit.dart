import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:e_attendance/user.dart';
import 'package:intl/intl.dart';
import 'package:e_attendance/bottombar.dart';

class HM_InfoEdit extends StatefulWidget {
  const HM_InfoEdit({Key? key}) : super(key: key);

  @override
  State<HM_InfoEdit> createState() => _HM_InfoEditState();
}

class _HM_InfoEditState extends State<HM_InfoEdit> {
  TextEditingController nameController= TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController numController = TextEditingController();
  TextEditingController addressController= TextEditingController();
  String birth = "Date of Birth";
  String? value;
  List<String> option = ["UK", "USA", "IT"];


  void showSnackBar(String text){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(text)
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: Container(),
          backgroundColor: Colors.orange,
          toolbarHeight: 50,
          title: const Text(
            "Profile",
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
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  textformfield("Name", "Name", nameController),
                  textformfield("CNIC", "CNIC", idController),
                  textformfield("Email Address", "Email Adrress", emailController),
                  textformfield("Contact Number", "Contact Number", numController),

                  const Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Shift",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(top: 3,bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.black54,
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: value,
                        iconSize: 36,
                        dropdownColor: Colors.white,
                        iconEnabledColor: Colors.black54,
                        isExpanded : true,
                        onChanged: (newValue) {
                          setState(() {
                            value= newValue!;
                          });
                        },
                        items: option.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 11),
                              child: Text(
                                value,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Date of Birth",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      ).then((value) =>{
                        setState((){
                          birth = DateFormat("MM/dd/yyyy").format(value!);
                        })
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Container(
                        height: kToolbarHeight,
                        margin: const EdgeInsets.only(top: 3,bottom: 10),
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
                            birth,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  textformfield("Address", "Address", addressController),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 570, right: 570),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: ()async {
                        String name = nameController.text;
                        String id = idController.text;
                        String email = emailController.text;
                        String contact = numController.text;
                        String birthDate = birth;
                        String address = addressController.text;
                        if (name.isEmpty) {
                          showSnackBar("Enter Name");
                        }
                        else if (id.isEmpty) {
                          showSnackBar("Enter CNIC Number");
                        }
                        else if (email.isEmpty) {
                          showSnackBar("Enter Email Address");
                        }
                        else if (birthDate.isEmpty) {
                          showSnackBar("Enter Date of Birth");
                        } else if (address.isEmpty) {
                          showSnackBar("Enter Address");
                        } else {
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection(User.designation).where(
                              'id', isEqualTo: User.username)
                              .get();

                          await FirebaseFirestore.instance
                              .collection(User.designation)
                              .doc(snap.docs[0].id)
                              .get();

                          try {
                            await FirebaseFirestore.instance.collection(User.designation)
                                .doc(snap.docs[0].id)
                                .update({
                              'name': name,
                              'cnic' : id,
                              'email' : email,
                              'contact' : contact,
                              'birthDate': birthDate,
                              'address': address,
                              'shift' : value,

                            });
                          } catch (e) {
                            await FirebaseFirestore.instance.collection(User.designation)
                                .doc(snap.docs[0].id)
                                .set({
                              'name': name,
                              'cnic' : id,
                              'email' : email,
                              'contact' : contact,
                              'birthDate': birthDate,
                              'address': address,
                              'shift' : value,
                            });
                          }
                        }
                        showSnackBar("Your data has been saved!!");
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const BottomBar()));
                      },

                      child: const Center(
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

Widget textformfield(String hint, String title, TextEditingController controller){
  return Padding(
    padding: const EdgeInsets.only(left: 40, right: 40),
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
          margin: const EdgeInsets.only(top: 3 ,bottom: 10),
          child: TextField(
            controller: controller,
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