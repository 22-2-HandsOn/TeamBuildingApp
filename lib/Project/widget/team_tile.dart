import 'package:flutter/material.dart';
import 'package:team/professor/profprojectList.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/student/team/MyTeamInfo.dart';

class Teamtile extends StatefulWidget {
  final String teamName;
  final String teaminfo;
  final String projectid;
  final String projectname;
  final bool isfinished;
  final int memNum;
  //final String opponent;
  const Teamtile({
    Key? key,
    required this.teamName,
    required this.teaminfo,
    required this.projectid,
    required this.projectname,
    required this.isfinished,
    required this.memNum,
    //required this.opponent,
  }) : super(key: key);

  @override
  State<Teamtile> createState() => _TeamtileState();
}

class _TeamtileState extends State<Teamtile> {
  final textStyle_title = const TextStyle(
      fontFamily: "GmarketSansTTF",
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.bold);
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
        padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Colors.black26),
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          child: ListTile(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.teamName, //DB에서 가져옴r
                    style: textStyle_title,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 2),
                      Chip(
                        avatar: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.people,
                                color: Colors.black87, size: 15)),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            width: 1,
                            color: Colors.black26,
                          ),
                        ),
                        labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -3.5),
                        label: Container(
                            width: 20,
                            alignment: Alignment(0.0, 0.0),
                            child: Text(widget.memNum.toString() + "명")),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "구성 완료 ",
                                style: TextStyle(
                                    fontFamily: "GmarketSansTTF",
                                    color: Colors.black87,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                            WidgetSpan(
                                child: widget.isfinished
                                    ? Icon(Icons.check_box_outlined,
                                        size: 12, color: Colors.black87)
                                    : Icon(
                                        Icons.check_box_outline_blank_outlined,
                                        size: 12,
                                        color: Colors.black87)),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
