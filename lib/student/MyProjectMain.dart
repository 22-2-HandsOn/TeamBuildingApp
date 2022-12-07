import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:team/student/MyStudentInfo.dart';
import 'package:team/student/MyTeamInfo.dart';
import 'package:team/Project/main/teamlist.dart';
import 'package:team/Project/main/studentlist.dart';

class MyProjectMain extends StatefulWidget {
  String projectId = "";
  String projectName = "";
  String userName = "";
  MyProjectMain(this.projectId,this.projectName,this.userName);

  @override
  State<MyProjectMain> createState() => _MyProjectMainState();
}

class _MyProjectMainState extends State<MyProjectMain> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            TeamListPage(
                projectId: widget.projectId,
                projectName: widget.projectName,
                userName: widget.userName),
            Container(),
            MyTeamInfoPage(),
            MyStudentInfoPage(widget.projectId,widget.projectName,widget.userName),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.handshake),
            title: Text('팀 빌딩'),
            activeColor: Colors.lightBlueAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.pageview),
            title: Text('학생 리스트'),
            activeColor: Colors.lightBlueAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.flag),
            title: Text('내 팀 정보',),
            activeColor: Colors.lightBlueAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('내 정보'),
            activeColor: Colors.lightBlueAccent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
