import 'package:flutter/material.dart';

class MyTeamInfoPage extends StatelessWidget {
  const MyTeamInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "내 팀 정보",
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 27),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
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
