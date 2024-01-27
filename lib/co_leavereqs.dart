import 'package:e_attendance/co_leave_request.dart';
import 'package:flutter/material.dart';
import 'package:e_attendance/allRequest.dart';
import 'login.dart';

class CoLeaveRequest extends StatefulWidget {
  const CoLeaveRequest({Key? key}) : super(key: key);

  @override
  State<CoLeaveRequest> createState() => _CoLeaveRequest();
}

class _CoLeaveRequest extends State<CoLeaveRequest> {

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
    final screenHeight = MediaQuery.of(context).size.height;
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
          "Leave Request",
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
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight/3,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const CoComposeRequest()));
                  },
                  child: const Text(
                    'Compose Leave Request',
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                ),

                SizedBox(
                  height: screenHeight/30,
                ),


                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const AllRequests()));
                  },
                  child: const Text(
                    'All Leave Requests',
                    style: TextStyle(
                        fontSize: 20
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