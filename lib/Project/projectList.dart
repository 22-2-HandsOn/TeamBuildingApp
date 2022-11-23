import 'package:flutter/material.dart';

// 가장 먼저 실행되는 페이지입니다
class ProjectListPage extends StatelessWidget {
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Center(child: Text("List page")),
    );
  }
}
