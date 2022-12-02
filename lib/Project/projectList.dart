import 'package:flutter/material.dart';
import 'package:team/Project/projectAddPage.dart';
import 'package:team/helper/helper_function.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team/Project/widget/project_tile.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  _ProjectListstate createState() => _ProjectListstate();
}

class _ProjectListstate extends State<ProjectListPage> {
  String userName = "";
  String email = "";
  Stream? projects;
  int type = -1; // 0: stu , 1: pro
  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    await HelperFunctions.getUsertypeSFFromSF().then((val) {
      setState(() {
        type = val!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getstuprojects()
        .then((snapshot) {
      setState(() {
        projects = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gettingUserData();
      });
      return Scaffold(
        appBar: AppBar(
            title: const Text(
              "수업목록",
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 27),
              textAlign: TextAlign.center,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    if (type == 1) {
                      Navigator.of(context).pushNamed('/toProjectAddPage');
                    }
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.grey,
                    size: 30,
                  ))
            ],
            backgroundColor: Colors.white,
            centerTitle: true),
        backgroundColor: Colors.white,
        body: projectlist(),
      );
    });
  }

  projectlist() {
    return StreamBuilder(
      stream: projects,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['projects'] != null) {
            if (snapshot.data['projects'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['projects'].length,
                itemBuilder: (context, index) {
                  int reverseIndex =
                      snapshot.data['projects'].length - index - 1;
                  return projectTile(
                      projectId: getId(snapshot.data['projects'][reverseIndex]),
                      projectName:
                          getName(snapshot.data['projects'][reverseIndex]),
                      userName: snapshot.data['username']);
                },
              );
            } else {
              return noprojectWidget();
            }
          } else {
            return noprojectWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }
      },
    );
  }

  noprojectWidget() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.airline_stops_outlined,
            color: Colors.grey[700],
            size: 50,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "수업이 없습니다.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
