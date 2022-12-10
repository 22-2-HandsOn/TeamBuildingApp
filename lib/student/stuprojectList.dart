import 'package:flutter/material.dart';
import 'package:team/Project/projectAddPage.dart';
import 'package:team/helper/helper_function.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team/student/stuProjectTile.dart';

class StuProjectListPage extends StatefulWidget {
  const StuProjectListPage({Key? key}) : super(key: key);

  @override
  _StuProjectListPagestate createState() => _StuProjectListPagestate();
}

class _StuProjectListPagestate extends State<StuProjectListPage> {
  String userName = "";
  String email = "";
  Stream? projects;
  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  String getId(Map<String,dynamic> res) {
    return res['doc_id'].toString();
  }

  String getstu_id(Map<String,dynamic> res) {
    return res['stu_id'].toString();
  }

  String getName(Map<String,dynamic> res) {
    return res['name'].toString();
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
          "수업목록",
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 27),
        ),
      ),
      backgroundColor: Colors.white,
      body: projectlist(),
    );
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
                  return StuProjectTile(
                      projectId: getId(snapshot.data['projects'][reverseIndex]),
                      projectName:
                      getName(snapshot.data['projects'][reverseIndex]),
                      userName: snapshot.data['username'],
                  );
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
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "수업이 없습니다.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
