import 'package:flutter/material.dart';
import 'package:team/professor/profprojectList.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/student/team/MyTeamInfo.dart';
import 'package:team/student/student_info/MyStudentInfo.dart';

class Student_tile extends StatefulWidget {
  final String name;
  final String info;
  final String projectid;
  final String projectname;
  //final String opponent;
  const Student_tile(
      {Key? key,
      required this.projectname,
      required this.name,
      required this.info,
      required this.projectid
      //required this.opponent,
      })
      : super(key: key);

  @override
  State<Student_tile> createState() => _StudenttileState();
}

class _StudenttileState extends State<Student_tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyStudentInfoPage(widget.projectid, widget.name)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
        height: 70,
        child: Card(
          child: ListTile(
            title: Text(
              textAlign: TextAlign.left,
              widget.name, //DB에서 가져옴
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            subtitle: Text(
              //같은 수업에 여러가지 팀플을 대비한 공간
              widget.info,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
      ),
    );
  }
}
