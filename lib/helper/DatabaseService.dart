import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team/helper/ProjectCRUD.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference studentCollection =
      FirebaseFirestore.instance.collection("students");

  final CollectionReference professorCollection =
      FirebaseFirestore.instance.collection("professors");

  final CollectionReference teamCollection =
      FirebaseFirestore.instance.collection("projects");

  // saving the userdata
  Future savingstuData(String userName, String email, String stuid) async {
    return await studentCollection.doc(uid).set({
      "username": userName,
      "email": email,
      "projects": [],
      "uid": uid,
      "stu_id": stuid,
    });
  }

  Future savingproData(String userName, String email) async {
    return await professorCollection.doc(uid).set({
      "username": userName,
      "email": email,
      "projects": [],
      "uid": uid,
    });
  }

  // getting user data
  Future gettingstuData(String email) async {
    QuerySnapshot snapshot =
        await studentCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  Future gettingproData(String email) async {
    QuerySnapshot snapshot =
        await professorCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  Future getTeamlist(String projectId) async {
    return teamCollection.doc(projectId).collection("teams").snapshots();
  }

  Future getstulist(String projectId) async {
    return teamCollection.doc(projectId).collection("attendees").snapshots();
  }

  getteamhashtags(String projectId) async {
    return teamCollection
        .doc(projectId)
        .collection("teams_hashtags")
        .doc("Tags")
        .get();
  }

  List<dynamic> getReqToTeam(String projectid, List<dynamic> stuids) {
    // 학번으로 데이터 가져오기
    late final attendeesCollection = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectid)
        .collection("attendees");
    QuerySnapshot<Map<String, dynamic>>? stusnapshot;
    attendeesCollection.get().then((value) {
      stusnapshot = value;
    });

    final result = [];
    final docs = stusnapshot!.docs;
    docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>;
      if (stuids.contains(data['stu_id'])) {
        final temp = data;
        result.add(temp);
      }
    });

    return result;
  }

  getReqToStu() {}

  Future<bool?> requseteamTostu(String projectid, String attendeesuid,
      String teamuid, String teamname) async {
    late final attendeesCollection = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectid)
        .collection("attendees")
        .doc(attendeesuid);
    DocumentSnapshot<Map<String, dynamic>>? stusnapshot;
    await attendeesCollection.get().then((value) {
      stusnapshot = value;
    });

    final data = stusnapshot!.data();
    final teamlist =
        List<String>.from(data?['후보팀'] == null ? [] : data?['후보팀']);
    if (!teamlist.contains(teamuid + "_" + teamname)) {
      await attendeesCollection.update({
        "후보팀": FieldValue.arrayUnion(["${teamuid}_$teamname"])
      });
      return true;
    }
    return false;
  }

  Future<bool?> requsestuToteam(
      String projectid, String teamuid, String stuid) async {
    final teamsCollection = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectid)
        .collection("teams")
        .doc(teamuid);
    DocumentSnapshot<Map<String, dynamic>>? teamsnapshot;
    await teamsCollection.get().then((value) {
      teamsnapshot = value;
    });

    final data = teamsnapshot!.data();
    final stulist =
        List<String>.from(data?['후보학생'] == null ? [] : data?['후보학생']);

    if (!stulist.contains(stuid)) {
      await teamsCollection.update({
        "후보학생": FieldValue.arrayUnion([stuid])
      });
      return true;
    }
    return false;
  }

  responsestu(String projectid, String attendeesuid, String teamuid,
      String teamname, bool accept, String stuid) async {
    late final attendeesCollection = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectid)
        .collection("attendees")
        .doc(attendeesuid);
    DocumentSnapshot<Map<String, dynamic>>? stusnapshot;
    attendeesCollection.get().then((value) {
      stusnapshot = value;
    });

    final data = stusnapshot!.data();
    final teamlist =
        List<String>.from(data?['후보팀'] == null ? [] : data?['후보팀']);
    if (teamlist.contains(teamuid)) {
      await attendeesCollection.update({
        "후보팀": FieldValue.arrayRemove(["${teamuid}_$teamname"])
      });
      if (accept) {
        final teamsCollection = FirebaseFirestore.instance
            .collection("projects")
            .doc(projectid)
            .collection("teams")
            .doc(teamuid);
        DocumentSnapshot<Map<String, dynamic>>? teamsnapshot;
        teamsCollection.get().then((value) {
          teamsnapshot = value;
        });

        final data = teamsnapshot!.data();
        final stulist =
            List<String>.from(data?['member'] == null ? [] : data?['member']);
        if (!stulist.contains(stuid)) {
          await teamsCollection.update({
            "member": FieldValue.arrayUnion([stuid])
          });
        }
      }
    }
  }

  responseteam(String projectid, String attendeesuid, String teamuid,
      String teamname, bool accept, String stuid) async {
    final teamsCollection = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectid)
        .collection("teams")
        .doc(teamuid);
    DocumentSnapshot<Map<String, dynamic>>? teamsnapshot;
    teamsCollection.get().then((value) {
      teamsnapshot = value;
    });

    final data = teamsnapshot!.data();
    final stulist =
        List<String>.from(data?['후보학생'] == null ? [] : data?['후보학생']);
    if (stulist.contains(stuid)) {
      await teamsCollection.update({
        "후보학생": FieldValue.arrayRemove([stuid])
      });
      if (accept) {
        teamsCollection.update({
          "member": FieldValue.arrayUnion([stuid])
        });
      }
    }
  }

  getstuhashtags(String projectId) async {
    return teamCollection
        .doc(projectId)
        .collection("attendees_hashtags")
        .doc("Tags")
        .get();
  }

  getmaxteam(String projectId) async {
    return teamCollection.doc(projectId).get();
  }

  getUserName() async {
    return studentCollection.doc(uid).get();
  }

  getStuID() async {
    return studentCollection.doc(uid).get();
  }

  getprofprojects() async {
    return professorCollection.doc(uid).snapshots();
  }

  getstuprojects() async {
    return studentCollection.doc(uid).snapshots();
  }
}
