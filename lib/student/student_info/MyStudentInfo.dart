import 'package:flutter/material.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/helper/ProjectCRUD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ChangeStudentInfo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Candidate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyStudentInfoPage extends StatefulWidget {
  String projectId = "";
  String projectname = "";
  MyStudentInfoPage(this.projectId, this.projectname);

  @override
  State<MyStudentInfoPage> createState() => _MyStudentInfoPageState();
}

class _MyStudentInfoPageState extends State<MyStudentInfoPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  String newComment = "";
  final textStyle = const TextStyle(
      fontFamily: "GmarketSansTTF", fontSize: 12, color: Colors.black54);

  bool isNull = true;
  int candidateNum = 0;
  List<String> docIds = [];
  List<String> teamnames = [];

  late ProjectCRUD projectCRUD = ProjectCRUD(widget.projectId);
  var _controller = TextEditingController();
  String changedText = "";
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
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
          "내 정보",
          style: TextStyle(
              color: Colors.black87,
              fontFamily: "GmarketSansTTF",
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        actions: !isNull
            ? [
                ActionChip(
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
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                    visualDensity:
                        VisualDensity(horizontal: -1, vertical: -3.5),
                    label: Text(candidateNum.toString()),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Candidate(
                                  projectId: widget.projectId,
                                  projectname: widget.projectname,
                                  docIds: docIds,
                                  teamnames: teamnames)));
                    }),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChangeMyStudentInfo(widget.projectId)));
                    },
                    color: Colors.black87,
                    icon: const Icon(Icons.edit_note, size: 22)),
              ]
            : [],
      ),
      body: FutureBuilder(
        future: projectCRUD.getAttendeeInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Future.delayed(Duration.zero, () {
              setState(() {
                // print(snapshot.data['후보팀']);
                candidateNum = snapshot.data['후보팀'] == null
                    ? 0
                    : snapshot.data['후보팀'].length;

                if (candidateNum != 0) {
                  docIds = [];
                  teamnames = [];

                  final datas = snapshot.data['후보팀'];
                  datas.forEach((val) {
                    String docId = val.substring(0, val.indexOf('_'));
                    String teamname = val.substring(val.indexOf('_'));

                    docIds.add(docId);
                    teamnames.add(teamname);
                  });

                  isNull = false;
                }
                ;
              });
            });

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10, height: 1, color: Colors.grey),
                          Text("  학번 및 이름  ", style: textStyle),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Container(height: 1, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Text(
                      "[" +
                          snapshot.data['stu_id'].toString() +
                          "] " +
                          snapshot.data['name'].toString(),
                      style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "GmarketSansTTF",
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10, height: 1, color: Colors.grey),
                          Text("  내 소개  ", style: textStyle),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Container(height: 1, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(bottom: 7),
                      child: Wrap(
                        direction: Axis.horizontal, // 정렬 방향
                        alignment: WrapAlignment.start,
                        spacing: 6, // 상하(좌우) 공간
                        children: _buildChipList(snapshot
                            .data['hashtags']), //타입 1: food, 2: place, 3: pref
                      ),
                    ),
                    Text(
                      snapshot.data['introduction'].toString() == "" ||
                              snapshot.data['introduction'].toString() == "null"
                          ? "아직 소개글을 작성하지 않았습니다. "
                          : snapshot.data['introduction'].toString(),
                      style: snapshot.data['introduction'].toString() == "" ||
                              snapshot.data['introduction'].toString() == "null"
                          ? TextStyle(
                              fontFamily: "GmarketSansTTF",
                              fontSize: 14,
                              color: Colors.black87)
                          : TextStyle(
                              color: Colors.black87,
                              fontFamily: "GmarketSansTTF",
                              fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10, height: 1, color: Colors.grey),
                          Text("  원하는 팀  ", style: textStyle),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Container(height: 1, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Text(
                      snapshot.data['finding_team_info'].toString() == "" ||
                              snapshot.data['finding_team_info'].toString() ==
                                  "null"
                          ? "아직 원하는 팀 정보를 작성하지 않았습니다. "
                          : snapshot.data['finding_team_info'].toString(),
                      style: snapshot.data['finding_team_info'].toString() ==
                                  "" ||
                              snapshot.data['finding_team_info'].toString() ==
                                  "null"
                          ? TextStyle(
                              fontFamily: "GmarketSansTTF",
                              fontSize: 14,
                              color: Colors.black87)
                          : TextStyle(
                              color: Colors.black87,
                              fontFamily: "GmarketSansTTF",
                              fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10, height: 1, color: Colors.grey),
                          Text("  연락 방법  ", style: textStyle),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Container(height: 1, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Contact(snapshot),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10, height: 1, color: Colors.grey),
                          Text("  댓글  ", style: textStyle),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Container(height: 1, color: Colors.grey)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: FutureBuilder(
                          future: projectCRUD.getAttendeeComment(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    TextEditingController _textFieldController =
                                        TextEditingController(
                                            text: snapshot.data[index]
                                                ['content']);
                                    TextEditingController
                                        _textFieldController2 =
                                        TextEditingController();
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(snapshot.data[index]
                                                    ['name']),
                                                Text(snapshot.data[index]
                                                    ['content']),
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                            title:
                                                                Text('대댓글 달기'),
                                                            content: TextField(
                                                              onChanged:
                                                                  (value) {
                                                                newComment =
                                                                    value;
                                                              },
                                                              controller:
                                                                  _textFieldController2,
                                                              decoration:
                                                                  InputDecoration(
                                                                      hintText:
                                                                          "대댓글 달기"),
                                                            ),
                                                            actions: [
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    projectCRUD.addAttendeeReply(
                                                                        newComment,
                                                                        snapshot
                                                                            .data[index]
                                                                            .toString());
                                                                    Navigator.pop(
                                                                        context);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  icon: Icon(
                                                                      Icons
                                                                          .done))
                                                            ]);
                                                      });
                                                },
                                                icon: Icon(Icons.comment_bank)),
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                            title:
                                                                Text('댓글 수정'),
                                                            content: TextField(
                                                              onChanged:
                                                                  (value) {
                                                                changedText =
                                                                    value;
                                                              },
                                                              controller:
                                                                  _textFieldController,
                                                              decoration:
                                                                  InputDecoration(
                                                                      hintText:
                                                                          "댓글 수정"),
                                                            ),
                                                            actions: [
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (changedText
                                                                            .length >
                                                                        0) {
                                                                      projectCRUD.updateAttendeeComment(
                                                                          changedText,
                                                                          snapshot
                                                                              .data[index]
                                                                              .toString());
                                                                      Navigator.pop(
                                                                          context);
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  },
                                                                  icon: Icon(
                                                                      Icons
                                                                          .done))
                                                            ]);
                                                      });
                                                },
                                                icon: Icon(Icons.edit)),
                                            IconButton(
                                                onPressed: () {
                                                  projectCRUD
                                                      .deleteAttendeeComment(
                                                          snapshot.data[index]
                                                              .toString());
                                                  setState(() {});
                                                },
                                                icon: Icon(Icons.delete))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: FutureBuilder(
                                              future:
                                                  projectCRUD.getAttendeeReply(
                                                      snapshot.data[index]
                                                          .toString()),
                                              builder: (context, snapshot2) {
                                                if (snapshot2.hasData) {
                                                  return ListView.builder(
                                                      itemCount:
                                                          snapshot2.data.length,
                                                      itemBuilder:
                                                          (context, index2) {
                                                        TextEditingController
                                                            _textFieldController3 =
                                                            TextEditingController(
                                                                text: snapshot2
                                                                            .data[
                                                                        index2][
                                                                    'content']);
                                                        return Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text("    " +
                                                                        snapshot2.data[index2]
                                                                            [
                                                                            'name']),
                                                                    Text("    " +
                                                                        snapshot2.data[index2]
                                                                            [
                                                                            'content']),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    )
                                                                  ],
                                                                ),
                                                                IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return AlertDialog(
                                                                                title: Text('대댓글 수정'),
                                                                                content: TextField(
                                                                                  onChanged: (value) {
                                                                                    changedText = value;
                                                                                  },
                                                                                  controller: _textFieldController3,
                                                                                  decoration: InputDecoration(hintText: "대댓글 수정"),
                                                                                ),
                                                                                actions: [
                                                                                  IconButton(
                                                                                      onPressed: () {
                                                                                        if (changedText.length > 0) {
                                                                                          projectCRUD.updateAttendeeReply(snapshot.data[index].toString(), snapshot2.data[index2].toString(), changedText);
                                                                                          Navigator.pop(context);
                                                                                          setState(() {});
                                                                                        }
                                                                                      },
                                                                                      icon: Icon(Icons.done))
                                                                                ]);
                                                                          });
                                                                    },
                                                                    icon: Icon(Icons
                                                                        .edit)),
                                                                IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      projectCRUD.deleteAttendeeReply(
                                                                          snapshot.data[index]
                                                                              .toString(),
                                                                          snapshot2
                                                                              .data[index2]
                                                                              .toString());
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    icon: Icon(Icons
                                                                        .delete))
                                                              ],
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                }
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }),
                                        ),
                                      ],
                                    );
                                  });
                            }
                            return Center(child: Text("No Comment"));
                            ;
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
                                projectCRUD.addAttendeeComment(
                                    newComment, false);
                              }
                              newComment = "";
                              _controller.clear();
                              setState(() {});
                            },
                            icon: Icon(Icons.send))
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
                child:
                    CircularProgressIndicator(color: Colors.lightBlueAccent));
          }
        },
      ),
    );
  }

  _buildChipList(List<dynamic> hashtags) {
    List<Widget> chips = [];
    hashtags.forEach((element) {
      chips.add(
        Chip(
          backgroundColor: Colors.grey.shade300,
          label: Text("# " + element),
          visualDensity: VisualDensity(horizontal: -1, vertical: -3.5),
          labelStyle: TextStyle(
              fontFamily: "GmarketSansTTF",
              color: Colors.black87,
              fontSize: 12),
        ),
      );
    });
    return chips;
  }
}

