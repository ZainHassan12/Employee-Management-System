import 'package:e_attendance/empsalary_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'login.dart';


class EmpSalaryMonth extends StatefulWidget {
  const EmpSalaryMonth({Key? key}) : super(key: key);

  @override
  _EmpSalaryMonthState createState() => _EmpSalaryMonthState();
}

class _EmpSalaryMonthState extends State<EmpSalaryMonth> {
  String date = DateFormat('MMMM').format(DateTime.now());

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
          builder: (context) => EmpSalaryView(selectedMonth : date),
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white,), // Icon for the button
            onPressed: () {
              logoutConfirmation();
            },
          ),
        ],
        backgroundColor: Colors.orange,
        toolbarHeight: 50,
        title: const Text('Salary Slip',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
            const SizedBox(height: 30,),
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
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
    ],
      ),
    );
  }
}
