import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'user.dart';
import 'package:intl/intl.dart';

class EmpActivity extends StatefulWidget {
  final User user;
  const EmpActivity({super.key, required this.user});

  @override
  State<EmpActivity> createState() => _EmpActivityState();
}

class _EmpActivityState extends State<EmpActivity> {

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
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.orange,
        toolbarHeight: 50,
        title: const Text('Activity',
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
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),

                Center(
                  child: Column(
                    children: [
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

                      Text('Name: ${widget.user.name}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),),
                      const SizedBox(height: 15),
                      Text('Employee Id: ${widget.user.id}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),),
                      const SizedBox(height: 15),
                      Text('Shift: ${widget.user.shift}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 8),
                      child: Text(
                        date,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth / 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 8),
                      child : GestureDetector(
                        onTap: ()async {
                          final month  = await showMonthYearPicker(
                            context : context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2099),
                          );
                          if(month!=null){
                            setState(() {
                              date = DateFormat('MMMM yyyy').format(month);
                            });
                          }
                        },
                        child: Text(
                          "Pick a month",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth / 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: screenHeight/1.5,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("Sales & Support")
                        .doc(id).collection("Record").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(color: Colors.orange,);
                      }

                      if(snapshot.hasData){
                        final snap = snapshot.data!.docs;
                        return ListView.builder(

                          itemCount: snap.length,
                          itemBuilder: (context, index){
                            return DateFormat('MMMM yyyy').format(snap[index]['date'].toDate()) == date ?
                            Container(
                              height: 90,
                              margin: const EdgeInsets.only(top: 12, bottom: 20, left: 200, right: 200),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange,
                                    blurRadius: 10,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 50),
                                    width: 100,
                                    decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        DateFormat('EE\ndd').format(snap[index]['date'].toDate()),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Break",
                                          style: TextStyle(
                                            fontSize: screenWidth/60,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          "${snap[index]['Break']} min",
                                          style: TextStyle(
                                            fontSize: screenWidth/50,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Meeting",
                                          style: TextStyle(
                                            fontSize: screenWidth/60,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          "${snap[index]['Meeting']} min",
                                          style: TextStyle(
                                            fontSize: screenWidth/50,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Mock-Session",
                                          style: TextStyle(
                                            fontSize: screenWidth/60,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          "${snap[index]['Mock-Session']} min",
                                          style: TextStyle(
                                            fontSize: screenWidth/50,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15, left: 15),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                        ),
                                        onPressed: (){

                                          Map<String, dynamic> documentData = snap[index].data() as Map<String, dynamic>;

                                          if (documentData.containsKey('comments')) {

                                            List<String> comments = (documentData['comments'] as List<dynamic>).cast<String>();
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Comments"),
                                                  content: Column(
                                                    children: comments
                                                        .asMap()
                                                        .entries
                                                        .map((entry) => ListTile(
                                                      title: Text(
                                                        '${entry.key + 1}.  ${entry.value}',
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ))
                                                        .toList(),
                                                  ),
                                                );
                                              },
                                            );
                                          } else {

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return const AlertDialog(
                                                  title: Text("No Comments Found", style: TextStyle(color: Colors.orange),),
                                                  content: Text("There are no comments for this record."),
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: const Text(
                                          "Comment",
                                        )
                                    ),
                                  )

                                ],
                              ),
                            ): const SizedBox();
                          },
                        );
                      }else{
                        return const SizedBox();
                      }
                    },
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
