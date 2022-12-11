import 'package:flutter/material.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/helper/ProjectCRUD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AddNewTeam.dart';
import 'ChangeTeamInfo.dart';
import 'package:team/Project/main/studentlist.dart';
import 'package:team/Project/main/teamlist.dart';
import 'package:team/Project/main/home.dart';
import 'package:team/student/team/MyTeamInfo.dart';

class MyTeamInfoPage extends StatelessWidget {
  String projectId = "";
  MyTeamInfoPage(this.projectId);
  late ProjectCRUD projectCRUD = ProjectCRUD(projectId);
  int _selectedIndex = 0;

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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeTeamInfo(projectId)));
              },
              color: Colors.black87,
              icon: const Icon(Icons.edit)),
        ],
      ),
      body: FutureBuilder(
        future: projectCRUD.getTeamInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text('팀 명', style: TextStyle(fontSize: 20)),
                  Text(snapshot.data['name'].toString()),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('팀 소개', style: TextStyle(fontSize: 20)),
                  Text(snapshot.data['introduction'].toString()),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('원하는 팀원', style: TextStyle(fontSize: 20)),
                  Text(snapshot.data['finding_member_info'].toString()),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('내 팀 해쉬태그', style: TextStyle(fontSize: 20)),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('댓글', style: TextStyle(fontSize: 20)),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddNewTeam(projectId)));
                    },
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.grey[700],
                      size: 75,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "팀이 없습니다",
                    //마감일은 "까지 입니다."
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
