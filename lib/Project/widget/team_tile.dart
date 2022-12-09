import 'package:flutter/material.dart';
import 'package:team/professor/profprojectList.dart';
import 'package:team/helper/DatabaseService.dart';

class Teamtile extends StatefulWidget {
  final String userName;
  final String teamId;
  final String teamName;
  //final String opponent;
  const Teamtile({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.userName,
    //required this.opponent,
  }) : super(key: key);

  @override
  State<Teamtile> createState() => _TeamtileState();
}

class _TeamtileState extends State<Teamtile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Card(
            child: ListTile(
          title: Text(
            widget.teamName, //DB에서 가져옴
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            //같은 수업에 여러가지 팀플을 대비한 공간
            "",
            style: const TextStyle(fontSize: 13),
          ),
        )));
  }
}
