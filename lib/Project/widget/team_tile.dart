import 'package:flutter/material.dart';
import 'package:team/professor/profprojectList.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/student/team/MyTeamInfo.dart';

class Teamtile extends StatefulWidget {
  final String teamName;
  final String teaminfo;
  final String projectid;
  final String projectname;
  //final String opponent;
  const Teamtile({
    Key? key,
    required this.teamName,
    required this.teaminfo,
    required this.projectid,
    required this.projectname,
    //required this.opponent,
  }) : super(key: key);

  @override
  State<Teamtile> createState() => _TeamtileState();
}

class _TeamtileState extends State<Teamtile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyTeamInfoPage(widget.projectid, widget.projectname)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Card(
          child: ListTile(
            title: Text(
              widget.teamName, //DB에서 가져옴
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              //같은 수업에 여러가지 팀플을 대비한 공간
              widget.teaminfo,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}
