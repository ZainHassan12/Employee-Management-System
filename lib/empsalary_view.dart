import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_attendance/user.dart';
import 'package:flutter/material.dart';

class EmpSalaryView extends StatelessWidget {
  final String selectedMonth;

  EmpSalaryView({required this.selectedMonth});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Stack(
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
              StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Sales & Support')
                  .doc(User.Id)
                  .collection("Salary")
                  .where('month', isEqualTo: selectedMonth)
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
                          Text('Employee Name: ${User.Name}'),
                          Text('Employee ID: ${User.username}'),
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
            ),
            ],
          ),
        ],
      ),
    );
  }
}
