import 'package:flutter/material.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/helper/ProjectCRUD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AddNewTeam.dart';
import 'ChangeTeamInfo.dart';

class OthersTeamInfoPage extends StatefulWidget {
  String projectId = "";
  String projectname = "";
  String teamName = "";
  OthersTeamInfoPage(this.projectId, this.projectname, this.teamName);

  @override
  State<OthersTeamInfoPage> createState() => _OthersTeamInfoPageState();
}

class _OthersTeamInfoPageState extends State<OthersTeamInfoPage> {
  String newComment = "";
  final textStyle = const TextStyle(
      fontFamily: "GmarketSansTTF", fontSize: 12, color: Colors.black54);
  late ProjectCRUD projectCRUD = ProjectCRUD(widget.projectId);
  var _controller = TextEditingController();
  bool isNull = true;
  bool isNowLoading = false;
  String team_id = "";
  String stu_id = "";

  void initState() {
    gettingData();
    super.initState();
  }

  gettingData() {
    projectCRUD.getstu_id().then((value) {
      stu_id = value;
    });
    projectCRUD.getTeamID().then((value) {
      team_id = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              "팀 정보",
              style: TextStyle(
                  color: Colors.black87,
                  fontFamily: "GmarketSansTTF",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            backgroundColor: Colors.white),
        body: FutureBuilder(
            future: projectCRUD.getOthersTeamInfo(widget.teamName),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data["isNull"]);
                if (snapshot.data['isNull'] == null) {
                  Future.delayed(Duration.zero, () {
                    setState(() {
                      isNull = false;
                    });
                  });
                  return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 10, height: 1, color: Colors.grey),
                                Text("  팀 이름  ", style: textStyle),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                        height: 1, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot.data['name'].toString(),
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("      "),
                                SizedBox(
                                    width: 75,
                                    height: 26,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          elevation: 0,
                                          disabledBackgroundColor:
                                              Colors.lightBlueAccent.shade100),
                                      child: !isNowLoading
                                          ? Text(
                                              "참여 신청",
                                              style: TextStyle(
                                                  fontFamily: "GmarketSansTTF",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Container(
                                              width: 10,
                                              height: 10,
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child:
                                                  const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                      onPressed: !isNowLoading
                                          ? () async {
                                              try {
                                                // *TODO : 함수 호출 (초대)
                                                bool flag = false;
                                                await DatabaseService()
                                                    .requsestuToteam(
                                                        widget.projectId,
                                                        team_id,
                                                        stu_id)
                                                    .then((value) {
                                                  flag = value!;
                                                });
                                                if (flag) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      "요청을 성공적으로 보냈습니다.",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "GmarketSansTTF",
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        Colors.lightBlueAccent,
                                                  ));
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      "이미 요청했습니다.",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "GmarketSansTTF",
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        Colors.lightBlueAccent,
                                                  ));
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    "팀원 신청을 실패하였습니다. ",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "GmarketSansTTF",
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      Colors.lightBlueAccent,
                                                ));
                                              }
                                              setState(() {
                                                isNowLoading = false;
                                              });
                                            }
                                          : null,
                                    ))
                              ]),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 10, height: 1, color: Colors.grey),
                                Text("  팀 소개  ", style: textStyle),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                        height: 1, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Text(
                            snapshot.data['introduction'].toString(),
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 10, height: 1, color: Colors.grey),
                                Text("  원하는 팀원  ", style: textStyle),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                        height: 1, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Text(
                            snapshot.data['finding_member_info'].toString(),
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16),
                          ),
                          // *TODO : 해쉬태그는 나중에 원하는 팀원 text 위에 다른 해쉬태그 디자인 참고해서 넣을 것
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 10, height: 1, color: Colors.grey),
                                Text("  댓글  ", style: textStyle),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                        height: 1, color: Colors.grey)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 150,
                            child: FutureBuilder(
                                future: projectCRUD.getTeamComment(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  snapshot.data[index]['name']),
                                              Text(snapshot.data[index]
                                                  ['content']),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          );
                                        });
                                  } else {
                                    return Center(child: Text("No Comment"));
                                  }
                                }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: TextField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '새 댓글',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      newComment = value as String;
                                    });
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (newComment.length > 0) {
                                      projectCRUD.addTeamComment(
                                          newComment, false);
                                    }
                                    newComment = "";
                                    _controller.clear();
                                  },
                                  icon: Icon(Icons.send))
                            ],
                          ),
                        ],
                      ));
                } else {
                  Future.delayed(Duration.zero, () {
                    setState(() {
                      isNull = true;
                    });
                  });

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "소속된 팀이 없습니다.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "GmarketSansTTF",
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                            child: const Text(
                              '+  새 팀 생성',
                              style: TextStyle(
                                  fontFamily: "GmarketSansTTF", fontSize: 16),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddNewTeam(widget.projectId)));
                            })
                      ],
                    ),
                  );
                }
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                        color: Colors.lightBlueAccent));
              }
            }));
  }
}
