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
import 'package:team/student/student_info/MyStudentInfo.dart';

class MyTeamInfoPage extends StatefulWidget {
  String projectId = "";
  String projectname = "";
  MyTeamInfoPage(this.projectId, this.projectname);

  @override
  State<MyTeamInfoPage> createState() => _MyTeamInfoPageState(projectId);
}

class _MyTeamInfoPageState extends State<MyTeamInfoPage> {
  final textStyle = const TextStyle(
      fontFamily: "GmarketSansTTF", fontSize: 12, color: Colors.black54);

  String projectId = "";
  _MyTeamInfoPageState(this.projectId);

  late ProjectCRUD projectCRUD = ProjectCRUD(projectId);

  bool isNull = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
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
            actions: !isNull
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
                : []),
        body: FutureBuilder(
            future: projectCRUD.getTeamInfo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data["isNull"]);
                if (snapshot.data['isNull'] == null) {
                  Future.delayed(Duration.zero, () {
                    setState(() {
                      isNull = false;
                    });
                  });
                  return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 10, height: 1, color: Colors.grey),
                                Text("  팀 이름  ", style: textStyle),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                        height: 1, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Text(
                            snapshot.data['name'].toString(),
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 10, height: 1, color: Colors.grey),
                                Text("  팀 소개  ", style: textStyle),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                        height: 1, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Text(
                            snapshot.data['introduction'].toString(),
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 10, height: 1, color: Colors.grey),
                                Text("  원하는 팀원  ", style: textStyle),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                        height: 1, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Text(
                            snapshot.data['finding_member_info'].toString(),
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16),
                          ),
                          // *TODO : 해쉬태그는 나중에 원하는 팀원 text 위에 다른 해쉬태그 디자인 참고해서 넣을 것
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 10, height: 1, color: Colors.grey),
                                Text("  댓글  ", style: textStyle),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                        height: 1, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ));
                } else {
                  Future.delayed(Duration.zero, () {
                    setState(() {
                      isNull = true;
                    });
                  });

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "소속된 팀이 없습니다.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "GmarketSansTTF",
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
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
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                        color: Colors.lightBlueAccent));
              }
            }));
  }
}
