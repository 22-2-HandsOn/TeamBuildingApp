import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/Project/widget/team_tile.dart';
import 'package:team/Project/main/studentlist.dart';
import 'package:team/Project/main/home.dart';
import 'package:team/student/student_info/MyStudentInfo.dart';
import 'package:team/student/team/MyTeamInfo.dart';

class TeamListPage extends StatefulWidget {
  final String projectId;
  final String projectname;
  TeamListPage({
    Key? key,
    required this.projectId,
    required this.projectname,
  }) : super(key: key);
  @override
  _TeamListstate createState() => _TeamListstate();
}

class _TeamListstate extends State<TeamListPage> {
  Stream<QuerySnapshot>? teams;
  String projectid = "";
  DocumentSnapshot<Map<String, dynamic>>? tagsnapshot;
  List<String> _tagChoices = []; // 해당 변수로 출력관리.
  List<String> tags = [];
  @override
  void initState() {
    gettingteamData();
    super.initState();
  }

  gettingteamData() async {
    // getting the list of snapshots in our stream
    await DatabaseService().getTeamlist(widget.projectId).then((snapshot) {
      setState(() {
        teams = snapshot;
      });
    });
    await DatabaseService().getteamhashtags(widget.projectId).then((snapshot) {
      setState(() {
        tagsnapshot = snapshot;
      });
    });
    tagupdate();
  }

  tagupdate() {
    final data = tagsnapshot!.data();
    tags = List<String>.from(data?['hashtags']);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gettingteamData();
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
            "팀목록",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 27),
          ),
        ),
        body: Column(
          children: [
            Container(
              // ==>//  height: 50,
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                children: _buildChoiceList(), //타입 1: food, 2: place, 3: pref
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  teamList(),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  teamList() {
    return StreamBuilder(
      stream: teams,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData && !snapshot.hasError
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  //**해당 부분에 tag 관련!**
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
                    return Teamtile(
                      teamName: snapshot.data.docs[index]['name'],
                      teaminfo: snapshot.data.docs[index]
                          ['finding_member_info'],
                      projectid: widget.projectId,
                      projectname: widget.projectname,
                      isfinished: snapshot.data.docs[index]['isFinished'],
                    );
                  } else {
                    return Container();
                  }
                },
                //controller: unitcontroller,
              )
            : noteamWidget();
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
            "팀이 없습니다.",
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
        height: 40,
        padding: const EdgeInsets.all(1.0),
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
