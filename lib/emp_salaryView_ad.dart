import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_attendance/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class SalaryView extends StatefulWidget {
  final User user;
  const SalaryView({super.key, required this.user});

  @override
  _SalaryViewState createState() => _SalaryViewState();
}

class _SalaryViewState extends State<SalaryView> {
  String date = DateFormat('MMMM').format(DateTime.now());
  String? id;

  @override
  void initState() {
    super.initState();
    getDocumentId();
  }

  Future<void> getDocumentId() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Sales & Support')
        .where('id', isEqualTo: widget.user.id)
        .get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      setState(() {
        id = documentSnapshot.id;
      });
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/en-.png',
                fit: BoxFit.cover,
                width: 500,
                height: 500,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 8),
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: screenWidth / 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () async {
                          final selectedDate = await showMonthYearPicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2099),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              date = DateFormat('MMMM').format(selectedDate);
                            });
                          }
                        },
                        child: Text(
                          'Pick a month',
                          style: TextStyle(
                            fontSize: screenWidth / 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Sales & Support')
                      .doc(id)
                      .collection("Salary")
                      .where('month', isEqualTo: date)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('No salary slips found for the selected month.');
                    }

                    return Column(
                      children: snapshot.data!.docs.map((document) {
                        final data = document.data() as Map<String, dynamic>;
                        return Padding(
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
                              Text('Month: ${data["month"]}'),
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
                                  Text("Rs ${data["Basic salary"]}")
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Bonus'),
                                  Text("Rs ${data["Bonus"]}")
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Earnings', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("Rs ${data["Salary"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
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
                                  Text("Rs ${data["Deduction"]}"),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Reason'),
                                  Text(data["Reason"]),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Net Salary', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("Rs ${data["Total Salary"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                )

              ],
            ),
          ),
        ],
      )
    );
  }
}