class Contact extends StatelessWidget {
  var snapshot;
  Contact(this.snapshot);
  Widget build(BuildContext context) {
    if (snapshot.data['contact_infos'] != null) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data['contact_infos'].length,
          itemBuilder: (ctx, ind) {
            String title =
                snapshot.data['contact_infos'][ind]['title'].toString();
            String content =
                snapshot.data['contact_infos'][ind]['content'].toString();
            String prefix = "";
            bool notLinkable = false;

            if (RegExp(
                    r"^(((http(s?))\:\/\/)?)([0-9a-zA-Z\-]+\.)+[a-zA-Z]{2,6}(\:[0-9]+)?(\/\S*)?")
                .hasMatch(content)) {
              // print(content);
              if (!RegExp(r"^(((http(s))\:\/\/))").hasMatch(content)) {
                // print("https 달아주기");
                content = "https://" + content;
              }
              // print("링크");
            } else if (RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(content)) {
              // print(content);
              // print("메일");
              prefix = 'mailto:';
            } else if (RegExp(r"^\d{3}-?\d{3,4}-?\d{4}$").hasMatch(content)) {
              // print(content);
              // print("전화");
              prefix = 'tel:';
            } else {
              notLinkable = true;
            }

            return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Chip(
                      avatar: notLinkable
                          ? CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.circle_outlined,
                                  color: Colors.black87, size: 15))
                          : prefix == ""
                              ? CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(Icons.link,
                                      color: Colors.black87, size: 15))
                              : prefix == "mailto:"
                                  ? CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Icon(Icons.mail,
                                          color: Colors.black87, size: 15))
                                  : CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Icon(Icons.phone,
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
                          VisualDensity(horizontal: -1, vertical: -3.5),
                      label: Container(
                          width: 35,
                          alignment: Alignment(0.0, 0.0),
                          child: Text(title))),
                  Text("      "),
                  InkWell(
                      child: Text(
                        '${snapshot.data['contact_infos'][ind]['content'].toString()}',
                        style: notLinkable
                            ? TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16)
                            : TextStyle(
                                color: Colors.lightBlueAccent.shade700,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                      ),
                      onTap: () async {
                        if (content != "") {
                          Uri uri = Uri.parse(prefix + content);
                          launchUrl(uri);
                        }
                      })
                ]);
          });
    } else {
      return Text(
        "아직 연락 방법 목록을 작성하지 않았습니다. ",
        style: TextStyle(
            fontFamily: "GmarketSansTTF", fontSize: 14, color: Colors.black87),
      );
    }
  }
}
