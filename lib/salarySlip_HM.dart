import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_attendance/cordInfo.dart';
import 'package:flutter/material.dart';
import 'package:e_attendance/user.dart';
import 'package:intl/intl.dart';

import 'hrinfo.dart';

class Salary extends StatefulWidget {
  final User user;
  const Salary({super.key, required this.user});
  @override
  State<Salary> createState() => _SalaryState();
}

class _SalaryState extends State<Salary> {
  TextEditingController basicsal = TextEditingController();
  TextEditingController bonus = TextEditingController();
  TextEditingController deductionController = TextEditingController();
  TextEditingController reason = TextEditingController();
  int? salary;
  int? total;
  String? id;
  String? value;
  List<String> option = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

  @override
  void initState() {
    super.initState();
    getDocumentId();
  }

  Future<void> getDocumentId() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(widget.user.Designation)
        .where('id', isEqualTo: widget.user.id)
        .get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      setState(() {
        id = documentSnapshot.id;
      });
    }
  }

  void updateTotalAndNetSalary() {
    String inputSal = basicsal.text;
    String inputDeduct = deductionController.text;
    String inputBonus = bonus.text;
    int? Sal = int.tryParse(inputSal);
    int? Bonus = int.tryParse(inputBonus);
    int? deduct = int.tryParse(inputDeduct);

    setState(() {
      salary = Sal! + Bonus!;
      total = salary! - deduct!;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.orange,
        toolbarHeight: 50,
        title: const Text('Salary Slip',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Elevate Network',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Text('Employee Name: ${widget.user.name}'),
              Text('Employee ID: ${widget.user.id}'),
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Please select a month',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 120,
                    height: 40,
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
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Earnings', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Amount', style: TextStyle(fontWeight: FontWeight.bold,)),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Basic Salary'),
                  SizedBox(
                    width: 50,
                    child: TextFormField(
                      controller: basicsal,
                      onChanged: (value) {
                        updateTotalAndNetSalary();
                      },
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Bonus'),
                  SizedBox(
                    width: 50,
                    child: TextFormField(
                      controller: bonus,
                      onChanged: (value) {
                        updateTotalAndNetSalary();
                      },
                    ),
                  )
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Earnings', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Rs ${salary ?? 0}", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Deductions', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Deduction'),
                  SizedBox(
                    width: 50,
                    child: TextFormField(
                      controller: deductionController,
                      onChanged: (value) {
                        updateTotalAndNetSalary();
                      },
                    ),
                  )
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Reason'),
                  SizedBox(
                    width: 200,
                    child: Center(
                      child: TextFormField(
                        controller: reason,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Net Salary', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Rs ${total ?? 0}", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () async {
                    String inputSal = basicsal.text;
                    String inputDeduct = deductionController.text;
                    String inputBonus = bonus.text;
                    String inputReason = reason.text;
                    int? Sal = int.tryParse(inputSal);
                    int? Bonus = int.tryParse(inputBonus);
                    int? deduct = int.tryParse(inputDeduct);

                    // Check if any of the fields are empty
                    if (inputSal.isEmpty || inputBonus.isEmpty || inputDeduct.isEmpty || inputReason.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please fill in all fields"),
                      ));
                    } else {
                      salary = Sal! + Bonus!;
                      total = salary! - deduct!;

                      try {
                        await FirebaseFirestore.instance.collection(widget.user.Designation)
                            .doc(id).collection("Salary").doc(
                            value)
                            .set({
                          'date': DateFormat('dd MMMM yy').format(DateTime.now()),
                          'Basic salary': Sal,
                          'Bonus': Bonus,
                          'Salary': salary,
                          'Deduction': deduct,
                          'Total Salary': total,
                          'Reason': inputReason, // Use the inputReason variable
                          'month': value,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Done"),
                        ));

                        if (widget.user.Designation == "Manager") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CoordinatorInfo(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HrInfo(),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Error Occurred"),
                        ));
                      }
                    }
                  },
                  child: const Text("Done"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}