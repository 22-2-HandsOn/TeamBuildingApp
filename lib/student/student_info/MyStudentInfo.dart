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
  late ProjectCRUD projectCRUD = ProjectCRUD(widget.projectId);
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  int _selectedIndex = 4;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      projectname: widget.projectname,
                      projectid: widget.projectId,
                    )));
        break;
      case 1:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => TeamListPage(
                      projectId: widget.projectId,
                      projectname: widget.projectname,
                    )));
        break;
      case 2:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => StulistPage(
                      projectname: widget.projectname,
                      projectId: widget.projectId,
                    )));
        break;
      case 3:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyTeamInfoPage(widget.projectId, widget.projectname)));
        break;

      default:
    }
  }

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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChangeMyStudentInfo(widget.projectId)));
              },
              color: Colors.black87,
              icon: const Icon(Icons.edit)),
        ],
      ),
      body: FutureBuilder(
        future: projectCRUD.getAttendeeInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Uri url1 =
                Uri.parse(snapshot.data['contact_infos']['url1'].toString());
            final Uri url2 =
                Uri.parse(snapshot.data['contact_infos']['url2'].toString());
            final Uri url3 =
                Uri.parse(snapshot.data['contact_infos']['url3'].toString());

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(snapshot.data['name'].toString()),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('내 소개', style: TextStyle(fontSize: 20)),
                  Text(snapshot.data['introduction'].toString()),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('원하는 팀', style: TextStyle(fontSize: 20)),
                  Text(snapshot.data['finding_team_info'].toString()),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('내 해쉬태그들', style: TextStyle(fontSize: 20)),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('contact', style: TextStyle(fontSize: 20)),
                  Text(
                      'email: ${snapshot.data['contact_infos']['email'].toString()}'),
                  Text(
                      'phone: ${snapshot.data['contact_infos']['phone'].toString()}'),
                  InkWell(
                      child: new Text(
                          snapshot.data['contact_infos']['url1'].toString(),
                          style: TextStyle(color: Colors.blueAccent)),
                      onTap: () => launchUrl(url1)),
                  InkWell(
                      child: new Text(
                          snapshot.data['contact_infos']['url2'].toString(),
                          style: TextStyle(color: Colors.blueAccent)),
                      onTap: () => launchUrl(url2)),
                  InkWell(
                      child: new Text(
                          snapshot.data['contact_infos']['url3'].toString(),
                          style: TextStyle(color: Colors.blueAccent)),
                      onTap: () => launchUrl(url3)),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('댓글', style: TextStyle(fontSize: 20)),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet),
            label: "팀리스트",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "학생리스트",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: "내 팀 정보",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "내 정보",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        selectedLabelStyle: TextStyle(color: Colors.red),
        unselectedLabelStyle: TextStyle(color: Colors.black),
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
