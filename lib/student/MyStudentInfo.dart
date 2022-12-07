import 'package:flutter/material.dart';

class MyStudentInfoPage extends StatelessWidget {
  String projectId = "";
  String projectName = "";
  String userName = "";
  MyStudentInfoPage(this.projectId,this.projectName,this.userName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        title: const Text(
          "내 정보",
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 27),
        ),
        actions: [
          IconButton(
              onPressed: (){},
              color: Colors.black87,
              icon: const Icon(Icons.edit)),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
          )
        ],
      ),
    );
  }
}
