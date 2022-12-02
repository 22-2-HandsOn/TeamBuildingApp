import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team/Project/widget/team_tile.dart';

class TeamListPage extends StatefulWidget {
  final String projectId;
  final String projectName;
  final String userName;
  List<String>? tags;
  TeamListPage(
      {Key? key,
      required this.projectId,
      required this.projectName,
      required this.userName})
      : super(key: key);
  @override
  _TeamListstate createState() => _TeamListstate();
}

class _TeamListstate extends State<TeamListPage> {
  Stream<QuerySnapshot>? teams;
  @override
  void initState() {
    gettingteamData();
    super.initState();
  }

  gettingteamData() async {
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getTeamlist(widget.projectId, widget.tags!)
        .then((snapshot) {
      setState(() {
        teams = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gettingteamData();
      });
      return Scaffold(
        appBar: AppBar(
          elevation: 1,
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
            "팀목록",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 27),
          ),
        ),
        body: Stack(
          children: <Widget>[
            teamList(),
            Container(
              padding: EdgeInsets.all(8),
            )
          ],
        ),
      );
    });
  }

  teamList() {
    return StreamBuilder(
      stream: teams,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  //해당 부분에 tag 관련!
                  return Teamtile(
                      teamId: snapshot.data.docs[index]['teamid'],
                      teamName: snapshot.data.docs[index]['teamname'],
                      userName: widget.userName);
                },
                //controller: unitcontroller,
              )
            : Container();
      },
    );
  }

  nopteamWidget() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              //
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const Text(
            "팀이 없습니다.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
