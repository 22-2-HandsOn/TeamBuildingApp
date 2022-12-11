import 'package:flutter/material.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/helper/ProjectCRUD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ChangeStudentInfo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:team/Project/main/studentlist.dart';
import 'package:team/Project/main/teamlist.dart';
import 'package:team/Project/main/home.dart';
import 'package:team/student/team/MyTeamInfo.dart';

class MyStudentInfoPage extends StatefulWidget {
  String projectId = "";
  String projectname = "";
  MyStudentInfoPage(this.projectId, this.projectname);

  @override
  State<MyStudentInfoPage> createState() => _MyStudentInfoPageState();
}

class _MyStudentInfoPageState extends State<MyStudentInfoPage> {
  final textStyle = const TextStyle(
      fontFamily: "GmarketSansTTF", fontSize: 12, color: Colors.black54);

  late ProjectCRUD projectCRUD = ProjectCRUD(widget.projectId);
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
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
              color: Colors.black87,
              fontFamily: "GmarketSansTTF",
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChangeMyStudentInfo(widget.projectId)));
              },
              color: Colors.black87,
              icon: const Icon(Icons.edit, size: 22)),
        ],
      ),
      body: FutureBuilder(
        future: projectCRUD.getAttendeeInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 10, height: 1, color: Colors.grey),
                        Text("  학번 및 이름  ", style: textStyle),
                        Container(width: 275, height: 1, color: Colors.grey),
                      ],
                    ),
                  ),
                  Text(
                    "[" +
                        snapshot.data['stu_id'].toString() +
                        "] " +
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
                        Container(width: 10, height: 1, color: Colors.grey),
                        Text("  내 소개  ", style: textStyle),
                        Container(width: 300, height: 1, color: Colors.grey),
                      ],
                    ),
                  ),
                  Text(
                    snapshot.data['introduction'].toString() != ""
                        ? snapshot.data['introduction'].toString()
                        : "아직 소개글을 작성하지 않았습니다. ",
                    style: snapshot.data['introduction'].toString() != ""
                        ? TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16)
                        : TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 14,
                            color: Colors.black87),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 10, height: 1, color: Colors.grey),
                        Text("  원하는 팀  ", style: textStyle),
                        Container(width: 290, height: 1, color: Colors.grey),
                      ],
                    ),
                  ),
                  Text(
                    snapshot.data['finding_team_info'].toString() != ""
                        ? snapshot.data['finding_team_info'].toString()
                        : "아직 원하는 팀 정보를 작성하지 않았습니다. ",
                    style: snapshot.data['finding_team_info'].toString() != ""
                        ? TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16)
                        : TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 14,
                            color: Colors.black87),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 10, height: 1, color: Colors.grey),
                        Text("  연락 방법  ", style: textStyle),
                        Container(width: 290, height: 1, color: Colors.grey),
                      ],
                    ),
                  ),
                  Contact(snapshot),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 10, height: 1, color: Colors.grey),
                        Text("  댓글  ", style: textStyle),
                        Container(width: 310, height: 1, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
                child:
                    CircularProgressIndicator(color: Colors.lightBlueAccent));
          }
        },
      ),
    );
  }
}

class Contact extends StatelessWidget {
  var snapshot;
  Contact(this.snapshot);
  Widget build(BuildContext context) {
    if (snapshot.data['contact_infos'] != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('email: ${snapshot.data['contact_infos']['email'].toString()}'),
          Text('phone: ${snapshot.data['contact_infos']['phone'].toString()}'),
          Text('url1: ${snapshot.data['contact_infos']['url1'].toString()}'),
          Text('url2: ${snapshot.data['contact_infos']['url2'].toString()}'),
          Text('url3: ${snapshot.data['contact_infos']['url3'].toString()}'),
        ],
      );
    } else {
      return Text(
        "아직 연락 방법 목록을 작성하지 않았습니다. ",
        style: TextStyle(
            fontFamily: "GmarketSansTTF", fontSize: 14, color: Colors.black87),
      );
    }
  }
}
