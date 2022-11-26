import 'package:flutter/material.dart';

class MyTeamInfoPage extends StatefulWidget {
  const MyTeamInfoPage({Key? key}) : super(key: key);

  @override
  State<MyTeamInfoPage> createState() => _MyTeamInfoPageState();
}

class _MyTeamInfoPageState extends State<MyTeamInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("내 팀 정보"),
      ),
      body: Container(
      ),
    );
  }
}
