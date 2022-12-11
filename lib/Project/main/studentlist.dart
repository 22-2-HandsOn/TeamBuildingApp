import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team/Project/widget/student_tile.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/Project/main/home.dart';
import 'package:team/Project/main/teamlist.dart';
import 'package:team/student/student_info/MyStudentInfo.dart';
import 'package:team/student/team/MyTeamInfo.dart';

class StulistPage extends StatefulWidget {
  final String projectId;
  final String projectname;
  StulistPage({
    Key? key,
    required this.projectId,
    required this.projectname,
  }) : super(key: key);
  @override
  _Stuliststate createState() => _Stuliststate();
}

class _Stuliststate extends State<StulistPage> {
  Stream<QuerySnapshot>? stulist;
  String projectid = "";
  List<String> _tagChoices = []; // 해당 변수로 출력관리.
  List<String> tags = ["front", "backend", "AI"];

  int _selectedIndex = 2;

  @override
  void initState() {
    gettingstuData();
    super.initState();
  }

  gettingstuData() async {
    await DatabaseService().getstulist(widget.projectId).then((snapshot) {
      setState(() {
        stulist = snapshot;
      });
    });
  }

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
      case 3:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyTeamInfoPage(widget.projectId, widget.projectname)));
        break;
      case 4:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyStudentInfoPage(widget.projectId, widget.projectname)));
        break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gettingstuData();
      });
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
            "학생목록",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 27),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 50,
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                children: _buildChoiceList(), //타입 1: food, 2: place, 3: pref
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  attendees(),
                  Container(
                    padding: EdgeInsets.all(8),
                  )
                ],
              ),
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
    });
  }

  attendees() {
    return StreamBuilder(
      stream: stulist,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData && !snapshot.hasError
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  //tag관련 처리
                  final List<dynamic> taglist =
                      snapshot.data.docs[index]['hashtags'];
                  bool tagcheck = false;
                  if (_tagChoices.isEmpty) tagcheck = true;
                  _tagChoices.forEach((element) {
                    if (taglist.contains(element)) {
                      tagcheck = true;
                    }
                  });
                  if (tagcheck) {
                    return Student_tile(
                        name: snapshot.data.docs[index]['name'],
                        info: snapshot.data.docs[index]['introduction'],
                        projectid: widget.projectId,
                        projectname: widget.projectname);
                  } else {
                    return Container();
                  }
                },
                //controller: unitcontroller,
              )
            : Container();
      },
    );
  }

  noteamWidget() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              //
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const Text(
            "학생이 없습니다.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    tags.forEach((element) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          selectedColor: Colors.lightBlueAccent,
          label: Text(element),
          selected: _tagChoices.contains(element),
          onSelected: (selected) {
            setState(() {
              _tagChoices.contains(element)
                  ? _tagChoices.remove(element)
                  : _tagChoices.add(element);
            });
          },
        ),
      ));
    });
    return choices;
  }
}
