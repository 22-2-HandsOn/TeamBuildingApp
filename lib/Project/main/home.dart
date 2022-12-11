import 'package:flutter/material.dart';
import 'package:team/Project/main/studentlist.dart';
import 'package:team/Project/main/teamlist.dart';
import 'package:team/student/student_info/MyStudentInfo.dart';
import 'package:team/student/team/MyTeamInfo.dart';

class Home extends StatefulWidget {
  final String projectname;
  final String projectid;
  const Home({Key? key, required this.projectname, required this.projectid})
      : super(key: key);

  @override
  State<Home> createState() => _Homestate();
}

class _Homestate extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    switch (index) {
      case 1:
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TeamListPage(
                      projectId: widget.projectid,
                      projectname: widget.projectname,
                    )));
        break;
      case 2:
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StulistPage(
                      projectname: widget.projectname,
                      projectId: widget.projectid,
                    )));
        break;
      case 3:
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyTeamInfoPage(widget.projectid)));
        break;
      case 4:
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyStudentInfoPage(widget.projectid, widget.projectname)));
        break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text(
          widget.projectname,
          style: TextStyle(
              color: Colors.black87,
              fontFamily: "GmarketSansTTF",
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    "Team Building Summary",
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "GmarketSansTTF",
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
                height: 1,
                width: MediaQuery.of(context).size.width - 40,
                color: Colors.grey),
          ),
          Container(
            //padding:,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Text(
                  "학생현황",
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "GmarketSansTTF",
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    "         총원 : 30명  ",
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "GmarketSansTTF",
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "구성완료 : 20명  ",
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "GmarketSansTTF",
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "나머지 : 10명",
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "GmarketSansTTF",
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
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
