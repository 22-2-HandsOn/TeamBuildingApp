import 'package:flutter/material.dart';

class MyStudentInfoPage extends StatefulWidget {
  const MyStudentInfoPage({Key? key}) : super(key: key);

  @override
  State<MyStudentInfoPage> createState() => _MyStudentInfoPageState();
}

class _MyStudentInfoPageState extends State<MyStudentInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("내 정보"),
      ),
      body: Padding(
          padding: EdgeInsets.all(8.0),
        child: ListView(
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}
