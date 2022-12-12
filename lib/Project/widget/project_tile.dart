import 'package:flutter/material.dart';
import 'package:team/professor/MyprojectMain.dart';

class projectTile extends StatefulWidget {
  final String userName;
  final String projectId;
  final String projectName;
  final int projectDeadline;
  final bool isFinished;

  //final String opponent;
  const projectTile(
      {Key? key,
      required this.projectId,
      required this.projectName,
      required this.userName,
      required this.projectDeadline,
      required this.isFinished
      //required this.opponent,
      })
      : super(key: key);

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
                builder: (context) => MyProjectMain(
                    widget.projectId, widget.projectName, widget.userName)));
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
                      widget.projectName, //DB에서 가져옴
                      style: textStyle_title,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Chip(
                            // avatar: CircleAvatar(
                            //     backgroundColor: Colors.transparent,
                            //     child: Icon(Icons.date_range_outlined,
                            //         color: Colors.white, size: 15)),
                            backgroundColor: widget.projectDeadline < 0
                                ? Colors.lightBlueAccent.shade200
                                : Colors.red.shade300,
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(15),
                            // ),
                            labelStyle: TextStyle(
                                fontFamily: "GmarketSansTTF",
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -3.5),
                            label: Container(
                              width: 38,
                              alignment: Alignment(0.0, 0.0),
                              child: widget.projectDeadline < 0
                                  ? Text('D - ' +
                                      (widget.projectDeadline * -1).toString())
                                  : widget.projectDeadline == 0
                                      ? Text('D - DAY')
                                      : Text('D + ' +
                                          (widget.projectDeadline).toString()),
                            )),
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
                                  child: widget.isFinished
                                      ? Icon(Icons.check_box_outlined, size: 12)
                                      : Icon(
                                          Icons
                                              .check_box_outline_blank_outlined,
                                          size: 12)),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    )
                  ]),
            ),
            // subtitle: Text(
            //   //같은 수업에 여러가지 팀플을 대비한 공간
            //   "",
            //   style: const TextStyle(fontSize: 12),
            // ),
          )),
    );
  }
}
