import 'package:e_attendance/user.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdResign extends StatefulWidget {
  const AdResign({Key? key}) : super(key: key);

  @override
  State<AdResign> createState() => _AdResignState();
}

class _AdResignState extends State<AdResign> {

  String _month = DateFormat('MMMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        toolbarHeight: 50,
        leading: Container(),
        title: const Text(
          "Resignation",
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
              const SizedBox(height: 20),
              Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 8),
                    child: Text(
                      _month,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth / 60,
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
                              _month = DateFormat('MMMM').format(month);
                            });
                          }
                        },
                        child: Text(
                          "Pick a month",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth / 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                  ),
                ],
              ),

              SizedBox(
                height: screenHeight/1.5,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("Director")
                      .doc(User.Id).collection("Resignation").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                    if(snapshot.hasData){
                      final snap = snapshot.data!.docs;

                      snap.sort((a, b) => b['Date'].toDate().compareTo(a['Date'].toDate()));
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snap.length,
                        itemBuilder: (context, index){

                          return DateFormat('MMMM').format(snap[index]['Date'].toDate()) == _month ?
                          SingleChildScrollView(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 80,
                              margin: const EdgeInsets.only(top: 12, bottom: 20),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                                    width : 180,
                                    decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          DateFormat('EE dd').format(snap[index]['Date'].toDate()),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "${snap[index]['name']} - ${snap[index]['shift']}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),

                                  Column(
                                    children: [
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Application",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            child: Container(
                                              padding: const EdgeInsets.only(top: 10),
                                              alignment: Alignment.centerLeft,
                                              width : screenWidth/1.3,
                                              height: 50,
                                              child: Text(
                                                snap[index]['Resignation'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: screenWidth/70,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                            onTap: (){
                                              showDialog(
                                                  context: context,
                                                  builder: (context){
                                                    return AlertDialog(
                                                      title: const Text("Application", style: TextStyle(color: Colors.orange),),
                                                      content: Text(
                                                        snap[index]['Resignation'],
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                              );
                                            },
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          snap[index]['isChecked'] == false? Padding(
                                            padding: const EdgeInsets.only(top: 15, ),
                                            child: ElevatedButton(
                                              onPressed: (){
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                    content: Text("Checked")
                                                ));
                                                FirebaseFirestore.instance.collection("Director")
                                                    .doc(User.Id).collection("Resignation").doc(snap[index].id).update({
                                                  'isChecked' : true,
                                                });
                                              },
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                                              ),
                                              child: const Text(
                                                  "Check"
                                              ),
                                            ),
                                          ) : const SizedBox(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
        ],
      )
    );
  }
}