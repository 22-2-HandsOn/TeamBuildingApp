import 'package:flutter/material.dart';
import 'package:team/Project/main/teamlist.dart';
import 'package:team/Project/projectList.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/Project/main/teamlist.dart';

class projectTile extends StatefulWidget {
  final String userName;
  final String projectId;
  final String projectName;
  //final String opponent;
  const projectTile({
    Key? key,
    required this.projectId,
    required this.projectName,
    required this.userName,
    //required this.opponent,
  }) : super(key: key);

  @override
  State<projectTile> createState() => _projectTileState();
}

class _projectTileState extends State<projectTile> {
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
                    //projectId: widget.projectId,
                    //projectName: widget.projectName,
                    projectId: "9TLP88ulLsGzOb2ItojA",
                    //projectId: "123",
                    projectName: "Test",
                    userName: widget.userName)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Card(
          child: ListTile(
            title: Text(
              widget.projectName, //DB에서 가져옴
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              //같은 수업에 여러가지 팀플을 대비한 공간
              "",
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}
