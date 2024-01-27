import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import 'HM-salary-view.dart';

class HrSalary extends StatefulWidget {
  const HrSalary({Key? key}) : super(key: key);

  @override
  _HrSalaryState createState() => _HrSalaryState();
}

class _HrSalaryState extends State<HrSalary> {
  String date = DateFormat('MMMM').format(DateTime.now());

  void selectMonth(BuildContext context) async {
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

      // Navigate to the next screen and pass the selected month as a parameter
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SalaryViewHM(selectedMonth : date),
        ),
      );
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
          Image.asset(
            'assets/background5.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
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
                        selectMonth(context);
                      },
                      child: Text(
                        'Pick a month',
                        style: TextStyle(
                            fontSize: screenWidth / 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      )
    );
  }
}
