import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Add_HR extends StatefulWidget {
  const Add_HR({Key? key}) : super(key: key);

  @override
  State<Add_HR> createState() => _Add_HRState();
}

class _Add_HRState extends State<Add_HR> {
  TextEditingController idController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  TextEditingController NameController= TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController numController = TextEditingController();
  TextEditingController emailController = TextEditingController();
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
        backgroundColor: Colors.orange,
        toolbarHeight: 50,
        leading: Container(),
        title: const Text(
          "Add HR",
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
                  height: 20,
                ),

                textformfield("ID (@HR.en)", "ID", idController),

                textformfield("Password", "Password", passwordController),

                textformfield("Name", "Name", NameController),

                textformfield("CNIC", "CNIC", cnicController),

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
                      String name = NameController.text;
                      String birthDate = birth;
                      String address = addressController.text;
                      String id = idController.text;
                      String cnic = cnicController.text;
                      String email = emailController.text;
                      String num = numController.text;
                      String password = passwordController.text;
                      if (id.isEmpty) {
                        showSnackBar("Enter Id");
                      } else if (password.isEmpty) {
                        showSnackBar("Enter Password");
                      } else if (name.isEmpty) {
                        showSnackBar("Enter Name");
                      } else if (cnic.isEmpty) {
                        showSnackBar("Enter cnic");
                      } else if (email.isEmpty) {
                        showSnackBar("Enter Email");
                      } else if (num.isEmpty) {
                        showSnackBar("Enter Contact Number");
                      } else if (value == null) {
                        showSnackBar("Please select shift");
                      } else if (birthDate == 'Date of Birth') {
                        showSnackBar("Enter Date of Birth");
                      } else if (address.isEmpty) {
                        showSnackBar("Enter Address");
                      } else {
                        CollectionReference collection = FirebaseFirestore.instance.collection('HR');
                        var idQuery = await collection.where('id', isEqualTo: id).get();

                        if (idQuery.docs.isNotEmpty) {
                          showSnackBar("ID is already in use");
                        }else{
                          try {
                            await FirebaseFirestore.instance.collection("HR")
                                .add({
                              'id' : id,
                              'password' : password,
                              'name': name,
                              'cnic' : cnic,
                              'contact' : num,
                              'email' : email,
                              'birthDate': birthDate,
                              'address': address,
                              'shift' : value,
                              'designation' : "HR",
                            });
                          } catch (e) {
                            showSnackBar("Opps! an error occured");
                          }
                          showSnackBar("Your data has been saved!!");
                          setState(() {
                            numController.clear();
                            idController.clear();
                            birth = 'Date of Birth';
                            passwordController.clear();
                            cnicController.clear();
                            NameController.clear();
                            emailController.clear();
                            addressController.clear();
                          });
                        }
                      }
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