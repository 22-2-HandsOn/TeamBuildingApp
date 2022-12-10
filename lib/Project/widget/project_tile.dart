import 'package:flutter/material.dart';
import 'package:team/Project/main/teamlist.dart';
import 'package:team/professor/profprojectList.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/Project/main/teamlist.dart';

class projectTile extends StatefulWidget {
  final String userName;
  final String projectId;
  final String projectName;
  final int projectDeadline;
  //final String opponent;
  const projectTile({
    Key? key,
    required this.projectId,
    required this.projectName,
    required this.userName,
    required this.projectDeadline,
    //required this.opponent,
  }) : super(key: key);

  @override
  State<projectTile> createState() => _projectTileState();
}

class _projectTileState extends State<projectTile> {
  final textStyle_title = const TextStyle(
      fontFamily: "GmarketSansTTF",
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.bold);

  String resentmessage = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TeamListPage(
                    projectId: widget.projectId,
                    projectName: widget.projectName,
                    userName: widget.userName)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5, color: Colors.black38),
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
          child: Expanded(
            child: ListTile(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.projectName, //DB에서 가져옴
                      style: textStyle_title,
                    ),
                    Chip(
                      backgroundColor: widget.projectDeadline < 0
                          ? Colors.lightBlueAccent.shade200
                          : Colors.red.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      labelStyle: TextStyle(
                          fontFamily: "GmarketSansTTF",
                          fontSize: 12,
                          color: widget.projectDeadline < 0
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold),
                      visualDensity:
                          VisualDensity(horizontal: 0.0, vertical: -2),
                      label: widget.projectDeadline < 0
                          ? Text(
                              'D - ' + (widget.projectDeadline * -1).toString())
                          : Text('D + ' + (widget.projectDeadline).toString()),
                    )
                  ]),
              // subtitle: Text(
              //   //같은 수업에 여러가지 팀플을 대비한 공간
              //   "",
              //   style: const TextStyle(fontSize: 12),
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
