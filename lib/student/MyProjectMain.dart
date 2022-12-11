import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:team/student/student_info/MyStudentInfo.dart';
import 'package:team/student/team/MyTeamInfo.dart';
import 'package:team/Project/main/teamlist.dart';
import 'package:team/Project/main/studentlist.dart';
import 'package:team/Project/main/home.dart';

class MyProjectMain extends StatefulWidget {
  String projectId = "";
  String projectName = "";
  MyProjectMain(this.projectId, this.projectName);

  @override
  State<MyProjectMain> createState() => _MyProjectMainState();
}

class _MyProjectMainState extends State<MyProjectMain> {
  int _currentIndex = 0;
  List<Widget> pageList = [];

  int _selectedIndex = 0;

  @override
  void initState() {
    pageList.add(
        Home(projectid: widget.projectId, projectname: widget.projectName));
    pageList.add(TeamListPage(
        projectId: widget.projectId, projectname: widget.projectName));
    pageList.add(StulistPage(
        projectId: widget.projectId, projectname: widget.projectName));
    pageList.add(MyTeamInfoPage(widget.projectId, widget.projectName));
    pageList.add(MyStudentInfoPage(widget.projectId, widget.projectName));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
