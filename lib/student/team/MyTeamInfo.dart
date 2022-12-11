import 'package:flutter/material.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/helper/ProjectCRUD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AddNewTeam.dart';
import 'ChangeTeamInfo.dart';

class MyTeamInfoPage extends StatelessWidget {
  String projectId = "";
  bool hasTeam = false;

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
                  color: Colors.black87,
                  fontFamily: "GmarketSansTTF",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
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
            actions: hasTeam
                ? [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChangeTeamInfo(projectId)));
                        },
                        color: Colors.black87,
                        icon: const Icon(Icons.edit, size: 22)),
                  ]
                : null),
        body: FutureBuilder(
            future: projectCRUD.getTeamInfo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                hasTeam = true;
                print(hasTeam);
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
                      const Text(
                        "소속된 팀이 없습니다.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "GmarketSansTTF", fontSize: 18),
                      ),
                      TextButton(
                          child: const Text(
                            '+  새 팀 생성',
                            style: TextStyle(
                                fontFamily: "GmarketSansTTF", fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddNewTeam(projectId)));
                          })
                    ],
                  ),
                );
              }
            }));
  }
}
