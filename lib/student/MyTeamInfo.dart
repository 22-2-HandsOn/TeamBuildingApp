import 'package:flutter/material.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/helper/ProjectCRUD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyTeamInfoPage extends StatelessWidget {
  String projectId = "";
  MyTeamInfoPage(this.projectId);
  late ProjectCRUD projectCRUD = ProjectCRUD(projectId);
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
        body: FutureBuilder(
            future: projectCRUD.getTeamInfo(),
            builder: (context, snapshot){
              if (snapshot.hasData){
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Text(snapshot.toString(), style: TextStyle(fontSize: 20)),
                    ],
                  ),
                );
              }
              else{

                return Text("정보가 없습니다");
              }
            }
        )
    );
  }
}
