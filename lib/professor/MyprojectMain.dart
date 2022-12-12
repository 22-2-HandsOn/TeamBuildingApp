import 'package:flutter/material.dart';
import 'package:team/Project/main/teamlist.dart';
import 'package:team/Project/main/studentlist.dart';
import 'package:team/Project/main/home.dart';

class MyProjectMain extends StatefulWidget {
  String projectId = "";
  String projectName = "";
  String userName = "";
  MyProjectMain(this.projectId, this.projectName, this.userName);

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: pageList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home, size: 30),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet),
            activeIcon: Icon(Icons.text_snippet, size: 30),
            label: "팀리스트",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            activeIcon: Icon(Icons.people, size: 30),
            label: "학생리스트",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlueAccent,
        selectedLabelStyle: TextStyle(
            color: Colors.lightBlueAccent,
            fontFamily: "GmarketSansTTF",
            fontSize: 12,
            fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(
          color: Colors.black38,
          fontFamily: "GmarketSansTTF",
          fontSize: 12,
        ),
        unselectedItemColor: Colors.black38,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
