import 'package:flutter/material.dart';
import 'package:e_attendance/user.dart';

class Detail extends StatefulWidget {
  final User user;
  const Detail({super.key, required this.user});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: Container(),
        toolbarHeight: 50,
        title: const Text('Details',
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 60),
                child: Column(
                  children: [

                    const SizedBox(
                      height: 20,
                    ),

                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.orange
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    Row(
                      children: [
                        const Text('Name: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(widget.user.name,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),

                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Text('Employee Id: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(widget.user.id,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Text('Shift: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(widget.user.shift,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Text('Contact Number: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(widget.user.contact,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Text('CNIC: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(widget.user.cnic,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Text('Date of Birth: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(widget.user.birthDate,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Text('Address: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(widget.user.address,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
