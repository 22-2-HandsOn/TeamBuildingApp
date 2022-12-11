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
  //final String opponent;
  const Teamtile({
    Key? key,
    required this.teamName,
    required this.teaminfo,
    required this.projectid,
    required this.projectname,
    required this.isfinished,
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
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5, color: Colors.black38),
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
          child: ListTile(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.teamName, //DB에서 가져옴
                    style: textStyle_title,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Chip(
                      //   backgroundColor: widget.isfinished
                      //       ? Colors.lightBlueAccent.shade200
                      //       : Colors.red.shade300,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(0),
                      //   ),
                      //   labelStyle: TextStyle(
                      //       fontFamily: "GmarketSansTTF",
                      //       fontSize: 12,
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.bold),
                      //   visualDensity:
                      //       VisualDensity(horizontal: 0.0, vertical: -2),
                      //   label: Text("명"),
                      // ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "팀 구성 ",
                                style: TextStyle(
                                  fontFamily: "GmarketSansTTF",
                                  color: Colors.black87,
                                  fontSize: 10,
                                )),
                            WidgetSpan(
                                child: widget.isfinished
                                    ? Icon(Icons.check_box_outlined, size: 12)
                                    : Icon(
                                        Icons.check_box_outline_blank_outlined,
                                        size: 12)),
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
